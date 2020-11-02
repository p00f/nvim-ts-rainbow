local M = {}
local queries = require "nvim-treesitter.query"
local configs = require "nvim-treesitter.configs"

function M.attach(bufnr, lang)
  local parser = parsers.get_parser(bufnr, lang)
  local config = configs.get_module('rainbow')
  local query = queries.get_query(lang, "highlights")
  if not query then return end

  M.highlighters[bufnr] = ts.highlighter.new(parser, query)
  
end

function M.detach(bufnr)
  if M.highlighters[bufnr] then
    M.highlighters[bufnr]:set_query("")
    M.highlighters[bufnr] = nil
  end
  api.nvim_buf_set_option(bufnr, 'syntax', 'on')
end

return M
