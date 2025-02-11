return {
  {
    "nvim-telescope/telescope.nvim",
    -- replace all Telescope keymaps with only one mapping
    keys = function()
      -- local telescope = require("telescope")
      -- local builtin = require("telescope.builtin")
      -- local Util = require("lazyvim.util")
      return {
        { "<leader>tt", require("telescope.command").load_command, desc = "[Telescope] Open" },
        -- { "<leader>tg", Util.telescope("live_grep"), desc = "[Telescope] Live Grep" },
        -- { "<leader>tr", Util.telescope("reloader"), desc = "[Telescope] Reloader" },
        -- { "<leader>tb", Util.telescope("buffers"), desc = "Switch Buffer" },
        -- { "<c-p>", Util.telescope("find_files", { cwd = false }), desc = "Find Files" },
        -- { "<leader><c-p>", Util.telescope("find_files", { cwd = false }), desc = "Find Files (root dir)" },
        {
          "<leader>tm",
          function()
            require("telescope").load_extension("myles")
            vim.cmd("Telescope myles")
          end,
          desc = "[Telescope] Myles",
        },
        { "<leader>tu", "<cmd>Telescope undo<cr>", desc = "Undo Tree" },
        -- Lazy
        -- { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
        -- { "<leader>/", Util.telescope("live_grep"), desc = "Grep (root dir)" },
        -- { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
        -- { "<leader><space>", Util.telescope("files"), desc = "Find Files (root dir)" },
        -- find
        {
          "<c-p>",
          -- "<leader>tf",
          function()
            require("telescope").extensions.frecency.frecency({
              sorter = require("telescope").extensions.fzf.native_fzf_sorter(),
              workspace = "CWD",
            })
          end,
          desc = "Buffers",
        },
        -- { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
        -- { "<leader>ff", Util.telescope("files"), desc = "Find Files (root dir)" },
        -- { "<leader>fF", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
        -- { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
        -- { "<leader>fR", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
        -- git
        -- { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
        -- { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
        -- search
        -- { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
        -- { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
        -- { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
        -- { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
        -- { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
        -- { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
        -- { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
        -- { "<leader>tG", Util.telescope("live_grep"), desc = "Grep (root dir)" },
        -- { "<leader>tg", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
        -- { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
        -- { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
        -- { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
        -- { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
        -- { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
        -- { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
        -- { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
        -- { "<leader>tw", Util.telescope("grep_string", { word_match = "-w" }), desc = "Word (root dir)" },
        -- {
        --   "<leader>tW",
        --   Util.telescope("grep_string", { cwd = false, word_match = "-w" }),
        --   desc = "Word (cwd)",
        -- },
        -- { "<leader>tw", Util.telescope("grep_string"), mode = "v", desc = "Selection (root dir)" },
        -- { "<leader>tW", Util.telescope("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
        -- {
        -- 	"<leader>uC",
        -- 	Util.telescope("colorscheme", { enable_preview = true }),
        -- 	desc = "Colorscheme with preview",
        -- },
        -- {
        --   "<leader>ts",
        --   Util.telescope("lsp_document_symbols", {
        --     symbols = {
        --       "Class",
        --       "Function",
        --       "Method",
        --       "Constructor",
        --       "Interface",
        --       "Module",
        --       "Struct",
        --       "Trait",
        --       "Field",
        --       "Property",
        --     },
        --   }),
        --   desc = "Goto Symbol",
        -- },
        -- {
        --   "<leader>tS",
        --   Util.telescope("lsp_dynamic_workspace_symbols", {
        --     symbols = {
        --       "Class",
        --       "Function",
        --       "Method",
        --       "Constructor",
        --       "Interface",
        --       "Module",
        --       "Struct",
        --       "Trait",
        --       "Field",
        --       "Property",
        --     },
        --   }),
        --   desc = "Goto Symbol (Workspace)",
        -- },
        -- { "<leader>tw", telescope.extensions.git_worktree.git_worktrees, desc = "[Telescope] Worktrees" },
        -- {
        -- 	"<leader>wt",
        -- 	telescope.extensions.git_worktree.create_git_worktree,
        -- 	desc = "[Telescope] Create Worktree",
        -- },
        -- { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      }
    end,
    opts = function(_, opts)
      local telescope = require("telescope")
      telescope.load_extension("fzf")
      telescope.load_extension("undo")
      -- telescope.load_extension("ag")
      -- telescope.load_extension("file_browser")
      -- telescope.load_extension("git_worktree")
      -- telescope.load_extension("frecency")
      -- telescope.load_extension("gh")
      -- telescope.load_extension("dap")
      -- telescope.load_extension("notify")
      -- telescope.load_extension("ui-select")
      --
      local actions = require("telescope.actions")
      local find_files = {}
      if vim.fn.executable("fd") == 1 then
        -- apt install fd-find
        find_files = {
          find_command = { "fd", "--hidden", "--type=f", "--strip-cwd-prefix", "--exclude=.git/*" },
        }
      end
      return {
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close, -- close on escape
            },
          },
          winblend = 0,
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_ignore_patterns = { "node_modules", "*venv*", "__pycache__" },
          border = {},
          borderchars = { "", "", "", "", "", "", "", "" },
          color_devicons = true,
          use_less = true,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        },
        pickers = {
          find_files = find_files,
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
          },
          file_browser = {
            hijack_netwr = true,
          },
          undo = {},
          frecency = {
            db_safe_mode = false, -- disable prompt to delete entries
          },
        },
      }
    end,
    -- config = function()
    -- end,
    dependencies = {
      { "debugloop/telescope-undo.nvim" },
      { "nvim-telescope/telescope-frecency.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
  },
}
