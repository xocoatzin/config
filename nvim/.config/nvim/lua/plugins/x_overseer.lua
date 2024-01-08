return {
  {
    "stevearc/overseer.nvim",
    keys = {
      { "<leader>oo", "<cmd>OverseerToggle<CR>", mode = "n" },
      { "<leader>or", "<cmd>OverseerRun<CR>", mode = "n" },
      { "<leader>oc", "<cmd>OverseerRunCmd<CR>", mode = "n" },
      -- { "<leader>ol", "<cmd>OverseerLoadBundle<CR>", mode = "n" },
      -- { "<leader>ob", "<cmd>OverseerToggle! bottom<CR>", mode = "n" },
      -- { "<leader>od", "<cmd>OverseerQuickAction<CR>", mode = "n" },
      -- { "<leader>os", "<cmd>OverseerTaskAction<CR>", mode = "n" },
    },
    opts = {
      templates = { "builtin", "meta.buck" },
    },
  },
}
