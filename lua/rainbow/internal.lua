local queries = require "nvim-treesitter.query"
local parsers = require "nvim-treesitter.parsers"
local nsid = vim.api.nvim_create_namespace("rainbow_ns")

local colors = require "rainbow.colors"

local callbackfn = function(parser, query, bufnr)
  local index = 1
  local tree = parser:parse()
  for _, node in query:iter_captures(tree:root(), bufnr, 0, 0) do
    -- set colour for this nesting level
    local color = 0
    if index % 7 == 0 then
      color = 7
    else
      color = (index % 7)
    end

    local startRow, startCol, endRow, endCol = node:range() -- range of the capture, zero-indexed
    vim.highlight.range(
      bufnr,
      nsid,
      ("rainbowcol" .. color),
      {startRow, startCol},
      {startRow, startCol},
      "blockwise",
      true
    )
    vim.highlight.range(
      bufnr,
      nsid,
      ("rainbowcol" .. color),
      {endRow, endCol - 1},
      {endRow, endCol - 1},
      "blockwise",
      true
    )
    index = index + 1
  end
end

local M = {}

function M.attach(bufnr, lang)
  local parser = parsers.get_parser(bufnr, lang)
  local query = queries.get_query(lang, "parens")
  if not query then
    return
  end

  for i = 1, 7 do -- define highlight groups
    local s = "highlight rainbowcol" .. i .. " guifg=" .. colors[i]
    vim.cmd(s)
  end
  vim.cmd [[highlight te guifg=#000000]]
  callbackfn(parser, query, bufnr) -- do it on intial load
  vim.api.nvim_buf_attach( --do it one every change
    bufnr,
    false,
    {
      on_lines = function()
        callbackfn(parser, query, bufnr)
      end
    }
  )
end

function M.detach(bufnr)
  vim.api.nvim_buf_detach(bufnr)
end

return M
