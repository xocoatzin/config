return {
  {
    "rcarriga/nvim-notify",
    opts = function(_, opts)
      opts.timeout = 5000
      opts.background_colour = "#000000"
      opts.stages = "slide"
    end,
  },

  -- {
  --   "akinsho/bufferline.nvim",
  --   opts = function(_, opts)
  --     -- opts.options.buffer_close_icon = ""
  --     -- opts.options.modified_icon = "●"
  --     -- opts.options.close_icon = ""
  --     -- opts.options.left_trunc_marker = ""
  --     -- opts.options.right_trunc_marker = ""
  --     opts.options.max_name_length = 14
  --     opts.options.max_prefix_length = 13
  --     opts.options.tab_size = 18
  --     opts.options.enforce_regular_tabs = true
  --     opts.options.view = "multiwindow"
  --     opts.options.show_buffer_close_icons = true
  --     opts.options.separator_style = "thin"
  --   end,
  -- },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local icons = require("lazyvim.config").icons
      local Util = require("lazyvim.util")

      opts.options.section_separators = { left = "", right = "" }
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = function(_, opts)
      opts.space_char_blankline = " "
      opts.use_treesitter = true
      opts.show_current_context = true
      opts.show_current_context_start = false
      opts.show_end_of_line = true
      opts.context_patterns = { ".*" }
      opts.show_first_indent_level = false
      opts.filetype_exclude = {}
      opts.buftype_exclude = { "terminal" }
    end,
  },
  { "echasnovski/mini.indentscope", enabled = false },

  {
    "folke/noice.nvim",
    enabled = false,
    opts = function(_, opts)
      -- opts.cmdline = { view = "cmdline" }
    end,
  },

  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function(_, opts)
      opts.section.header.val = ""
    end,
  },

  { "monaqa/dial.nvim" },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        selection_chars = "1234567890FJDKSLA;CMRUEIWOQP",
      })
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "prettierd")
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      table.insert(opts.sources, nls.builtins.formatting.prettierd)
      table.insert(opts.sources, require("typescript.extensions.null-ls.code-actions"))
    end,
  },

  -- {
  --   "karb94/neoscroll.nvim",
  --   config = function()
  --     local t = {}
  --     -- Syntax: t[keys] = {function, {function arguments}}
  --     t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "50" } }
  --     t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "50" } }
  --     t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "50" } }
  --     t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "50" } }
  --     t["<C-y>"] = { "scroll", { "-0.10", "false", "50" } }
  --     t["<C-e>"] = { "scroll", { "0.10", "false", "50" } }
  --     t["zt"] = { "zt", { "50" } }
  --     t["zz"] = { "zz", { "50" } }
  --     t["zb"] = { "zb", { "50" } }
  --     require("neoscroll.config").set_mappings(t)
  --   end,
  --   opts = {
  --     hide_cursor = true, -- Hide cursor while scrolling
  --     stop_eof = true, -- Stop at <EOF> when scrolling downwards
  --     use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
  --     respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  --     cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  --   },
  -- },

  { "jose-elias-alvarez/typescript.nvim" },

  -- Vimscript
  { "flwyd/vim-conjoin" },
  { "junegunn/vim-easy-align" },
  -- { "qpkorr/vim-bufkill" },
  { "tpope/vim-abolish" },
  { "tpope/vim-fugitive" },
  { "tpope/vim-sleuth" },
  { "mbbill/undotree" },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox-baby",
    },
  },
}
