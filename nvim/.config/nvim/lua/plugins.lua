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
				-- CocGitAddedSign = { fg = colors.soft_green },
				-- CocGitChangedSign = { fg = colors.soft_yellow },
				-- CocGitRemovedSign = { fg = colors.red },
				-- CocGitTopRemovedSign = { fg = colors.red },
				-- CocGitChangeRemovedSign = { fg = colors.red },
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
	use({
		"L3MON4D3/LuaSnip",
		after = "nvim-cmp",
		config = function()
			require("config.snippets")
		end,
	})
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-calc" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-emoji" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "f3fora/cmp-spell" },
			{ "saadparwaiz1/cmp_luasnip" },
		},
		config = function()
			-- Setup nvim-cmp.
			local cmp = require("cmp")
			local kind_icons = {
				Text = "",
				Method = "",
				Function = "�������������",
				Constructor = "",
				Field = "",
				Variable = "",
				Class = "ﴯ",
				Interface = "",
				Module = "",
				Property = "ﰠ",
				Unit = "",
				Value = "",
				Enum = "",
				Keyword = "",
				Snippet = "",
				Color = "",
				File = "",
				Reference = "",
				Folder = "",
				EnumMember = "",
				Constant = "",
				Struct = "",
				Event = "",
				Operator = "",
				TypeParameter = "",
			}

			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					-- Accept currently selected item.
					-- Set `select` to `false` to only confirm explicitly selected items.
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, {
						"i",
						"s",
					}),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, {
						"i",
						"s",
					}),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "calc" },
					{ name = "spell" },
					{ name = "path" },
					{ name = "emoji" },
					{ name = "nvim_lua" },
					{ name = "nvim_lsp_signature_help" },
				}, {}),
				formatting = {
					format = function(entry, vim_item)
						-- Kind icons
						vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
						-- Source
						-- vim_item.menu = ({
						-- 	buffer = "[Buffer]",
						-- 	nvim_lsp = "[LSP]",
						-- 	luasnip = "[LuaSnip]",
						-- 	nvim_lua = "[Lua]",
						-- 	latex_symbols = "[LaTeX]",
						-- })[entry.source.name]
						return vim_item
					end,
				},
			})

			-- Completions for command mode
			require("cmp").setup.cmdline(":", {
				sources = {
					{ name = "cmdline" },
				},
			})

			-- Completions for / search based on current buffer
			require("cmp").setup.cmdline("/", {
				sources = {
					{ name = "buffer" },
				},
			})

			-- Set configuration for specific filetype.
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
				}, {
					{ name = "buffer" },
				}),
			})

			-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})

			-- Setup lspconfig.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
			-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
			-- require("lspconfig")["<YOUR_LSP_SERVER>"].setup({
			-- 	capabilities = capabilities,
			-- })
		end,
	})
	use({
		"neovim/nvim-lspconfig",
		requires = {
			{ "williamboman/nvim-lsp-installer" },
		},
		config = function()
			-- Mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
			vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

			-- Use an on_attach function to only map the following keys
			-- after the language server attaches to the current buffer
			local on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

				-- Mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
				vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
				vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
				vim.keymap.set("n", "<space>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, bufopts)
				vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
				vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
				vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
				vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting, bufopts)
			end

			local lsp_flags = {
				-- This is the default in Nvim 0.7+
				debounce_text_changes = 150,
			}

			require("nvim-lsp-installer").setup({
				automatic_installation = true,
			})

			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
			--
			local lsp = require("lspconfig")
			lsp.pyright.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.tsserver.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.angularls.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.bashls.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.ccls.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.cmake.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.cssls.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.dockerls.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.eslint.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.gopls.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.graphql.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.html.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.texlab.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.vimls.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.yamlls.setup({
				on_attach = on_attach,
				flags = lsp_flags,

				settings = {
					yaml = {
						schemas = {
							["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.22.0-standalone-strict/all.json"] = "/*.k8s.yaml",
							-- ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
						},
					},
				},
			})
			-- lsp.rust_analyzer.setup({
			-- 	on_attach = on_attach,
			-- 	flags = lsp_flags,
			-- 	-- Server-specific settings...
			-- 	settings = {
			-- 		["rust-analyzer"] = {},
			-- 	},
			-- })
		end,
	})
	-- Vimscript plugins
	-- use({ "flazz/vim-colorschemes" })
	-- use({
	-- 	"neoclide/coc.nvim",
	-- 	branch = "release",
	-- 	run = "yarn install --frozen-lockfile",
	-- })
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
