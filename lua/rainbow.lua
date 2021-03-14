local queries = require("nvim-treesitter.query")
local configs = require("nvim-treesitter.configs")

local M = {}

function M.init()
    require("nvim-treesitter").define_modules({
        rainbow = {
            module_path = "rainbow.internal",
            is_supported = function(lang)
                return queries.get_query(lang, "highlights") ~= nil
            end,
        },
    })
end

return M
