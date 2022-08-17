local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
telescope.setup({
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
		-- vimgrep_arguments = {
		-- 	"ag",
		-- 	"--vimgrep",
		-- 	"--nocolor",
		-- 	"--hidden",
		-- },
	},
	pickers = {
		find_files = {
			-- apt install fd-find
			find_command = { "fd", "--hidden", "--type=f", "--strip-cwd-prefix", "--exclude=.git/*" },
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

local opts = function(desc)
	return { noremap = true, silent = true, desc = "[Telescope] " .. desc }
end
vim.keymap.set("n", "<leader>tt", require("telescope.command").load_command, opts("Open"))
vim.keymap.set("n", "<leader>tg", builtin.live_grep, opts("Live Grep"))
vim.keymap.set("n", "<leader>tr", builtin.reloader, opts("Reloader"))
vim.keymap.set("n", "<leader>tb", builtin.buffers, opts("Buffers"))
vim.keymap.set("n", "<leader>tl", telescope.extensions.frecency.frecency, opts("Frecency"))
vim.keymap.set("n", "<leader>tw", telescope.extensions.git_worktree.git_worktrees, opts("Worktrees"))
vim.keymap.set("n", "<c-p>", builtin.find_files, opts("Find Files"))
vim.keymap.set(
	"n",
	"<leader>wt",
	telescope.extensions.git_worktree.create_git_worktree,
	opts("Create Worktree")
)

telescope.load_extension("ag")
telescope.load_extension("fzf")
telescope.load_extension("file_browser")
telescope.load_extension("git_worktree")
-- sudo apt install sqlite3
telescope.load_extension("frecency")
telescope.load_extension("gh")
telescope.load_extension("dap")
telescope.load_extension("notify")
