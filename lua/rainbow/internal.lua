local api = vim.api
local ts = vim.treesitter
local queries = require "nvim-treesitter.query"
local parsers = require'nvim-treesitter.parsers'
local nsid = vim.api.nvim_create_namespace('rainbow')

local M = {}
function M.attach(bufnr, lang)
  local parser = parsers.get_parser(bufnr, lang)
  local query = queries.get_query(lang, "parens")
  local tree = parser:parse():root()
  if not query then return end
  for id, node in query:iter_captures(tree:root(),0,1,20) do
    local row1, col1, row2, col2 = node:range() -- range of the capture
    vim.api.nvim_buf_set_extmark(bufnr, nsid, row1, col1, {0, row2, col2, 'rainbowcol'})
  end

end

function M.detach(bufnr)
  
end

return M
