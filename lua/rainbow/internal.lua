local queries = require("nvim-treesitter.query")
local nvim_query = require("vim.treesitter.query")
local parsers = require("nvim-treesitter.parsers")
local configs = require("nvim-treesitter.configs")
local nsid = vim.api.nvim_create_namespace("rainbow_ns")
local colors = require("rainbow.colors")
local termcolors = require("rainbow.termcolors")
local extended_languages = { "latex" }

-- define highlight groups
for i = 1, #colors do
    local s = "highlight default rainbowcol"
        .. i
        .. " guifg="
        .. colors[i]
        .. " ctermfg="
        .. termcolors[i]
    vim.cmd(s)
end

-- finds the nesting level of given node
local function color_no(mynode, len)
    local counter = 0
    local current = mynode
    while current:parent() ~= nil do
        counter = counter + 1
        current = current:parent()
    end
    if counter % len == 0 then
        return len
    else
        return (counter % len)
    end
end

local function callbackfn(bufnr, changes, tree, lang)
    --vim.schedule_wrap(function()
    -- no need to do anything when pum is open
    if vim.fn.pumvisible() == 1 or not lang then
        return
    end

    for _, change in ipairs(changes) do
        ----clear highlights or code commented out later has highlights too
        -- vim.api.nvim_buf_clear_namespace(bufnr, nsid, change[1], change[3])
        local root_node = tree:root()
        local query = queries.get_query(lang, "parens")
        if query ~= nil then
            for _, node, _ in query:iter_captures(root_node, bufnr, change[1], change[3] + 1) do
                -- set colour for this nesting level
                if not node:has_error() then
                    local color_no_ = color_no(node, #colors)
                    local startRow, startCol, endRow, endCol = node:range() -- range of the capture, zero-indexed
                    vim.highlight.range(bufnr, nsid, ("rainbowcol" .. color_no_), {
                        startRow,
                        startCol,
                    }, {
                        endRow,
                        endCol - 1,
                    }, "blockwise", true)
                end
            end
        end
    end
    --end)()
end

local function full_update(bufnr)
    local parser = parsers.get_parser(bufnr)
    parser:for_each_tree(function(tree, sub_parser)
        callbackfn(bufnr, { { tree:root():range() } }, tree, sub_parser:lang())
    end)
end

local function register_predicates(config)
    for _, lang in ipairs(extended_languages) do
        local enable_extended_mode
        if type(config.extended_mode) == "table" then
            enable_extended_mode = config.extended_mode[lang]
        else
            enable_extended_mode = config.extended_mode
        end
        nvim_query.add_predicate(lang .. "-extended-rainbow-mode?", function()
            return enable_extended_mode
        end, true)
    end
end

local state_table = {}
local function enable_or_disable(bufnr, state, parser, lang)
    if parser and state then
        state_table[bufnr] = { parser, state } -- could very well write `true` in place of `state` since parser is only supplied when state is true
    end
    if state then
        state_table[bufnr][1] = parser
        full_update(bufnr)
        parser:register_cbs({
            on_changedtree = function(changes, tree)
                callbackfn(bufnr, changes, tree, lang)
            end,
        })
    else
        state_table[bufnr][1]:invalidate(false)
    end
end

local M = {}

function M.attach(bufnr, lang)
    local parser = parsers.get_parser(bufnr, lang)
    local config = configs.get_module("rainbow")
    register_predicates(config)
    enable_or_disable(bufnr, true, parser, lang)
end

function M.detach(bufnr)
    enable_or_disable(bufnr, false)
    local hlmap = vim.treesitter.highlighter.hl_map
    hlmap["punctuation.bracket"] = "TSPunctBracket"
    vim.api.nvim_buf_clear_namespace(bufnr, nsid, 0, -1)
end

return M
