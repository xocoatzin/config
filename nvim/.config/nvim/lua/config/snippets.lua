local ls = require("luasnip")
local snippet = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dyn = ls.dynamic_node
local restore = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l
local postfix = require("luasnip.extras.postfix").postfix

-- set keybinds for both INSERT and VISUAL.
vim.api.nvim_set_keymap("i", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", {})
vim.api.nvim_set_keymap("s", "<C-p>", "<Plug>luasnip-prev-choice", {})

local date = function(format)
	local today = function()
		return { os.date(format) }
	end
	return today
end

ls.add_snippets(nil, {
	all = {
		snippet(
			{
				trig = "@today",
				namr = "Today",
				dscr = "Today's date in the form of YYYY-MM-DD",
			},
			choice(1, {
				func(date("%Y-%m-%d"), {}),
				func(date("%Y-%m-%dT%H:%M:%S"), {}),
				func(date("!%Y-%m-%dT%H:%M:%S+00:00"), {}),
				func(date(), {}),
			})
		),
	},
})
