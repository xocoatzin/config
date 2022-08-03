-- local lua_dirs = vim.fn.glob("./lua/config/*", 0, 1)
-- for _, dir in ipairs(lua_dirs) do
--   dir = string.gsub(dir, "./lua/config/", "")
--   require("plenary.reload").reload_module(dir)
-- end

vim.notify = require("notify")

require("config.options")
require("config.telescope")
require("config.treesitter")
require("config.galaxyline")
require("config.git")
require("config.completion")
require("config.lsp")
require("config.dap")
require("config.snippets")
require("config.everything_else")
require("config.colors")
