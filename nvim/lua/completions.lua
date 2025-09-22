local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  
  mapping = cmp.mapping.preset.insert({
    -- Tab to select completion
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    
    -- Shift+Tab to go back
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    
    -- Enter to confirm selection
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    
    -- Ctrl+Space to trigger completion
    ["<C-Space>"] = cmp.mapping.complete(),
    
    -- Escape to close completion menu
    ["<C-e>"] = cmp.mapping.abort(),
  }),
  
  sources = cmp.config.sources({
    { name = "nvim_lsp" },    -- LSP completions (highest priority)
    { name = "luasnip" },     -- Snippet completions
  }, {
    { name = "buffer" },      -- Buffer completions (fallback)
    { name = "path" },        -- File path completions
  }),
  
  -- Completion window appearance
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})
