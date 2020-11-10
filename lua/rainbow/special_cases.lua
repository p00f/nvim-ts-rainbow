local cases = {
  -- lang, node:type(), start_col shift, end_col shift
  ["clojure"] = {
    ["set_lit"] = {1, 0}
  }
}
local M = {}
function M.range(node, lang)
  local sr, sc, er, ec = node:range()
  local nt = "" .. node:type()
  --if cases[lang] ~= nil then
  --  vim.api.nvim_err_writeln("This language HAS a special case")
  --  if cases[lang[nt]] ~= nil then
  --    vim.api.nvim_err_writeln("this node is a special case")
  --    return sr, sc + cases[lang[nt[1]]], er, ec + cases[lang[nt[2]]]
  --  else
  --    vim.api.nvim_err_writeln(nt .. " is NOT a special case")
  --    return sr, sc, er, ec
  --  end
  --else
  --  vim.api.nvim_err_writeln("this language does NOT have a special case")
  --  return sr, sc, er, ec
  --end
  if lang == 'clojure' then
    if nt == 'set_lit' then
      return sr, sc + 1, er, ec
    else return sr, sc, er, ec end
  else return sr, sc, er, ec end
end
return M
