return {
  {
    "mhinz/vim-signify",
    init = function(_)
      vim.g.signify_skip = { vcs = { deny = { "git" } } }
    end,
    config = function(_, _)
      vim.api.nvim_set_hl(0, "SignifySignAdd", { link = "GitSignsAdd" })
      vim.api.nvim_set_hl(0, "SignifySignChange", { link = "GitSignsChange" })
      vim.api.nvim_set_hl(
        0,
        "SignifySignChangeDelete",
        { link = "GitSignsChange" }
      )
      vim.api.nvim_set_hl(0, "SignifySignDelete", { link = "GitSignsDelete" })
      vim.api.nvim_set_hl(
        0,
        "SignifySignDeleteFirstLine",
        { link = "GitSignsDelete" }
      )

      vim.g.signify_sign_add = "▎"
      vim.g.signify_sign_change = "▎"
      vim.g.signify_sign_delete = ""
      vim.g.signify_sign_delete_first_line = ""
      vim.g.signify_sign_change_delete = ""
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        mappings = {
          i = {
            -- I don't like having to tap <Esc> twice to exit Telescope.
            ["<esc>"] = require("telescope.actions").close,
          },
        },
      },
    },
  },

  {
    "RRethy/vim-illuminate",
    config = function(plug, opts)
      -- Using Meta/Alt can result in <Esc> being interpreted as Meta/Alt, which
      -- makes for odd behaviors when quickly pressing <Esc> sometimes, so
      -- disable Meta chords.
      -- https://github.com/neovim/neovim/issues/20064
      vim.keymap.del("n", "<A-n>")
      vim.keymap.del("n", "<A-p>")
      vim.keymap.del({ "o", "x" }, "<A-i>")

      -- Call LazyVim's config for this plugin.
      plug._.super.config(plug, opts)
    end,
  },
}
