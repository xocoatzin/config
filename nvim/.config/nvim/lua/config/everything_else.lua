require("notify").setup({
	background_colour = "#000000",
})

require("Comment").setup({
	toggler = {
		---Line-comment toggle keymap
		line = "gcc",
		---Block-comment toggle keymap
		block = "gbc",
	},
	opleader = {
		---Line-comment keymap
		line = "gc",
		---Block-comment keymap
		block = "gb",
	},
	extra = {
		---Add comment on the line above
		above = "gcO",
		---Add comment on the line below
		below = "gco",
		---Add comment at the end of line
		eol = "gcA",
	},
})

require("bufferline").setup({
	options = {
		buffer_close_icon = "",
		modified_icon = "●",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		max_name_length = 14,
		max_prefix_length = 13,
		tab_size = 18,
		enforce_regular_tabs = true,
		view = "multiwindow",
		show_buffer_close_icons = true,
		separator_style = "thin",
	},
})

require("indent_blankline").setup({
	space_char_blankline = " ",
	use_treesitter = true,
	show_current_context = true,
	show_current_context_start = false,
	show_end_of_line = true,
	context_patterns = { ".*" },
	show_first_indent_level = false,
	filetype_exclude = {},
	buftype_exclude = { "terminal" },
})

require("colorizer").setup({
	-- RGB      = true;         -- #RGB hex codes
	-- RRGGBB   = true;         -- #RRGGBB hex codes
	-- names    = true;         -- "Name" codes like Blue
	-- RRGGBBAA = false;        -- #RRGGBBAA hex codes
	-- rgb_fn   = false;        -- CSS rgb() and rgba() functions
	-- hsl_fn   = false;        -- CSS hsl() and hsla() functions
	-- css      = false;        -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
	-- css_fn   = false;        -- Enable all CSS *functions*: rgb_fn, hsl_fn
	-- Available modes: foreground, background
	-- mode     = 'background'; -- Set the display mode.
})

require("neoscroll").setup({
	-- All these keys will be mapped to their corresponding default scrolling animation
	-- mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
	hide_cursor = true, -- Hide cursor while scrolling
	stop_eof = true, -- Stop at <EOF> when scrolling downwards
	use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
	respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
	cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
	-- easing_function = nil, -- Default easing function
	-- pre_hook = nil, -- Function to run before the scrolling animation starts
	-- post_hook = nil, -- Function to run after the scrolling animation ends
	-- performance_mode = true, -- Disable "Performance Mode" on all buffers.
})

local t = {}
-- Syntax: t[keys] = {function, {function arguments}}
t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "50" } }
t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "50" } }
t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "50" } }
t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "50" } }
t["<C-y>"] = { "scroll", { "-0.10", "false", "50" } }
t["<C-e>"] = { "scroll", { "0.10", "false", "50" } }
t["zt"] = { "zt", { "50" } }
t["zz"] = { "zz", { "50" } }
t["zb"] = { "zb", { "50" } }

require("neoscroll.config").set_mappings(t)

require("nvim-autopairs").setup({
	enable_check_bracket_line = false,
	ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
})

require("coverage").setup({
	commands = true, -- create commands
	highlights = {
		-- customize highlight groups created by the plugin
		covered = { fg = "#C3E88D" }, -- supports style, fg, bg, sp (see :h highlight-gui)
		uncovered = { fg = "#F07178" },
	},
	signs = {
		-- use your own highlight groups or text markers
		covered = { hl = "CoverageCovered", text = "▒" },
		uncovered = { hl = "CoverageUncovered", text = "▒" },
	},
	summary = {
		-- customize the summary pop-up
		min_coverage = 80.0, -- minimum coverage threshold (used for highlighting)
	},
	lang = {
		-- customize language specific settings
	},
})

require("leap").setup({
	case_sensitive = true,
})
require("leap").set_default_keymaps()

require("nvim-surround").setup({
	keymaps = { -- vim-surround style keymaps
		insert = "<C-g>s",
		insert_line = "<C-g>S",
		normal = "ys",
		normal_cur = "yss",
		normal_line = "yS",
		normal_cur_line = "ySS",
		visual = "S",
		visual_line = "gS",
		delete = "ds",
		change = "cs",
	},
	highlight_motion = {
		duration = 1000,
	},
})

-- UFO
vim.o.foldcolumn = "1"
vim.o.foldnestmax = 1
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
require("ufo").setup()

-- DIAL
vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true, desc = "Increment" })
vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true, desc = "Decrement" })
vim.api.nvim_set_keymap("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true, desc = "Increment" })
vim.api.nvim_set_keymap("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true, desc = "Decrement" })
vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true, desc = "Increment" })
vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true, desc = "Decrement" })

-- TOGGLETERM
require("toggleterm").setup({
	open_mapping = [[<c-\><c-\>]],
	hide_numbers = true,
	highlights = {
		Normal = {
			link = "TelescopeNormal",
		},
		NormalFloat = {
			link = "TelescopeNormal",
		},
		FloatBorder = {
			link = "TelescopeNormal",
		},
	},
	direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
	float_opts = {
		border = "curved", -- 'single' | 'double' | 'shadow' | 'curved' | 'none' ... :h nvim_open_win()
		-- winblend = 3,
	},
	shell = "fish",
	on_open = function(terminal) end,
	on_close = function(terminal) end,
	on_exit = function(terminal, job, exit_code, name)
		vim.notify("Terminal " .. job .. " exited with code " .. exit_code, "info", {})
	end,
})

-- GIT-WORKTREE
local Worktree = require("git-worktree")
Worktree.setup({})
Worktree.on_tree_change(function(op, metadata)
	if op == Worktree.Operations.Switch then
		vim.notify("Switched from " .. metadata.prev_path .. " to " .. metadata.path)
	end
	if op == Worktree.Operations.Create then
		vim.notify("Created " .. metadata.branch .. " in " .. metadata.path)
	end
	if op == Worktree.Operations.Delete then
		vim.notify("Deleted " .. metadata.path)
	end
end)

-- require("refactoring").setup({})
-- -- Remaps for the refactoring operations currently offered by the plugin
-- vim.api.nvim_set_keymap(
-- 	"v",
-- 	"<leader>re",
-- 	[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
-- 	{ noremap = true, silent = true, expr = false, desc = "Extract Function" }
-- )
-- vim.api.nvim_set_keymap(
-- 	"v",
-- 	"<leader>rf",
-- 	[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
-- 	{ noremap = true, silent = true, expr = false, desc = "Extract Function To File" }
-- )
-- vim.api.nvim_set_keymap(
-- 	"v",
-- 	"<leader>rv",
-- 	[[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
-- 	{ noremap = true, silent = true, expr = false, desc = "Extract Variable" }
-- )
-- vim.api.nvim_set_keymap(
-- 	"v",
-- 	"<leader>ri",
-- 	[[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
-- 	{ noremap = true, silent = true, expr = false, desc = "Inline Variable" }
-- )
--
-- -- Extract block doesn't need visual mode
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>rb",
-- 	[[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
-- 	{ noremap = true, silent = true, expr = false, desc = "Extract Block" }
-- )
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>rbf",
-- 	[[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
-- 	{ noremap = true, silent = true, expr = false, desc = "Extract Block To File" }
-- )
--
-- -- Inline variable can also pick up the identifier currently under the cursor without visual mode
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>ri",
-- 	[[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
-- 	{ noremap = true, silent = true, expr = false, desc = "Inline Variable" }
-- )

require("spellsitter").setup()
require("stabilize").setup()
require("which-key").setup({})
