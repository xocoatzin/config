return {

  { "nvimdev/dashboard-nvim", enabled = false },
  { "echasnovski/mini.indentscope", enabled = false },
  { "folke/noice.nvim", enabled = false },

  {
    "goolord/alpha-nvim",
    enabled = false,
    event = "VimEnter",
    opts = function(_, opts)
      opts.section.header.val = ""
    end,
  },
}
