local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<esc>"] = actions.close, -- close on escape
			},
		},
		prompt_prefix = " >  ",
		selection_caret = "  ",
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.55,
				results_width = 0.8,
			},
			vertical = {
				mirror = false,
			},
			width = 0.87,
			height = 0.80,
			preview_cutoff = 120,
		},
		file_ignore_patterns = { "node_modules", "*venv*" },
		winblend = 0,
		border = {},
		borderchars = { "", "", "", "", "", "", "", "" },
		-- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		color_devicons = true,
		use_less = true,
		set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
		vimgrep_arguments = {
			"ag",
			"--vimgrep",
			"--nocolor",
			"--hidden",
		},
	},
	pickers = {
		find_files = {
			-- apt install fd-find
			find_command = { "fd", "--hidden", "--type", "f", "--strip-cwd-prefix" },
		},
	},
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
		},
		file_browser = {
			hijack_netwr = true,
		},
		frecency = {
			ignore_patterns = { "*.git/*", "*/tmp/*", "*/node_modules/*", "*/*venv*/*" },
			workspaces = {
				["home"] = "~",
				["conf"] = "~/.config",
			},
		},
	},
})
require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser")
-- sudo apt install sqlite3
require("telescope").load_extension("frecency")
require("telescope").load_extension("gh")
require("telescope").load_extension("dap")
require("telescope").load_extension("notify")
