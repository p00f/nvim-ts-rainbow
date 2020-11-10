local cases = {
  -- lang, node:type(), start_col shift, end_col shift
  ["clojure"] = {
    ["set_lit"] = {[1] = 1, [2] = 0}
  }
}
local M = {}
function M.range(node, lang)
  local sr, sc, er, ec = node:range()
  local nt = "" .. node:type()
  local shift = cases[lang][nt]
  if shift ~=nil then
    return sr, sc + shift[1], er, ec + shift[2]
  else
    return sr, sc, er, ec
  end
end
return M
