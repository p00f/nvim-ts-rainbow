---@class ExpectedRainbowHighlight
---@field line number 0-based index of the line to be highlighted
---@field column number 0-based index of the character to be highlighted
---@field rainbow_level string The expected level of the rainbow to use in the highlight

---@param source_code_lines string[]
---@return ExpectedRainbowHighlight[]
local function get_expected_highlights(source_code_lines)
    ---@type ExpectedRainbowHighlight[]
    local expected_highlights = {}

    for line_index, line in ipairs(source_code_lines) do
        local matches = string.find(line, "hl[%s%d]*")
        if matches ~= nil then
            for char_index = 1, #line do
                local char = line:sub(char_index, char_index)
                if string.match(char, "%d") then
                    table.insert(expected_highlights, {
                        -- NOTE: subtract 1 to get the index to be 0-based,
                        -- and another 1 because the hl-line describes the
                        -- expected highlights for the line above the hl-line
                        line = line_index - 2,
                        column = char_index - 1,
                        rainbow_level = char,
                    })
                end
            end
        end
    end

    return expected_highlights
end

---Returns the name of the rainbow highlight group for a given level
---@param level string
---@return string
local function get_rainbow_highlight_group_name(level)
    return "rainbowcol" .. level
end

---Prepares a line with the invalid column marked by ^.
---Used in error reporting.
---@param invalid_column number 0-based
---@return string
local function get_error_marker_line(invalid_column)
    return string.rep(" ", invalid_column) .. "^"
end

---Prints the line with an error marker line that points to some character.
---@param line string The line to print
---@param line_number number The line number to be printed
---@param error_marker_column number 0-based column number to place the error marker
local function print_line_with_error_marker(line, line_number, error_marker_column)
    local line_number_width = 3

    print(string.format("%" .. line_number_width .. "d: %s", line_number, line))
    print(
        string.format(
            "%" .. line_number_width .. "s  %s\n",
            "",
            get_error_marker_line(error_marker_column)
        )
    )
end

---@class HighlightedSymbol
---@field line number 0-based
---@field column number 0-based
---@field hl_group string

---@param extmarks table[] Extmark returned from nvim_buf_get_extmarks
---@return HighlightedSymbol[]
local function get_highlighted_symbols_from_extmarks(extmarks)
    ---@type HighlightedSymbol[]
    local highlighted_symbols = {}

    for _, extmark in ipairs(extmarks) do
        -- TODO: support multi-line extmarks
        local line = extmark[2]
        local start_col = extmark[3]
        local details = extmark[4]
        ---Extmark is end_col-exclusive
        local end_col = details.end_col

        for col = start_col, end_col - 1 do
            table.insert(highlighted_symbols, {
                line = line,
                column = col,
                hl_group = details.hl_group,
            })
        end
    end

    return highlighted_symbols
end

---Prunes duplicate highlighted symbols ensuring that each symbol is highlighted
---with a single highlight group.
---nvim-ts-rainbow sometimes sets duplicated extmarks to highlight symbols.
---Not pruning duplicates would mean errors would be reported multiple times
--(once for each duplicate extmark).
---@param highlighted_symbols HighlightedSymbol[] The table of highlighted symbols. it will be modified in place.
---@param source_code_lines string[] Source code lines used for error reporting
local function remove_duplicate_highlighted_symbols(highlighted_symbols, source_code_lines)
    local multiple_highlights_for_symbols = false

    -- NOTE: manual index tracking because one loop iteration can remove
    -- multiple elements. Using iterators could iterate over removed indices
    local index = 1
    while index <= #highlighted_symbols do
        local symbol = highlighted_symbols[index]

        -- The body of the loop tries to prune duplicates in the range of
        -- index+1..#highlighted_symbols

        -- NOTE: loop from the end to allow removing elements in the loop while
        -- preserving indices that will be looped over in the future
        for other_symbol_index = #highlighted_symbols, index + 1, -1 do
            local other_symbol = highlighted_symbols[other_symbol_index]
            if symbol.line == other_symbol.line and symbol.column == other_symbol.column then
                if symbol.hl_group == other_symbol.hl_group then
                    table.remove(highlighted_symbols, other_symbol_index)
                else
                    print("Symbol has multiple different highlight groups assigned to it.")
                    print(
                        string.format(
                            "Found highlight groups: %s %s",
                            symbol.hl_group,
                            other_symbol.hl_group
                        )
                    )

                    print_line_with_error_marker(
                        source_code_lines[symbol.line + 1],
                        symbol.line + 1,
                        symbol.column
                    )
                    multiple_highlights_for_symbols = true
                end
            end
        end

        index = index + 1
    end

    assert(not multiple_highlights_for_symbols, "There are multiple highlights for some symbols")
end

local function verify_highlights_in_file(filename)
    local extended_mode = string.find(filename, "extended") ~= nil
    local rainbow_module = require("nvim-treesitter.configs").get_module("rainbow")
    rainbow_module.extended_mode = extended_mode

    vim.cmd.edit(filename)

    local source_code_lines = vim.api.nvim_buf_get_lines(0, 0, -1, 1)

    vim.api.nvim_buf_set_lines(0, 0, -1, true, source_code_lines)

    local rainbow_ns_id = vim.api.nvim_get_namespaces().rainbow_ns
    assert.not_equal(nil, rainbow_ns_id, "rainbow namespace not found")

    local parser = require("nvim-treesitter.parsers").get_parser(0)
    assert.truthy(parser, "Parser not found")
    parser:parse()

    -- NOTE: nvim_buf_get_extmarks does not return extmarks that contain
    -- some range. It only returns extmarks within the given range.
    -- We cannot use it to look for extmarks for a given symbol, because sometimes
    -- the extmarks are for a range (e.g. when highlighting a JSX tag, the
    -- whole range "div" is a single extmark and asking for an extmark for
    -- the position of "i" returns nothing).
    -- Thus, we must filter through all extmarks set on the buffer and
    -- check each symbol.
    local extmarks = vim.api.nvim_buf_get_extmarks(0, rainbow_ns_id, 0, -1, { details = true })
    local highlighted_symbols = get_highlighted_symbols_from_extmarks(extmarks)

    remove_duplicate_highlighted_symbols(highlighted_symbols, source_code_lines)

    local some_symbol_not_highlighted = false
    local invalid_highlight = false
    for _, expected_highlight in ipairs(get_expected_highlights(source_code_lines)) do
        local symbol_highlighted = false

        -- NOTE: loop from the end to allow removing elements inside of the loop
        -- without changing the indices that will be looped over
        for i = #highlighted_symbols, 1, -1 do
            local highlighted_symbol = highlighted_symbols[i]
            if
                highlighted_symbol.line == expected_highlight.line
                and highlighted_symbol.column == expected_highlight.column
            then
                symbol_highlighted = true

                local expected_highlight_group =
                    get_rainbow_highlight_group_name(expected_highlight.rainbow_level)
                if expected_highlight_group ~= highlighted_symbol.hl_group then
                    invalid_highlight = true
                    print(
                        string.format(
                            'Invalid rainbow highlight group. Expected "%s", found "%s"',
                            expected_highlight_group,
                            highlighted_symbol.hl_group
                        )
                    )
                    print_line_with_error_marker(
                        source_code_lines[expected_highlight.line + 1],
                        expected_highlight.line + 1,
                        expected_highlight.column
                    )
                end

                -- NOTE: remove the matched highlighted symbol to later
                -- check that all highlighted symbols matched some expected
                -- highlight
                table.remove(highlighted_symbols, i)
            end
        end

        if not symbol_highlighted then
            print(
                string.format(
                    'No highlight groups detected. Expected "%s".',
                    get_rainbow_highlight_group_name(expected_highlight.rainbow_level)
                )
            )
            print_line_with_error_marker(
                source_code_lines[expected_highlight.line + 1],
                expected_highlight.line + 1,
                expected_highlight.column
            )
            some_symbol_not_highlighted = true
        end
    end

    for _, symbol in ipairs(highlighted_symbols) do
        print(
            string.format(
                'Symbol was extraneously highlighted with highlight group "%s"',
                symbol.hl_group
            )
        )
        print_line_with_error_marker(
            source_code_lines[symbol.line + 1],
            symbol.line + 1,
            symbol.column
        )
    end
    assert(not invalid_highlight, "Some symbol was incorrectly highlighted")
    assert(not some_symbol_not_highlighted, "Some symbol was not highlighted")
    assert(#highlighted_symbols == 0, "Extraneous highlights")
end

describe("Highlighting integration tests", function()
    local files = vim.fn.glob("test/highlight/**/*.*", nil, true)

    for _, filename in ipairs(files) do
        if not string.match(filename, "highlight_spec.lua") then
            it(filename, function()
                verify_highlights_in_file(filename)
            end)
        end
    end
end)
