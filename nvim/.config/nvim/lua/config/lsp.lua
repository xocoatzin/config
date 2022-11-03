require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"angularls",
		-- "arduino_language_server",
		"bashls",
		"clangd",
		"cssls",
		"cmake",
		"diagnosticls",
		"dockerls",
		"eslint",
		"gopls",
		"graphql",
		"html",
		"jsonls",
		"sumneko_lua",
		"pyright",
		"terraformls",
		"tsserver",
		"vimls",
		"yamlls",
		"zk",
		"rust_analyzer",
	},
	automatic_installation = false,
})

local border = {
	{ "╭", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "╮", "FloatBorder" },
	{ "│", "FloatBorder" },
	{ "╯", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "╰", "FloatBorder" },
	{ "│", "FloatBorder" },
}

-- To instead override globally
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or border
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = function(desc)
	return { noremap = true, silent = true, desc = "[LSP] " .. desc }
end
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts("Open Float"))
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts("Go to Prev"))
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts("Go to Next"))
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts("Set Loc List"))

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local buffopts = function(desc)
		return { noremap = true, silent = true, buffer = bufnr, desc = "[LSP] " .. desc }
	end

	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, buffopts("Go to Declaration"))
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, buffopts("Go to Definition"))
	vim.keymap.set("n", "K", vim.lsp.buf.hover, buffopts("Hover"))
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, buffopts("Go to Implementation"))
	vim.keymap.set("n", "<space>k", vim.lsp.buf.signature_help, buffopts("Signature Help"))
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, buffopts("Add Workspace Folder"))
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, buffopts("Remove Workspace Folder"))
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, buffopts("List Workspace Folders"))
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, buffopts("Type Definition"))
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, buffopts("Rename"))
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, buffopts("Code Action"))
	vim.keymap.set("n", "gr", vim.lsp.buf.references, buffopts("References"))
	vim.keymap.set("n", "<space>f", function() vim.lsp.buf.format({async=true}) end, buffopts("Formatting"))

	if client and client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_create_augroup("lsp_document_highlight", {
			clear = false,
		})
		vim.api.nvim_clear_autocmds({
			buffer = bufnr,
			group = "lsp_document_highlight",
		})
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = "lsp_document_highlight",
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = "lsp_document_highlight",
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end

	vim.notify("LSP attached: " .. client.config.name, "info", {})
end

local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- vim.api.nvim_create_autocmd("CursorHold", {
-- 	buffer = bufnr,
-- 	callback = function()
-- 		local opts = {
-- 			focusable = false,
-- 			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
-- 			border = "rounded",
-- 			source = "always",
-- 			prefix = " ",
-- 			scope = "cursor",
-- 		}
-- 		vim.diagnostic.open_float(nil, opts)
-- 	end,
-- })

-- Notifications
vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
	local client = vim.lsp.get_client_by_id(ctx.client_id)
	local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
	notify({ result.message }, lvl, {
		title = "LSP | " .. client.name,
		timeout = 10000,
		keep = function()
			return lvl == "ERROR" or lvl == "WARN"
		end,
	})
end

-- Folding
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

local extension_path = vim.env.HOME .. "/.config/nvim/vscode-ext/vadimcn.vscode-lldb-1.7.3.vsix/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

require("rust-tools").setup({
	capabilities = capabilities,
	server = {
		on_attach = on_attach,
		flags = lsp_flags,
	},
	tools = {},
	dap = {
		adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
	},
})

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
--
local lsp = require("lspconfig")

local init_servers = function(language_servers)
	for _, ls in ipairs(language_servers) do
		lsp[ls].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			flags = lsp_flags,
		})
	end
end

if require("config.my_meta").is_meta then
	require("meta.cmds")
	local meta = require("meta")
	local null_ls = require("null-ls")

	local language_servers = {
		"bashls",
		-- "diagnosticls",
		"jsonls",
		"vimls",
		"zk",
		"hhvm",
		"rusty@meta",
		"pyls@meta",
		-- "wasabi@meta",
		"pyre@meta",
		"cppls@meta",
		"buckls@meta",
		"prettier@meta",
	}
	init_servers(language_servers)

	require("null-ls").setup({
		on_attach = on_attach,
		sources = {
			-- null_ls.builtins.completion.spell,
			meta.null_ls.diagnostics.arclint,
			meta.null_ls.formatting.arclint,
			null_ls.builtins.formatting.trim_whitespace
		},
	})

	lsp.pyright.setup({
		on_attach = on_attach,
		capabilities = capabilities,
		flags = lsp_flags,
		settings = {
			python = {
				analysis = {
					diagnosticSeverityOverrides = {
						reportMissingImports = "none",
						reportUnusedVariable = "information",
					},
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "workspace",
					analysis = {logLevel = "Trace"},
				},
			},
		},
		-- single_file_support = true
	})
else
	local language_servers = {
		"angularls",
		"bashls",
		"ccls",
		"cmake",
		"cssls",
		"diagnosticls",
		"dockerls",
		"eslint",
		"gopls",
		"graphql",
		"html",
		"jsonls",
		-- 'taplo',
		-- 'rust_analyzer',
		"terraformls",
		"texlab",
		"tsserver",
		"vimls",
		"zk",
	}
	init_servers(language_servers)

	lsp.pyright.setup({
		on_attach = on_attach,
		capabilities = capabilities,
		flags = lsp_flags,
		settings = {
			python = {
				analysis = {
					reportUnusedVariable = "none",
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "workspace",
				},
			},
		},
	})
	lsp.yamlls.setup({
		on_attach = on_attach,
		capabilities = capabilities,
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
end
