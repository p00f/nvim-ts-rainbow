local queries = require("nvim-treesitter.query")
local parsers = require("nvim-treesitter.parsers")
local nsid = vim.api.nvim_create_namespace("rainbow_ns")
local colors = require("rainbow.colors")
local termcolors = require("rainbow.termcolors")
local uv = vim.loop

-- define highlight groups
for i = 1, #colors do
	local s = "highlight default rainbowcol" .. i .. " guifg=" .. colors[i] .. " ctermfg=" .. termcolors[i]
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
        if (counter % len == 0) then
                return len
        else
                return (counter % len)
        end
end

local callbackfn = function(bufnr, parser, query)
        -- no need to do anything when pum is open
        if vim.fn.pumvisible() == 1 then
                return
        end

        --clear highlights or code commented out later has highlights too
        vim.api.nvim_buf_clear_namespace(bufnr, nsid, 0, -1)
        local root_node = parser:parse()[1]:root()
        for _, node, _ in query:iter_captures(root_node, bufnr) do
                -- set colour for this nesting level
                local color_no_ = color_no(node, #colors)
                local _, startCol, endRow, endCol = node:range() -- range of the capture, zero-indexed
                vim.highlight.range(
                        bufnr,
                        nsid,
                        ("rainbowcol" .. color_no_),
                        { endRow, startCol },
                        { endRow, endCol - 1 },
                        "blockwise",
                        true
                )
        end
end

local function try_async(f, bufnr, parser, query)
        local cancel = false
        return function()
                if cancel then
                        return true
                end
                local async_handle
                async_handle = uv.new_async(vim.schedule_wrap(function()
                        f(bufnr, parser, query)
                        async_handle:close()
                end))
                async_handle:send()
        end, function()
                cancel = true
        end
end

Rainbow_state_table = {} -- tracks which buffers have rainbow disabled

local M = {}

function M.attach(bufnr, lang)
        local parser = parsers.get_parser(bufnr, lang)
        local query = queries.get_query(lang, "parens")

        local attachf, detachf = try_async(callbackfn, bufnr, parser, query)
        Rainbow_state_table[bufnr] = detachf
        callbackfn(bufnr, parser, query) -- do it on attach
        vim.api.nvim_buf_attach(bufnr, false, { on_lines = attachf }) --do it on every change
end

function M.detach(bufnr)
        local detachf = Rainbow_state_table[bufnr]
        detachf()
        local hlmap = vim.treesitter.highlighter.hl_map
        hlmap["punctuation.bracket"] = "TSPunctBracket"
        vim.api.nvim_buf_clear_namespace(bufnr, nsid, 0, -1)
end

return M
