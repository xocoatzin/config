return require("packer").startup(function()
	use({ "wbthomason/packer.nvim" })
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
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
					"graphql",
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
				highlight = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
					textobjects = {
						enable = true,
					},
				},
			})
		end,
	})
	use({
		"numToStr/Comment.nvim",
		config = function()
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
		end,
	})
	use({
		"akinsho/nvim-bufferline.lua",
		config = function()
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
		end,
	})
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				space_char_blankline = " ",
				use_treesitter = true,
				show_current_context = true,
				show_current_context_start = true,
				show_end_of_line = true,
				context_patterns = { ".*" },
				show_first_indent_level = false,
				filetype_exclude = {},
				buftype_exclude = { "terminal" },
			})
		end,
	})
	use({
		"luukvbaal/stabilize.nvim",
		config = function()
			require("stabilize").setup()
		end,
	})
	use({
		"glepnir/galaxyline.nvim",
		branch = "main",
		requires = {
			"kyazdani42/nvim-web-devicons",
			opt = true,
		},
		config = function()
			require("statusline")
		end,
	})
	use({
		"neoclide/coc.nvim",
		branch = "release",
		run = "yarn install --frozen-lockfile",
	})
	use({
		"romgrk/nvim-treesitter-context",
		config = function()
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
		end,
	})
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		config = function()
			require("telescope").load_extension("fzf")
		end,
		run = "make",
	})
	use({
		"nvim-telescope/telescope-file-browser.nvim",
		config = function()
			require("telescope").load_extension("file_browser")
		end,
	})
	use({
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").load_extension("frecency")
		end,
		requires = { "tami5/sqlite.lua" },
	})
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
		},
		config = function()
			local actions = require("telescope.actions")
            -- local fg = require("core.utils").fg
            -- local fg_bg = require("core.utils").fg_bg
            -- local bg = require("core.utils").bg
            -- fg_bg("TelescopeBorder", darker_black, darker_black)
            -- fg_bg("TelescopePromptBorder", black2, black2)
            --
            -- fg_bg("TelescopePromptNormal", white, black2)
            -- fg_bg("TelescopePromptPrefix", red, black2)
            --
            -- bg("TelescopeNormal", darker_black)
            --
            -- fg_bg("TelescopePreviewTitle", black, green)
            -- fg_bg("TelescopePromptTitle", black, red)
            -- fg_bg("TelescopeResultsTitle", darker_black, darker_black)
            --
            -- bg("TelescopeSelection", black2)
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
					-- borderchars = { "", "", "", "", "", "", "", "" },
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					color_devicons = true,
					use_less = true,
					set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
				},
				pickers = {
					find_files = {
						find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
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
				},
			})
		end,
	})
	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	})
	-- Vimscript plugins
	-- use({ "flazz/vim-colorschemes" })
	use({ "sainnhe/gruvbox-material" })
	use({ "flwyd/vim-conjoin" })
	use({ "ggandor/lightspeed.nvim" })
	use({ "github/copilot.vim", disable = true })
	use({ "junegunn/vim-easy-align" })
	use({ "machakann/vim-sandwich" })
	use({ "nelstrom/vim-visual-star-search" })
	use({ "qpkorr/vim-bufkill" })
	use({ "scrooloose/nerdtree" })
	use({ "tiagofumo/vim-nerdtree-syntax-highlight" })
	use({ "tpope/vim-abolish" })
	use({ "tpope/vim-fugitive" })
	use({ "tpope/vim-sleuth" })

	-- use 'SirVer/ultisnips'
	-- use 'honza/vim-snippets'
	-- use 'psliwka/vim-smoothie'
	-- use 'tmhedberg/SimpylFold'
end)
