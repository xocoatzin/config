return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        hide_numbers = true,
        highlights = {
          Normal = {
            link = "TelescopeNormal",
          },
          NormalFloat = {
            link = "TelescopeNormal",
          },
          FloatBorder = {
            link = "TelescopeNormal",
          },
        },
        direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
        float_opts = {
          border = "curved", -- 'single' | 'double' | 'shadow' | 'curved' | 'none' ... :h nvim_open_win()
          -- winblend = 3,
        },
        shell = "fish",
        on_open = function(terminal) end,
        on_close = function(terminal) end,
        on_exit = function(terminal, job, exit_code, name)
          vim.notify("Terminal " .. job .. " exited with code " .. exit_code, "info", {})
        end,
        winbar = {
          enabled = true,
          name_formatter = function(term) --  term: Terminal
            return term.name
          end,
        },
      })

      vim.keymap.set(
        "t",
        [[<c-\><c-\>]],
        "<Cmd>ToggleTerm<CR>",
        { buffer = bufnr, silent = true, desc = "[Term] Toggle" }
      )
      vim.keymap.set(
        "n",
        [[<c-\>]],
        '<Cmd>execute v:count . "ToggleTerm"<CR>',
        { buffer = bufnr, silent = true, desc = "[Term] Toggle" }
      )
      vim.keymap.set(
        "n",
        [[g<c-\><c-h>]],
        '<Cmd>execute v:count . "ToggleTerm direction=horizontal"<CR>',
        { buffer = bufnr, silent = true, desc = "[Term] Toggle horizontal" }
      )
      vim.keymap.set(
        "n",
        [[g<c-\><c-v>]],
        '<Cmd>execute v:count . "ToggleTerm direction=vertical"<CR>',
        { buffer = bufnr, silent = true, desc = "[Term] Toggle vertical" }
      )
      vim.keymap.set({ "n", "v" }, [[g<c-\><c-s>]], function()
        local mode = vim.fn.mode():byte()
        if mode == 110 then -- normal
          vim.api.nvim_command("ToggleTermSendCurrentLine" .. vim.v.count)
        elseif mode == 86 then -- visual line
          vim.api.nvim_command("ToggleTermSendVisualLines " .. vim.v.count)
        elseif mode == 22 then -- visual block
          vim.api.nvim_command("ToggleTermSendVisualSelection " .. vim.v.count)
        elseif mode == 118 then -- visual
          vim.api.nvim_command("ToggleTermSendVisualSelection " .. vim.v.count)
        end
      end, { buffer = bufnr, silent = true, desc = "[Term] Send lines" })
    end,
  },
}
