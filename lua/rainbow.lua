local queries = require "nvim-treesitter.query"
local configs = require "nvim-treesitter.configs"

local M = {}

-- TODO: In this function replace `module-template` with the actual name of your module.
function M.init()
  require "nvim-treesitter".define_modules {
    rainbow = {
      module_path = "rainbow.internal",
      is_supported = function(lang)
        -- TODO: you don't want your queries to be named `awesome-query`, do you ?
        return queries.get_query(lang, 'parens') ~= nil
      end
    }
  }
end

return M
