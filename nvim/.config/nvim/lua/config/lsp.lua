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
lsp.pyright.setup({
	on_attach = on_attach,
	flags = lsp_flags,
	-- settings = {
	-- 	python = {
	-- 		analysis = {
	-- 			reportUnusedVariable = false
	-- autoSearchPaths = true,
	-- useLibraryCodeForTypes = true,
	-- diagnosticMode = "workspace",
	-- 		},
	-- 	},
	-- },
})
-- lsp.taplo.setup({ on_attach = on_attach, flags = lsp_flags })  -- TOML
lsp.rust_analyzer.setup({ on_attach = on_attach, flags = lsp_flags })
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
