lvim.plugins = {
  -- Themes
  { "morhetz/gruvbox" },
  { 'mcchrish/zenbones.nvim', requires = "rktjmp/lush.nvim" },
  { "ayu-theme/ayu-vim" },
  { 'NightCS/night.nvim', as = 'night' },
  { "rose-pine/neovim" },
  { "marko-cerovac/material.nvim" },
  -- Html, Js, Ts
  { "mattn/emmet-vim" },
  { "hrsh7th/cmp-vsnip" },
  { "hrsh7th/vim-vsnip" },
  { "onsails/lspkind-nvim" },
  { 'turbio/bracey.vim', run = 'cd app & npm install --prefix server' },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  -- Other
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    config = function()
      require("indent_blankline").setup({
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
      })
    end
  },
  { "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim" },
  { "terryma/vim-multiple-cursors" },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require "lsp_signature".on_attach({
        bind = true,
        handler_opts = {
          border = "rounded"
        }
      })
    end,
  },
  { "kabbamine/vcoolor.vim" },
  { "andweeb/presence.nvim" },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "*" }, {
        rgb = true,
        rrggbb = true,
        rrggbbaa = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
      })
    end,
  },
  {
    "rmagatti/goto-preview",
    config = function()
      require('goto-preview').setup {
        width = 140;
        height = 40;
        default_mappings = false;
        debug = false;
        opacity = nil;
        post_open_hook = nil
      }
    end
  },
}
