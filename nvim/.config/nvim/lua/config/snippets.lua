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
local types = require("luasnip.util.types")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l
local postfix = require("luasnip.extras.postfix").postfix

ls.config.set_config {
  -- This tells LuaSnip to remember to keep around the last snippet.
  -- You can jump back into it even if you move outside of the selection
  history = true,

  -- This one is cool cause if you have dynamic snippets, it updates as you type!
  updateevents = "TextChanged,TextChangedI",

  -- Autosnippets:
  enable_autosnippets = true,

  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { " « ", "NonTest" } },
      },
    },
  },
}

-- <c-k> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- <c-l> is selecting within a list of options.
-- This is useful for choice nodes (introduced in the forthcoming episode 2)
vim.keymap.set("i", "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

vim.keymap.set("i", "<c-u>", require "luasnip.extras.select_choice")

local date = function(format)
	local today = function()
		return { os.date(format) }
	end
	return today
end

local random = math.random
local function uuid()
	local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
	return string.gsub(template, "[xy]", function(c)
		local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
		return string.format("%x", v)
	end)
end

local function get_current_function_name()
	return ""
	-- local current_node = vim.treesitter.get_node_at_cursor()
	--
	-- if not current_node then
	-- 	return "s"
	-- end
	--
	-- local expr = current_node
	--
	-- while expr do
	-- 	if expr:type() == 'function_definition' then
	-- 		break
	-- 	end
	-- 	expr = expr:parent()
	-- end
	--
	-- if not expr then
	-- 	return "e"
	-- end
	--
	-- return vim.inspect(expr)
	-- return (vim.treesitter.get_node_text(expr:child(1)))[1]
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
		snippet(
			{
				trig = "@uuid",
				namr = "UUID",
				dscr = "Generate a random UUID",
			},
			choice(1, {
				func(uuid, {}),
				text("00000000-0000-4000-0000-000000000000"),
			})
		),
	},
	-- hgcommit = {
	-- 	snippet(
	-- 		{
	-- 			trig = '[',
	-- 			namr = "Title",
	-- 			dscr = "Title prefix",
	-- 		},
	-- 		{
	-- 			text('['),
	-- 			choice(1, {
	-- 				text("DACO"),
	-- 				text("DCL"),
	-- 			})
	-- 			text(']['),
	-- 			choice(2, {
	-- 				text("AR_SLAM"),
	-- 				text("AR_SLAM_WEB"),
	-- 			})
	-- 			text(']'),
	-- 			insert(0),
	-- 		}
	-- 	),
	-- },
	python = {
		snippet(
			{
				trig = "@ff",
				namr = "UUID",
				dscr = "Generate a random UUID",
			},
			{
				text(get_current_function_name()),
			}
		),
		snippet(
			{
				trig = '"""',
				namr = "Docstring",
				dscr = "Docstring template",
			},
			{
				text('"""'),
				insert(1, "Description for " .. get_current_function_name()),
				text({ ".", "", "" }),
				insert(2, "Details."),
				text({ "", "", "Args:", "    " }),
				insert(3),
				text({ "", "", "Returns:", "    " }),
				insert(4),
				text({ "", '"""', "" }),
				insert(0),
			}
		),
	},
})
