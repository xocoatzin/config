return {

  { "nvimdev/dashboard-nvim", enabled = false },
  { "echasnovski/mini.indentscope", enabled = false },
  { "folke/noice.nvim", enabled = false },
  { "nvimdev/dashboard-nvim", enabled = false },
  { "saghen/blink.cmp", enabled = false },
  { "hrsh7th/nvim-cmp", enabled = false },

  {
    "goolord/alpha-nvim",
    enabled = false,
    event = "VimEnter",
    opts = function(_, opts)
      opts.section.header.val = ""
    end,
  },
}
