local api = vim.api
local ts = vim.treesitter
local queries = require "nvim-treesitter.query"
local parsers = require'nvim-treesitter.parsers'
local nsid = vim.api.nvim_create_namespace('rainbow')

local M = {}
function M.attach(bufnr, lang)
  local parser = parsers.get_parser(bufnr, lang)
  local query = queries.get_query(lang, "parens")
  local tree = parser:parse()
  if not query then return end
  for id, node in query:iter_captures(tree:root(),0,1,20) do
    -- typically useful info about the node:
    local type = node:type() -- type of the captured node
    local row1, col1, row2, col2 = node:range() -- range of the capture
    vim.api.nvim_buf_set_extmark(0, nsid, row1, col1, {0, row2, col2, 'rainbowcol'})
  end

end

function M.detach(bufnr)
  if M.highlighters[bufnr] then
    M.highlighters[bufnr]:set_query("")
    M.highlighters[bufnr] = nil
  end
  api.nvim_buf_set_option(bufnr, 'syntax', 'on')
end

return M
