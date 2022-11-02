--[[
   Copyright 2020-2022 Chinmay Dalal

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--]]

local status_ok, nvim_ts = pcall(require, 'nvim-treesitter')
if not status_ok then
  return "nvim-treesitter is not installed"
end

local queries = require("nvim-treesitter.query")

local M = {}

function M.init()
    nvim_ts.define_modules({
        rainbow = {
            module_path = "rainbow.internal",
            is_supported = function(lang)
                return queries.get_query(lang, "parens") ~= nil
            end,
            extended_mode = true,
            colors = {
                "#cc241d",
                "#a89984",
                "#b16286",
                "#d79921",
                "#689d6a",
                "#d65d0e",
                "#458588",
            },
            termcolors = {
                "Red",
                "Green",
                "Yellow",
                "Blue",
                "Magenta",
                "Cyan",
                "White",
            },
        },
    })
end

return M
