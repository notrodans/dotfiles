return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre' -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePre", "BufNewFile" },
    config = function()
      require "configs.lint"
    end,
  },

  {

    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  {
    "b0o/schemastore.nvim",
  },

  -- Override plugin definition options
  {
    "jose-elias-alvarez/typescript.nvim",
  },

  {
    "ccaglak/namespace.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require "configs.null-ls"
    end,
  },

  {
    "ggandor/leap.nvim",
    lazy = false,
    config = function()
      require("leap").add_default_mappings(true)
    end,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    config = function()
      require("todo-comments").setup()
    end,
  }, -- To make a plugin not be loaded
  {
    "Exafunction/codeium.vim",
    lazy = false,
  },

  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = {
      pkgs = {
        -- LSP
        "bash-language-server",
        "lua-language-server",
        "typescript-language-server",
        "tailwindcss-language-server",
        "prisma-language-server",
        "html-lsp",
        "css-lsp",
        "json-lsp",
        "emmet-ls",
        "intelephense",
        "marksman",

        -- LINTERS AND FORMATTERS
        "eslint_d",
        "prettierd",
        "stylua",
        "phpcs",
        "php-cs-fixer",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      auto_install = true,
      ensure_installed = {
        "tsx",
        "javascript",
        "typescript",
        "scss",
        "css",
        "html",
        "json",
        "lua",
        "prisma",
        "php",
      },
      indent = {
        enable = true,
        -- disable = {
        --   "python"
        -- },
      },
    },
    autotag = {
      enable = true,
    },
  },
}
