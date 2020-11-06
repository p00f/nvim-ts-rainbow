local queries = require "nvim-treesitter.query"
local parsers = require "nvim-treesitter.parsers"
local nsid = vim.api.nvim_create_namespace("rainbow_ns")

local colors = {
  "#7F00FF",
  "#3F00FF",
  "#0000FF",
  "#00FF00",
  "#FFFF00",
  "#FF7F00",
  "#FF0000"
}

local M = {}

function M.attach(bufnr, lang)
  local parser = parsers.get_parser(bufnr, lang)
  local query = queries.get_query(lang, "parens")
  local tree = parser:parse()
  if not query then
    return
  end

  for i = 1, 7 do -- define highlight groups
    local s = "highlight rainbowcol" .. i .. " guifg=" .. colors[i]
    vim.cmd(s)
  end

  local index = 1
  for _, node in query:iter_captures(tree:root(), bufnr, 1, 20) do

    -- set colour for this nesting level
    local color = 0
    if index % 7 == 0 then
      color = 7
    else
      color = (index % 7)
    end

    local startRow, startCol, endRow, endCol = node:range() -- range of the capture, zero-indexed
    vim.api.nvim_buf_set_extmark( --highlight opening paren (works)
      bufnr,
      nsid,
      startRow,
      startCol,
      {end_line = startRow, end_col = startCol + 1, hl_group = "rainbowcol" .. color}
    )
    vim.api.nvim_buf_set_extmark( --highlight closing paren (doesn't work)
      bufnr,
      nsid,
      endRow,
      endCol,
      {end_line = endRow + 1, end_col = 0, hl_group = "rainbowcol" .. color}
    )
    index = index + 1
  end
end

function M.detach(bufnr)
end

return M
