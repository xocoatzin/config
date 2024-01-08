return {

  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      opts.window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      }
      opts.mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),

        -- Disable preconfig options
        ["<tab>"] = cmp.config.disable,
        ["<s-tab>"] = cmp.config.disable,
        ["<cr>"] = cmp.config.disable,

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
      })
      opts.sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "luasnip" },
        { name = "calc" },
        { name = "path" },
        { name = "emoji" },
        { name = "nvim_lua" },
        { name = "spell" },
        { name = "natdat" },
        { name = "buffer" },
      })
    end,
  },

  -- CMP
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-calc" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-emoji" },
  { "hrsh7th/cmp-nvim-lua" },
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  { "f3fora/cmp-spell" },
  { "saadparwaiz1/cmp_luasnip" },
  -- @date auto complete:
  { "Gelio/cmp-natdat", config = true },
}
