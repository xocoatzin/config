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
-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = {
	"angularls",
	"bashls",
	"ccls",
	"cmake",
	"cssls",
	"dockerls",
	"eslint",
	"gopls",
	"graphql",
	"html",
	"jsonls",
	"terraformls",
	"texlab",
	"vimls",
	"yamlls",
	"zk",
	"rust_analyzer",
	"pyright",
	"tsserver",
}
local lspconfig = require("lspconfig")
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		-- on_attach = my_custom_on_attach,
		capabilities = capabilities,
	})
end
