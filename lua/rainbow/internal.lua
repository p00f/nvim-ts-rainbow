local queries = require("nvim-treesitter.query")
local nvim_query = require("vim.treesitter.query")
local parsers = require("nvim-treesitter.parsers")
local configs = require("nvim-treesitter.configs")
local nsid = vim.api.nvim_create_namespace("rainbow_ns")
local extended_languages = { "latex", "html" }

-- Try to get colors from config
local function get_colors(conf, name)
    local config = conf.get_module("rainbow")

    if config[name] ~= nil and type(config[name]) == "table" then
        return config[name]
    else
        return require("rainbow." .. name)
    end
end

local colors = get_colors(configs, "colors")
local termcolors = get_colors(configs, "termcolors")

-- finds the nesting level of given node
local function color_no(mynode, len, levels)
    local counter = 0
    local current = mynode
    while current:parent() ~= nil do
        if levels then
            if levels[current:type()] then
                counter = counter + 1
            end
        else
            counter = counter + 1
        end
        current = current:parent()
    end
    if counter % len == 0 then
        return len
    else
        return (counter % len)
    end
end

local function callbackfn(bufnr, changes, tree, lang)
    if vim.fn.pumvisible() == 1 or not lang then
        return
    end

    for _, change in ipairs(changes) do
        ----clear highlights or code commented out later has highlights too
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
                    vim.highlight.range(
                        bufnr,
                        nsid,
                        ("rainbowcol" .. color_no_),
                        { startRow, startCol },
                        { endRow, endCol - 1 },
                        "blockwise",
                        true
                    )
                end
            end
        end
    end
end

local function full_update(bufnr)
    local parser = parsers.get_parser(bufnr)
    parser:for_each_tree(function(tree, sub_parser)
        callbackfn(bufnr, { { tree:root():range() } }, tree, sub_parser:lang())
    end)
end

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

function M.defhl()
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
end

M.defhl()

function M.attach(bufnr, lang)
    local parser = parsers.get_parser(bufnr, lang)
    local config = configs.get_module("rainbow")
    register_predicates(config)
    full_update(bufnr)
    state_table[bufnr] = true
    parser:register_cbs({
        on_changedtree = function(changes, tree)
            if state_table[bufnr] == true then
                callbackfn(bufnr, changes, tree, lang)
            else
                return
            end
        end,
    })
end

function M.detach(bufnr)
    state_table[bufnr] = false
    local hlmap = vim.treesitter.highlighter.hl_map
    hlmap["punctuation.bracket"] = "TSPunctBracket"
    vim.api.nvim_buf_clear_namespace(bufnr, nsid, 0, -1)
end

return M
