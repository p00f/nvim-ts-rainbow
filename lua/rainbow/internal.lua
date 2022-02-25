local queries = require("nvim-treesitter.query")
local nvim_query = require("vim.treesitter.query")
local parsers = require("nvim-treesitter.parsers")
local configs = require("nvim-treesitter.configs")
local nsid = vim.api.nvim_create_namespace("rainbow_ns")
local extended_languages = { "latex", "html", "verilog" }
local colors = configs.get_module("rainbow").colors
local termcolors = configs.get_module("rainbow").termcolors

--- Find the nesting level of a node.
--- @param node table # Node to find the level of
--- @param len number # Number of colours
--- @param levels table # Levels for the language
local function color_no(node, len, levels)
    local counter = 0
    local current = node
    local found = false
    while current:parent() ~= nil do
        if levels then
            if levels[current:type()] then
                counter = counter + 1
                found = true
            end
        else
            counter = counter + 1
            found = true
        end
        current = current:parent()
    end
    if not found then
        return 1
    elseif counter % len == 0 then
        return len
    else
        return (counter % len)
    end
end

--- Update highlights for a range. Called every time text is changed.
--- @param bufnr number # Buffer number
--- @param changes table # Range of text changes
--- @param tree table # Syntax tree
--- @param lang string # Language
local function update_range(bufnr, changes, tree, lang)
    if vim.fn.pumvisible() == 1 or not lang then
        return
    end

    for _, change in ipairs(changes) do
        --- clear highlights or code commented out later has highlights too
        vim.api.nvim_buf_clear_namespace(bufnr, nsid, change[1], change[3] + 1)

        local root_node = tree:root()
        local query = queries.get_query(lang, "parens")
        local levels = require("rainbow.levels")[lang]
        if query ~= nil then
            for _, node, _ in query:iter_captures(root_node, bufnr, change[1], change[3] + 1) do
                -- set colour for this nesting level
                if not node:has_error() then
                    local color_no_ = color_no(node, #colors, levels)
                    local startRow, startCol, endRow, endCol = node:range() -- range of the capture, zero-indexed
                    if vim.fn.has("nvim-0.7") == 1 then
                        vim.highlight.range(
                            bufnr,
                            nsid,
                            ("rainbowcol" .. color_no_),
                            { startRow, startCol },
                            { endRow, endCol - 1 },
                            {
                                regtype = "",
                                inclusive = true,
                                priority = 120,
                            }
                        )
                    else
                        vim.highlight.range(
                            bufnr,
                            nsid,
                            ("rainbowcol" .. color_no_),
                            { startRow, startCol },
                            { endRow, endCol - 1 },
                            "blockwise",
                            true,
                            120
                        )
                    end
                end
            end
        end
    end
end

--- Update highlights for every tree in given buffer.
--- @param bufnr number # Buffer number
local function full_update(bufnr)
    local parser = parsers.get_parser(bufnr)
    parser:for_each_tree(function(tree, sub_parser)
        update_range(bufnr, { { tree:root():range() } }, tree, sub_parser:lang())
    end)
end

--- Regsiter predicates for extended mode.
--- @param config table # Configuration for the `rainbow` module in nvim-treesitter
local function register_predicates(config)
    local extended_mode

    if type(config.extended_mode) == "table" then
        extended_mode = {}
        for _, lang in pairs(config.extended_mode) do
            extended_mode[lang] = true
        end
    elseif type(config.extended_mode) == "boolean" then
        extended_mode = config.extended_mode
    else
        vim.api.nvim_err_writeln("nvim-ts-rainbow: `extended_mode` can be a boolean or a table")
    end

    for _, lang in ipairs(extended_languages) do
        local enable_extended_mode
        if type(extended_mode) == "table" then
            enable_extended_mode = extended_mode[lang]
        else
            enable_extended_mode = extended_mode
        end
        nvim_query.add_predicate(lang .. "-extended-rainbow-mode?", function()
            return enable_extended_mode
        end, true)
    end
end

local state_table = {}

local M = {}

--- Define highlight groups. This had to be a function to allow an autocmd doing this at colorscheme change.
function M.defhl()
    for i = 1, #colors do
        local s = "highlight default rainbowcol"
            .. i
            .. " guifg="
            .. colors[i]
            .. " ctermfg="
            .. termcolors[i]
        vim.cmd(s)
    end
end

M.defhl()

--- Attach module to buffer. Called when new buffer is opened or `:TSBufEnable rainbow`.
--- @param bufnr number # Buffer number
--- @param lang string # Buffer language
function M.attach(bufnr, lang)
    local config = configs.get_module("rainbow")
    local max_file_lines = config.max_file_lines
    if max_file_lines ~= nil and vim.api.nvim_buf_line_count(bufnr) > max_file_lines then
        return
    end
    register_predicates(config)
    full_update(bufnr)
    state_table[bufnr] = true
    local parser = parsers.get_parser(bufnr, lang)
    parser:register_cbs({
        on_changedtree = function(changes, tree)
            if state_table[bufnr] == true then
                update_range(bufnr, changes, tree, lang)
            else
                return
            end
        end,
    })
end

--- Detach module from buffer. Called when `:TSBufDisable rainbow`.
--- @param bufnr number # Buffer number
function M.detach(bufnr)
    state_table[bufnr] = false
    local hlmap = vim.treesitter.highlighter.hl_map
    hlmap["punctuation.bracket"] = "TSPunctBracket"
    vim.api.nvim_buf_clear_namespace(bufnr, nsid, 0, -1)
end

return M
