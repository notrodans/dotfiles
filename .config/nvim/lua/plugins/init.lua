return {
  "nvim-lua/plenary.nvim",

  {
    "nvchad/base46",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "nvchad/ui",
    lazy = false,
    config = function()
      require "nvchad"
    end,
  },

  "nvzone/volt",
  "nvzone/menu",
  { "nvzone/minty", cmd = { "Huefy", "Shades" } },

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      dofile(vim.g.base46_cache .. "devicons")
      return { override = require "nvchad.icons.devicons" }
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    opts = {
      indent = { char = "│", highlight = "IblChar" },
      scope = { char = "│", highlight = "IblScopeChar" },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "blankline")

      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)

      dofile(vim.g.base46_cache .. "blankline")
    end,
  },

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "nvchad.configs.nvimtree"
    end,
  },

  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    opts = function()
      dofile(vim.g.base46_cache .. "whichkey")
      return {}
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local conf = require("conform")

      conf.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          html = { "prettierd", "prettier" },
          json = { "prettierd", "prettier" },
          javascript = { "eslint_d" },
          typescript = { "eslint_d" },
          javascriptreact = { "eslint_d" },
          typescriptreact = { "eslint_d" },
          php = { "phpcsfixer" },
          css = { "prettierd", "prettier" },
          scss = { "prettierd", "prettier" },
          less = { "prettierd", "prettier" },
        },

      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
          require("conform").format { bufnr = args.buf, lsp_fallback = true }
        end,
      })
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
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require("luasnip.loaders.from_vscode").load_standalone { path = "~/.config/nvim/snippets/a.code-snippets" }
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      local cmp = require "cmp"
      cmp.setup {
        sources = {
          { name = { "codeium" } }
        }
      }
      return require "nvchad.configs.cmp"
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
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    lazy = false,
    config = function()
      require("codeium").setup {
        virtual_text = {
          key_bindings = {
            accept = "<C-g>",
          }
        }
      }
    end,
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
