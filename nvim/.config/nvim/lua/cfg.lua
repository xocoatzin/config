-- local lua_dirs = vim.fn.glob("./lua/config/*", 0, 1)
-- for _, dir in ipairs(lua_dirs) do
--   dir = string.gsub(dir, "./lua/config/", "")
--   require("plenary.reload").reload_module(dir)
-- end

local notify = require("notify")
notify.setup({
	background_colour = "#000000",
	stages = "slide",
	timeout = 5000,
})
vim.notify = notify

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

require("config.my_meta")
