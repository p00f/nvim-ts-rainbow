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

describe("TSX highlighting", function()
    it("should highlight", function()
        -- TODO: enable based on file name
        require("nvim-treesitter.configs").get_module("rainbow").extended_mode = true
        vim.cmd.edit("test.tsx")
        assert.equals("typescriptreact", vim.bo.filetype)

        -- TODO: read source code from files
        -- https://github.com/nvim-treesitter/nvim-treesitter/blob/a9a6493b1eeba458757903352e0d3dc4b54fd4f2/tests/query/highlights_spec.lua#L100
        local source_code = [[
    const abc = {};
//hl            11
    function MyComponent() {
//hl                    11 1
      return <div>Hello world</div>;
//hl         22222           222221
    }
//hl1
        ]]
        local source_code_lines = vim.fn.split(source_code, "\n")

        vim.api.nvim_buf_set_lines(0, 0, -1, true, source_code_lines)

        local rainbow_ns_id = vim.api.nvim_get_namespaces().rainbow_ns
        assert.not_equal(nil, rainbow_ns_id)

        local parser = require("nvim-treesitter.parsers").get_parser(0)
        assert.truthy(parser)
        parser:parse()

        for _, expected_highlight in ipairs(get_expected_highlights(source_code_lines)) do
            local highlight_position = { expected_highlight.line, expected_highlight.column }

            -- NOTE: does not return extmarks over a region when asking for a character inside of that region
            -- TODO: refactor to get all buffer extmarks and then filter through it (`is_inside_extmark`)
            local extmarks = vim.api.nvim_buf_get_extmarks(
                0,
                rainbow_ns_id,
                highlight_position,
                highlight_position,
                { details = true }
            )

            -- TODO: verify that there are no extraneous highlights

            if vim.tbl_isempty(extmarks) then
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
            end

            -- NOTE: nvim-ts-rainbow sometimes sets duplicated extmarks to highlight.
            -- The extmarks should be the same.
            for _, extmark in ipairs(extmarks) do
                local details = extmark[4]
                local expected_highlight_group =
                    get_rainbow_highlight_group_name(expected_highlight.rainbow_level)
                if expected_highlight_group ~= details.hl_group then
                    print(
                        string.format(
                            'Invalid rainbow highlight group. Expected "%s", found "%s"',
                            expected_highlight_group,
                            details.hl_group
                        )
                    )
                    print_line_with_error_marker(
                        source_code_lines[expected_highlight.line + 1],
                        expected_highlight.line + 1,
                        expected_highlight.column
                    )
                end
            end
        end
    end)
end)
