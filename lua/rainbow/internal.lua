local queries = require "nvim-treesitter.query"
local nsid = vim.api.nvim_create_namespace("rainbow_ns")
local colors = require "rainbow.colors"

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

local callbackfn = function(bufnr)
  if vim.fn.pumvisible() == 1 then
      return
  end
  local matches = queries.get_capture_matches(bufnr, "@punctuation.bracket", "highlights")
  for _, node in ipairs(matches) do
    -- set colour for this nesting level
    local color_no_ = color_no(node.node, #colors)
    local _, _, endRow, endCol = node.node:range() -- range of the capture, zero-indexed
    vim.highlight.range(
      bufnr,
      nsid,
      ("rainbowcol" .. color_no_),
      {endRow, endCol - 1},
      {endRow, endCol - 1},
      "blockwise",
      true
    )
  end
end

local M = {}

local uv = vim.loop

local function try_async(f)
  if not f then return end
  return function(...)
    local async_handle
    async_handle = uv.new_async(vim.schedule_wrap(function(...)
      f(...)
      async_handle:close()
    end))
    async_handle:send(...)
  end
end

function M.attach(bufnr, lang)
  require "nvim-treesitter.highlight"
  local hlmap = vim.treesitter.highlighter.hl_map
  hlmap["punctuation.bracket"] = nil

  local query = queries.get_query(lang, "highlights")
  if not query then
    return
  end

  for i = 1, #colors do -- define highlight groups
    local s = "highlight default rainbowcol" .. i .. " guifg=" .. colors[i]
    vim.cmd(s)
  end

  callbackfn(bufnr) -- do it on intial load
  vim.api.nvim_buf_attach( --do it on every change
    bufnr,
    false,
    {
      on_lines = try_async(callbackfn(bufnr))
    }
  )
end

function M.detach(bufnr)
  vim.api.nvim_buf_attach(
    bufnr,
    false,
    {
      on_lines = function()
        return true
      end
    }
  )
  require "nvim-treesitter.highlight"
  local hlmap = vim.treesitter.highlighter.hl_map
  hlmap["punctuation.bracket"] = "TSPunctBracket"
  vim.api.nvim_buf_clear_namespace(bufnr, nsid, 0, -1)
end

return M
