return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "rst",
        "tsx",
      })
      return {
        sync_install = false,
        auto_install = true,
        indent = { enable = true },
        -- incremental_selection = {
        --   enable = true,
        --   keymaps = {
        --     -- init_selection = "<C-space>",
        --     -- node_incremental = "<C-space>",
        --     -- scope_incremental = false,
        --     -- node_decremental = "<bs>",
        --     init_selection = "gnn",
        --     node_incremcntal = "grn",
        --     scope_incremental = "grc",
        --     node_decremental = "grm",
        --   },
        -- },
        highlight = {
          enable = true,
          disable = function(lang, buf)
            local max_filesize_kb = 500
            local max_filesize = max_filesize_kb * 1024
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              vim.notify("Treesitter highlight disabled (file size > " .. max_filesize_kb .. "kb)", "warn", {})
              return true
            end
          end,
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
      }
    end,
  },
}
