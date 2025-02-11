return {
  -- {
  --   "kosayoda/nvim-lightbulb",
  --   opts = {
  --     autocmd = { enabled = true },
  --   },
  -- },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      vim.g.autoformat = true
      -- opts.autoformat = true
      opts.servers.pyright = {}
      opts.servers.ruff_lsp = {}
      opts.servers.lua_ls = {
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
            format = {
              enable = true,
              -- Put format options here
              -- NOTE: the value should be STRING!!
              defaultConfig = {
                indent_style = "space",
                indent_size = "2",
              },
            },
          },
        },
      }
      opts.servers.jsonls = {
        -- lazy-load schemastore when needed
        -- on_new_config = function(new_config)
        --   new_config.settings.json.schemas = new_config.settings.json.schemas or {}
        --   vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
        -- end,
        settings = {
          json = {
            format = {
              enable = true,
            },
            validate = { enable = true },
          },
        },
      }
      opts.servers.tsserver = {
        keys = {
          { "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", desc = "Organize Imports" },
          { "<leader>cR", "<cmd>TypescriptRenameFile<CR>", desc = "Rename File" },
        },
        settings = {
          typescript = {
            format = {
              indentSize = vim.o.shiftwidth,
              convertTabsToSpaces = vim.o.expandtab,
              tabSize = vim.o.tabstop,
            },
          },
          javascript = {
            format = {
              indentSize = vim.o.shiftwidth,
              convertTabsToSpaces = vim.o.expandtab,
              tabSize = vim.o.tabstop,
            },
          },
          completions = {
            completeFunctionCalls = true,
          },
        },
      }
      local clangd_capabilities = vim.lsp.protocol.make_client_capabilities()
      clangd_capabilities.offsetEncoding = { "utf-16" }
      opts.servers.clangd = {
        capabilities = clangd_capabilities,
      }
      opts.setup.tsserver = function(_, _opts)
        require("typescript").setup({ server = _opts })
        return true
      end
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {
        -- "angularls",
        -- "arduino_language_server",
        "bashls",
        -- "black",
        "clangd",
        "cssls",
        -- "cmake",
        "diagnosticls",
        -- "dockerls",
        "eslint",
        -- "gopls",
        "graphql",
        "html",
        "jsonls",
        -- "sumneko_lua",
        "pyright",
        -- "terraformls",
        -- "tsserver",
        "vimls",
        "yamlls",
        "zk",
        -- "stylua",
        -- "shfmt",
        -- "rust_analyzer",
      }
    end,
  },
}
