local queries = require "nvim-treesitter.query"
local nsid = vim.api.nvim_create_namespace("rainbow_ns")
local colors = require "rainbow.colors"
local uv = vim.loop

-- define highlight groups
for i = 1, #colors do
  local s = "highlight default rainbowcol" .. i .. " guifg=" .. colors[i]
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



local callbackfn = function(bufnr)

  -- no need to do anything when pum is open
  if vim.fn.pumvisible() == 1 then
    return
  end

  --clear highlights or code commented out later has highlights too
  vim.api.nvim_buf_clear_namespace(bufnr, nsid, 0, -1)

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

local function try_async(f, bufnr)
  return function()
    local async_handle
    async_handle = uv.new_async(vim.schedule_wrap(function()
      f(bufnr)
      async_handle:close()
    end))
    async_handle:send()
  end
end

local function try_async1(f, bufnr)
  local cancel = false
  return function()
    if cancel then return true end
    local async_handle
    async_handle = uv.new_async(vim.schedule_wrap(function()
      f(bufnr)
      async_handle:close()
    end))
    async_handle:send()
  end, function() cancel = true end
end

function M.attach(bufnr, lang)
  local hlmap = vim.treesitter.highlighter.hl_map
  hlmap["punctuation.bracket"] = nil

  local query = queries.get_query(lang, "highlights")
  if not query then
    return
  end
  local attach, _ = try_async1(callbackfn, bufnr)
  callbackfn(bufnr) -- do it on attach
  vim.api.nvim_buf_attach( --do it on every change
    bufnr,
    false,
    { on_lines = attach()}
  )
end

function M.detach(bufnr)
  local _, detach = try_async1(callbackfn, bufnr)
  detach()
  local hlmap = vim.treesitter.highlighter.hl_map
  hlmap["punctuation.bracket"] = "TSPunctBracket"
  vim.api.nvim_buf_clear_namespace(bufnr, nsid, 0, -1)
end

return M
