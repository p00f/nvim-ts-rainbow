--- Various general utility functions.
local M = {}

--- Whether a given node's range contains a certain buffer coordinate.
function M.contains_point(node, row, col)
	local startRow, startCol, endRow, endCol = node:range()
	if row < startRow or row > endRow then return false end
	if row == startRow and col < startCol then return false end
	if row == endRow and col > endCol then return false end
	return true
end

function M.contains_node(node1, node2)
	local inStartRow, inStartCol, inEndRow, inEndCol = node2:range()
	return M.contains_point(node1, inStartRow, inStartCol) and M.contains_point(node1, inEndRow, inEndCol)
end

return M
