return require("packer").startup(function()
	use({ "wbthomason/packer.nvim" })
	use({
		"nvim-treesitter/nvim-treesitter",
		requires = {
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
		},
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
					"gotmpl",
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
			{ "nvim-telescope/telescope-dap.nvim" },
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
			require("telescope").load_extension("dap")
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
				Search = { bg = colors.bright_yellow, fg = colors.dark },
				Pmenu = { bg = colors.medium_gray, blend = 0.7 },
				-- DAP
				DapBreakpointLine = { bg = colors.dark },
				DapBreakpoint = { fg = colors.red },
				DapBreakpointCondition = { fg = colors.orange },
				DapBreakpointRejected = { fg = colors.error_red },
				DapLogPoint = { fg = colors.blue_gray },
				DapStopped = { fg = colors.bright_yellow },
			}
			vim.cmd([[colorscheme gruvbox-baby]])
		end,
	})
	use({
		"norcalli/nvim-colorizer.lua",
		config = function()
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
		end,
	})
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				current_line_blame = true,
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, {
						expr = true,
						desc = "Next change",
					})

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, {
						expr = true,
						desc = "Prev change",
					})

					-- Actions
					map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
					map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
					map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
					map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
					map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
					map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end, {
						desc = "Blame line",
					})
					map("n", "<leader>hB", gs.toggle_current_line_blame, { desc = "Toggle current line blame" })
					map("n", "<leader>hd", gs.diffthis, { desc = "Diffthis" })
					map("n", "<leader>hD", function()
						gs.diffthis("~")
					end, { desc = "Diffthis ~" })
					map("n", "<leader>hdd", gs.toggle_deleted, { desc = "Toggle deleted" })

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
				end,
			})
		end,
	})
	use({
		"karb94/neoscroll.nvim",
		config = function()
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
		end,
	})
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({
				enable_check_bracket_line = false,
				ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
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
				Function = "",
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
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-e>"] = cmp.mapping.abort(),
					-- Accept currently selected item.
					-- Set `select` to `false` to only confirm explicitly selected items.
					["<c-y>"] = cmp.mapping(
						cmp.mapping.confirm({
							-- behavior = cmp.ConfirmBehavior.Replace,
							behavior = cmp.ConfirmBehavior.Insert,
							select = true,
						}),
						{ "i", "c" }
					),
					["<c-space>"] = cmp.mapping({
						i = cmp.mapping.complete(),
						c = function(
							_ --[[fallback]]
						)
							if cmp.visible() then
								if not cmp.confirm({ select = true }) then
									return
								end
							else
								cmp.complete()
							end
						end,
					}),
					["<tab>"] = cmp.config.disable,
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "luasnip" },
					{ name = "calc" },
					{ name = "path" },
					{ name = "emoji" },
					{ name = "nvim_lua" },
					{ name = "spell" },
					{ name = "buffer" },
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
			{ "creativenull/diagnosticls-configs-nvim" },
			-- { "jose-elias-alvarez/null-ls.nvim" },
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
				vim.keymap.set("n", "<space>k", vim.lsp.buf.signature_help, bufopts)
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
			lsp.angularls.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.bashls.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.ccls.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.cmake.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.cssls.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.dockerls.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.diagnosticls.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.eslint.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.gopls.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.graphql.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.html.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.jsonls.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.pyright.setup({ on_attach = on_attach, flags = lsp_flags })
			-- lsp.taplo.setup({ on_attach = on_attach, flags = lsp_flags })  -- TOML
			lsp.terraformls.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.texlab.setup({ on_attach = on_attach, flags = lsp_flags })
			lsp.tsserver.setup({ on_attach = on_attach, flags = lsp_flags })
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
			lsp.zk.setup({ on_attach = on_attach, flags = lsp_flags })

			-- local prettier = require("diagnosticls-configs.formatters.prettier")
			-- local eslint = require("diagnosticls-configs.linters.eslint")
			-- local stylua = require("diagnosticls-configs.formatters.stylua")
			-- local luacheck = require("diagnosticls-configs.linters.luacheck")
			-- require("diagnosticls-configs").setup({
			-- 	["lua"] = {
			-- 		linter = luacheck,
			-- 		formatter = stylua,
			-- 	},
			-- 	["json"] = {
			-- 		formatter = prettier,
			-- 	},
			-- 	["javascript"] = {
			-- 		linter = eslint,
			-- 		formatter = prettier,
			-- 	},
			-- })
			-- https://github.com/iamcco/diagnostic-languageserver
			-- https://github.com/creativenull/diagnosticls-configs-nvim
			lsp.diagnosticls.setup({
				on_attach = on_attach,
				flags = lsp_flags,

				filetypes = {
					"bash",
					"css",
					"html",
					"js",
					"json",
					"lua",
					"python",
					"sh",
					"ts",
				},
				init_options = {
					filetypes = {
						-- filetype: linterName, * for all types
						python = { "flake8", "mypy", "pydocstyle" },
						bash = { "shellcheck" },
						sh = { "shellcheck" },
					},
					linters = {
						shellcheck = {
							sourceName = "shellcheck",
							command = "shellcheck",
							debounce = 100,
							args = { "--format", "json1", "-" },
							parseJson = {
								errorsRoot = "comments",
								sourceName = "file",
								line = "line",
								column = "column",
								endLine = "endLine",
								endColumn = "endColumn",
								security = "level",
								message = "[shellcheck] ${message} [SC${code}]",
							},
							securities = {
								error = "error",
								warning = "warning",
								info = "info",
								style = "hint",
							},
						},
						pydocstyle = {
							sourceName = "pydocstyle",
							command = "pydocstyle",
							args = {
								"%file",
							},
							-- file.py:162 in public function `check_or_get_default_project`:
							-- D103: Missing docstring in public function
							formatPattern = {
								"^(.+\\.py):(\\d+)(\\s)([^\\n]+)\n\\s+(.+)$",
								{
									line = 2,
									security = 3,
									message = { 5 },
								},
							},
							rootPatterns = { "pyproject.toml", "setup.py", "setup.cfg", ".git" },
							securities = {
								[" "] = "hint",
							},
							offsetColumn = 0,
							formatLines = 2,
						},
						mypy = {
							sourceName = "mypy",
							command = "mypy",
							args = {
								"--follow-imports",
								"silent",
								"--no-site-packages",
								"--show-column-numbers",
								"--show-error-codes",
								"--no-color-output",
								"%file",
							},
							-- file.py:68:1: error: Cannot assign to a type
							formatPattern = {
								"^(.+\\.py):(\\d+):(\\d+): (error|note|\\w+): (.+)$",
								{
									line = 2,
									column = 3,
									security = 4,
									message = { 5, " - mypy" },
								},
							},
							rootPatterns = { "pyproject.toml", "setup.py", "setup.cfg", ".git" },
							securities = {
								error = "error",
								note = "hint",
							},
							offsetColumn = 0,
							formatLines = 1,
						},
						flake8 = {
							sourceName = "flake8",
							command = "flake8",
							args = {
								"%file",
							},
							-- file.py:12:1: E402 description
							formatPattern = {
								"^(.+\\.py):(\\d+):(\\d+): (I|W|E|F)(\\d+) (.+)$",
								{
									line = 2,
									column = 3,
									security = 4,
									message = { 6, " - ", 4, 5 },
								},
							},
							rootPatterns = { "pyproject.toml", "setup.py", "setup.cfg", ".git" },
							securities = {
								E = "warning",
								W = "warning",
								I = "info",
								F = "error",
							},
							requiredFiles = {
								".flake8",
								"setup.cfg",
							},
							offsetColumn = 0,
							formatLines = 1,
						},
						-- https://github.com/iamcco/diagnostic-languageserver/issues/28
						eslint = {
							sourceName = "eslint",
							command = "./node_modules/.bin/eslint",
							rootPatterns = { ".git" },
							debounce = 100,
							args = {
								"--stdin",
								"--stdin-filename",
								"%filepath",
								"--format",
								"json",
							},
							parseJson = {
								errorsRoot = "[0].messages",
								line = "line",
								column = "column",
								endLine = "endLine",
								endColumn = "endColumn",
								message = "${message} [${ruleId}]",
								security = "severity",
							},
							securities = {
								[2] = "error",
								[1] = "warning",
							},
						},
					},
					formatFiletypes = {
						-- filetype: formatterName, * for all types
						python = { "isort", "black" },
						json = { "prettier" },
						ts = { "prettier" },
						js = { "prettier" },
						html = { "prettier" },
						css = { "prettier" },
						lua = { "stylua" },
					},
					formatters = {
						-- FIXME: Not working
						isort = {
							command = "isort",
							args = { "--quiet", "--stdout", "-" },
							rootPatterns = { ".isort.cfg", "pyproject.toml", ".git" },
						},
						prettier = {
							command = "prettier",
							args = { "--stdin", "--stdin-filepath", "%filepath" },
							rootPatterns = {
								".prettierrc",
								".prettierrc.json",
								".prettierrc.toml",
								".prettierrc.json",
								".prettierrc.yml",
								".prettierrc.yaml",
								".prettierrc.json5",
								".prettierrc.js",
								".prettierrc.cjs",
								"prettier.config.js",
								"prettier.config.cjs",
								".git",
							},
						},
						black = {
							command = "black",
							args = {
								"--line-length",
								"80",
								"--target-version",
								"py36",
								"--quiet",
								"-",
							},
							rootPatterns = { "setup.cfg", "pyproject.toml", "setup.py", ".git/" },
						},
						stylua = {
							command = "stylua",
							args = { "--color", "Never", "-" },
							-- requiredFiles = { 'stylua.toml', '.stylua.toml' },
							rootPatterns = { "stylua.toml", ".stylua.toml" },
						},
					},
				},
			})

			-- require("null-ls").setup({
			-- 	sources = {
			-- 		require("null-ls").builtins.completion.spell,
			-- 	},
			-- })
		end,
	})
	use({
		"mfussenegger/nvim-dap",
		requires = {
			{ "mfussenegger/nvim-dap-python" },
			{ "theHamsta/nvim-dap-virtual-text" },
			{ "rcarriga/nvim-dap-ui" },
		},
		config = function()
			require("dap-python").setup("python3")

			local dap = require("dap")

			vim.fn.sign_define(
				"DapBreakpoint",
				{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpointLine", numhl = "DapBreakpointLine" }
			)
			vim.fn.sign_define("DapBreakpointCondition", {
				text = "ﳁ",
				texthl = "DapBreakpointCondition",
				linehl = "DapBreakpointLine",
				numhl = "DapBreakpointLine",
			})
			vim.fn.sign_define("DapBreakpointRejected", {
				text = "",
				texthl = "DapBreakpointRejected",
				linehl = "DapBreakpointLine",
				numhl = "DapBreakpointLine",
			})
			vim.fn.sign_define(
				"DapLogPoint",
				{ text = "", texthl = "DapLogPoint", linehl = "DapLogPointLine", numhl = "DapLogPointLine" }
			)
			vim.fn.sign_define(
				"DapStopped",
				{ text = "", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "DapStoppedLine" }
			)
			-- dap.adapters.python = {
			-- 	type = "executable",
			-- 	command = ".venv3/bin/python",
			-- 	args = { "-m", "debugpy.adapter" },
			-- }

			vim.keymap.set("n", "<F1>", require("dap").step_back, { desc = "[DAP] Step Back" })
			vim.keymap.set("n", "<F2>", require("dap").step_into, { desc = "[DAP] Step Into" })
			vim.keymap.set("n", "<F3>", require("dap").step_over, { desc = "[DAP] Step Over" })
			vim.keymap.set("n", "<F4>", require("dap").step_out, { desc = "[DAP] Step Out" })
			vim.keymap.set("n", "<F5>", require("dap").continue, { desc = "[DAP] Continue" })
			vim.keymap.set("n", "<leader>dr", require("dap").repl.open, { desc = "[DAP] Open repl" })
			vim.keymap.set("n", "<leader>db", require("dap").toggle_breakpoint, { desc = "[DAP] Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>dB", function()
				require("dap").set_breakpoint(vim.fn.input("[DAP] Condition > "))
			end, {
				desc = "[DAP] Toggle Breakpoint (cond.)",
			})
			vim.keymap.set("n", "<leader>dL", function()
				require("dap").set_breakpoint(nil, nil, vim.fn.input("[DAP] Log Message > "))
			end, {
				desc = "[DAP] Add Log Point Message",
			})

			-- map("<leader>de", require("dapui").eval)
			-- map("<leader>dE", function()
			-- 	require("dapui").eval(vim.fn.input("[DAP] Expression > "))
			-- end)
			--
			require("nvim-dap-virtual-text").setup({
				commented = true,
			})

			local dapui = require("dapui")
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	})

	-- use({ "ggandor/lightspeed.nvim" })
	use({
		"ggandor/leap.nvim",
		config = function()
			require("leap").setup({
				case_sensitive = true,
			})
			require("leap").set_default_keymaps()
		end,
	})
	use({
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup({
				keymaps = { -- vim-surround style keymaps
					insert = "ys",
					insert_line = "yss",
					visual = "S",
					delete = "ds",
					change = "cs",
				},
			})
		end,
	})
	use({
		"lewis6991/spellsitter.nvim",
		config = function()
			require("spellsitter").setup()
		end,
	})
	use({ "rcarriga/nvim-notify" })
	use({ "lewis6991/impatient.nvim" })

	-- Vimscript plugins
	-- use({ "flazz/vim-colorschemes" })
	-- use({
	-- 	"neoclide/coc.nvim",
	-- 	branch = "release",
	-- 	run = "yarn install --frozen-lockfile",
	-- })
	use({ "flwyd/vim-conjoin" })
	use({ "github/copilot.vim", disable = true })
	use({ "junegunn/vim-easy-align" })
	-- use({ "machakann/vim-sandwich" })
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
