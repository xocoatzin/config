require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"bash",
		"c",
		"cmake",
		"cpp",
		"css",
		"dockerfile",
		"fish",
		"go",
		-- "gotmpl",
		"graphql",
		"hcl",
		"html",
		"http",
		"java",
		"javascript",
		"json",
		"json5",
		"latex",
		"lua",
		"make",
		"markdown",
		"proto",
		"python",
		"ql",
		"regex",
		"rst",
		"rust",
		"scss",
		"toml",
		"typescript",
		"vim",
		"yaml",
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		disable = function(lang, buf)
			local max_filesize_kb = 500
			local max_filesize = max_filesize_kb * 1024
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				vim.notify("Treesitter highlight disabled (file size > " .. max_filesize_kb .."kb)", "warn", {})
				return true
			end
		end,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremcntal = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
		textobjects = {
			enable = true,
		},
	},
	textobjects = {
		select = {
			enable = true,
			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>wp"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>wP"] = "@parameter.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
		lsp_interop = {
			enable = true,
			-- border = 'none',
			peek_definition_code = {
				["<leader>df"] = "@function.outer",
				["<leader>dF"] = "@class.outer",
			},
		},
	},
})

require("treesitter-context").setup({
	patterns = {
		default = {
			"class",
			"function",
			"method",
			"for",
			"while",
			"if",
			"switch",
			"case",
		},
	},
})
