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
				show_current_context_start = false,
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
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "tami5/sqlite.lua" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-github.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim" },
			{ "nvim-telescope/telescope-file-browser.nvim" },
			{ "nvim-telescope/telescope-frecency.nvim" },
		},
		config = function()
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
			require("telescope").load_extension("frecency")
			require("telescope").load_extension("gh")
		end,
	})
	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	})
	use({
		"luisiacc/gruvbox-baby",
		config = function()
			local colors = require("gruvbox-baby.colors").config()
			-- dark = "#202020",
			-- foreground = "#ebdbb2",
			-- background = "#282828",
			-- background_dark = "#242424",
			-- bg_light = "#32302f",
			-- medium_gray = "#504945",
			-- comment = "#665c54",
			-- gray = "#DEDEDE",
			-- soft_yellow = "#EEBD35",
			-- soft_green = "#98971a",
			-- bright_yellow = "#fabd2f",
			-- orange = "#d65d0e",
			-- red = "#fb4934",
			-- error_red = "#cc241d",
			-- magenta = "#b16286",
			-- pink = "#D4879C",
			-- light_blue = "#7fa2ac",
			-- dark_gray = "#83a598",
			-- blue_gray = "#458588",
			-- forest_green = "#689d6a",
			-- clean_green = "#8ec07c",
			-- milk = "#E7D7AD",

			-- vim.g.gruvbox_baby_background_color = "dark"
			vim.g.gruvbox_baby_telescope_theme = 1
			vim.g.gruvbox_baby_highlights = {
				Visual = { bg = "#444455" },
				CocGitAddedSign = { fg = colors.soft_green },
				CocGitChangedSign = { fg = colors.soft_yellow },
				CocGitRemovedSign = { fg = colors.red },
				CocGitTopRemovedSign = { fg = colors.red },
				CocGitChangeRemovedSign = { fg = colors.red },
			}
			vim.cmd([[colorscheme gruvbox-baby]])
		end,
	})
	use({
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup({
				-- All these keys will be mapped to their corresponding default scrolling animation
				mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
				hide_cursor = true, -- Hide cursor while scrolling
				stop_eof = true, -- Stop at <EOF> when scrolling downwards
				use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
				respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
				cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
				-- easing_function = nil, -- Default easing function
				-- pre_hook = nil, -- Function to run before the scrolling animation starts
				-- post_hook = nil, -- Function to run after the scrolling animation ends
				-- performance_mode = false, -- Disable "Performance Mode" on all buffers.
			})
		end,
	})
	-- Vimscript plugins
	-- use({ "flazz/vim-colorschemes" })
	use({
		"neoclide/coc.nvim",
		branch = "release",
		run = "yarn install --frozen-lockfile",
	})
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
	-- use 'tmhedberg/SimpylFold'
end)
