local queries = require "nvim-treesitter.query"
local nsid = vim.api.nvim_create_namespace("rainbow_ns")
local colors = require "rainbow.colors"

local function color_no(mynode)
  local counter = 0
  local current = mynode
  while current:parent() ~= nil do
    counter = counter + 1
    current = current:parent()
  end
  if (counter % 7 == 0) then
    return 7
  else
    return (counter % 7)
  end
end

local callbackfn = function(bufnr)
  local matches = queries.get_capture_matches(bufnr, "@punctuation.bracket", "highlights")
  for _, node in ipairs(matches) do
    -- set colour for this nesting level
    if (node ~= nil and node.node ~=nil) then
      local color_no_ = color_no(node.node)
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
end

local M = {}

function M.attach(bufnr, lang)
  require "nvim-treesitter.highlight"
  local hlmap = vim.treesitter.highlighter.hl_map
  hlmap["punctuation.bracket"] = nil

  local query = queries.get_query(lang, "highlights")
  if not query then
    return
  end

  for i = 1, 7 do -- define highlight groups
    local s = "highlight rainbowcol" .. i .. " guifg=" .. colors[i]
    vim.cmd(s)
  end

  callbackfn(bufnr) -- do it on intial load
  vim.api.nvim_buf_attach( --do it on every change
    bufnr,
    false,
    {
      on_lines = function()
        callbackfn(bufnr)
      end
    }
  )
end

function M.detach(bufnr)
  vim.api.nvim_buf_detach(bufnr)
end

return M
