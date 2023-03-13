--              AstroNvim Configuration Table
-- All configuration changes should go inside of the table below

-- You can think of a Lua "table" as a dictionary like data structure the
-- normal format is "key = value". These also handle array like data structures
-- where a value with no key simply has an implicit numeric key

local config = {
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false, -- automatically quit the current session after a successful update
    -- remotes = { -- easily add new remotes to track
    --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
    --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
    --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    -- },
  },
  -- Set colorscheme to use
  colorscheme = "kanagawabones",
  -- Add highlight groups in any theme
  highlights = {
    -- init = { -- this table overrides highlights in all themes
    -- Normal = { bg = NONE },
    -- },
    -- duskfox = { -- a table of overrides/changes to the duskfox theme
    --   Normal = { bg = "#000000" },
    -- },
  },
  -- set vim options here (vim.<first_key>.<second_key> = value)

  options = {
    opt = {
      swapfile = false,
      spell = false,
      number = false,
      relativenumber = false,
      signcolumn = "yes",
      cmdheight = 1,
      completeopt = { "menu", "menuone", "noselect" },
      tabstop = 4,
      shiftwidth = 4,
      clipboard = "unnamedplus",
      background = "dark",
    },
    g = {
      mapleader = " ", -- sets vim.g.mapleader
      autoformat_enabled = false, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
      cmp_enabled = true, -- enable completion at start
      autopairs_enabled = true, -- enable autopairs at start
      diagnostics_enabled = true, -- enable diagnostics at start
      icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
      ui_notifications_enabled = false, -- disable notifications when toggling UI elements
    },
  },

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
    signs = false,
    update_in_insert = true,
  },
  -- Extend LSP configuration
  lsp = {
    -- enable servers that you already have installed without mason
    servers = {
      "tsserver",
    },
    formatting = {
      format_on_save = {
        enabled = false,
        allow_filetypes = {
          -- "go",
        },
        ignore_filetypes = {
          -- "python"
        },
      },
      disabled = {
        "jsonls",
        "html",
        "tsserver",
        "lua_ls",
      },
      async = true,
    },

    setup_handlers = {
      tsserver = function(_, opts) require("typescript").setup { server = opts } end,
    },

    -- easily add or disable built in mappings added during LSP attaching
    mappings = {
      n = {
        ["[d"] = false,
        ["]d"] = false,
        ["gl"] = false,
      },
    },

    config = {
      cssls = { -- override table for require("lspconfig").cssls.setup({...})
        settings = {
          css = {
            validate = false,
          },
          less = {
            validate = false,
          },
          scss = {
            validate = false,
          },
        },
      },
    },
  },
  mappings = {
    n = {
      ["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
      ["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
      ["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
      ["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
      ["<leader>b"] = { name = "Buffers" },
      ["<C-f>"] = {
        "<Cmd>Lspsaga lsp_finder<CR>",
        desc = "lspsaga lsp finder",
      },
      ["[d"] = {
        "<Cmd>Lspsaga diagnostic_jump_prev<CR>",
        desc = "prev diagnostic line",
      },
      ["]d"] = {
        "<Cmd>Lspsaga diagnostic_jump_next<CR>",
        desc = "next diagnostic line",
      },
      ["gl"] = {
        "<Cmd>Lspsaga show_line_diagnostics<CR>",
        desc = "diagnostics line",
      },
    },

    t = {},
  },
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = {
          "tohtml",
          "gzip",
          "matchit",
          "zipPlugin",
          "netrwPlugin",
          "tarPlugin",
          "matchparen",
        },
      },
    },
  },
  -- Configure plugins
  plugins = {
    { "avneesh0612/react-nextjs-snippets" },
    {
      "onsails/lspkind.nvim",
      config = function()
        require("lspkind").init {
          mode = "symbol_text",
        }
      end,
    },
    { "mcchrish/zenbones.nvim", dependencies = { "rktjmp/lush.nvim" } },
    { "EdenEast/nightfox.nvim" },
    { "nyoom-engineering/oxocarbon.nvim" },
    { "sainnhe/everforest" },
    { "ellisonleao/gruvbox.nvim" },
    { "folke/tokyonight.nvim" },
    { "jay-babu/mason-nvim-dap.nvim", enabled = false },
    { "mfussenegger/nvim-dap", enabled = false },
    { "rcarriga/nvim-dap-ui", enabled = false },
    {
      "rose-pine/neovim",
      name = "rose-pine",
      lazy = false,
      priority = 1000,
      config = function()
        require("rose-pine").setup {
          bold_vert_split = true,
          dark_variant = "moon",
        }
      end,
    },
    { "catppuccin/nvim" },
    { "wakatime/vim-wakatime", event = { "BufRead" } },
    {
      "andweeb/presence.nvim",
      event = { "BufNewFile", "BufRead", "BufAdd" },
      config = function()
        require("presence"):setup {
          neovim_image_text = "Лучше чем твоё говно",
          editing_text = "Строчу %s",
          file_explorer_text = "Чекаю %s",
          git_commit_text = "Пошёл в гит",
          plugin_manager_text = "Плагиныыы",
          reading_text = "Задрочу %s",
          workspace_text = "Воркаю %s",
          line_number_text = "Line %s out of %s",
        }
      end,
    },
    { "lukas-reineke/indent-blankline.nvim", enabled = false },
    { "windwp/nvim-ts-autotag", config = function() require("nvim-ts-autotag").setup() end },
    {
      "folke/todo-comments.nvim",
      lazy = false,
      config = function() require("todo-comments").setup {} end,
    },
    {
      "glepnir/lspsaga.nvim",
      event = "BufRead",
      config = function()
        require("lspsaga").setup {
          symbol_in_winbar = {
            enable = false,
          },
          ui = {
            winblend = 10,
            border = "rounded",
            colors = {
              normal_bg = "#002b36",
            },
          },
        }
      end,
    },
    {
      "L3MON4D3/LuaSnip",
      config = function(plugin, opts)
        require "plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
        local luasnip = require "luasnip"
        luasnip.filetype_extend("javascript", { "javascriptreact" })
        require("luasnip.loaders.from_vscode").load { paths = { "./lua/user/snippets" } }
      end,
    },
    {
      "folke/which-key.nvim",
      config = function()
        vim.o.timeoutlen = 300
        local wk = require "which-key"
        wk.register({
          b = { name = "Buffer" },
        }, { mode = "n", prefix = "<leader>" })
      end,
    },
    {
      "goolord/alpha-nvim",
      opts = function(_, opts)
        opts.section.header.val = {
          " █████  ███████ ████████ ██████   ██████",
          "██   ██ ██         ██    ██   ██ ██    ██",
          "███████ ███████    ██    ██████  ██    ██",
          "██   ██      ██    ██    ██   ██ ██    ██",
          "██   ██ ███████    ██    ██   ██  ██████",
          " ",
          "    ███    ██ ██    ██ ██ ███    ███",
          "    ████   ██ ██    ██ ██ ████  ████",
          "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
          "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
          "    ██   ████   ████   ██ ██      ██",
        }
        return opts
      end,
    },
    "jose-elias-alvarez/typescript.nvim",
    {

      "jose-elias-alvarez/null-ls.nvim",
      opts = function(_, config)
        local null_ls = require "null-ls"
        config.sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.eslint_d,
          null_ls.builtins.formatting.stylelint,
          null_ls.builtins.formatting.prettierd.with {
            filetypes = {
              "javascriptreact",
              "javascript",
              "typescriptreact",
              "typescript",
              "html",
              "json",
            },
          },
          null_ls.builtins.diagnostics.stylelint,
          null_ls.builtins.diagnostics.eslint_d,
          require "typescript.extensions.null-ls.code-actions",
        }
        return config
      end,
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
        },
      },
    },
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = {
          "tsserver",
          "lua_ls",
          "html",
          "cssls",
          "jsonls",
          "emmet_ls",
          "lemminx",
          "tailwindcss",
        },
      },
    },
    {
      "jay-babu/mason-null-ls.nvim",
      opts = {
        ensure_installed = {
          "eslint_d",
          "prettierd",
          "xmlformatter",
          "stylua",
        },
        automatic_setup = false,
      },
    },
    {
      "hrsh7th/nvim-cmp",
      commit = "a9c701fa7e12e9257b3162000e5288a75d280c28", -- https://github.com/hrsh7th/nvim-cmp/issues/1382
      dependencies = {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
      },
      event = "InsertEnter",
      opts = function()
        local cmp = require "cmp"
        local snip_status_ok, luasnip = pcall(require, "luasnip")
        local lspkind_status_ok, lspkind = pcall(require, "lspkind")
        if not snip_status_ok then return end
        local border_opts = {
          border = "single",
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        }

        local function has_words_before()
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
        end

        return {
          enabled = function()
            if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then return false end
            return vim.g.cmp_enabled
          end,
          preselect = cmp.PreselectMode.None,
          formatting = {
            fields = { "kind", "abbr", "menu" },
            format = lspkind.cmp_format {
              before = function(entry, vim_item)
                vim_item.menu = entry.completion_item.detail
                return vim_item
              end,
            },
          },
          snippet = {
            expand = function(args) luasnip.lsp_expand(args.body) end,
          },
          duplicates = {
            nvim_lsp = 1,
            luasnip = 1,
            cmp_tabnine = 1,
            buffer = 1,
            path = 1,
          },
          confirm_opts = {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          window = {
            completion = cmp.config.window.bordered(border_opts),
            documentation = cmp.config.window.bordered(border_opts),
          },
          mapping = {
            ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
            ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
            ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
            ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
            ["<C-Space>"] = cmp.mapping(cmp.mapping.complete {}, { "i", "c" }),
            ["<C-y>"] = cmp.config.disable,
            ["<C-e>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
            ["<CR>"] = cmp.mapping.confirm { select = false },
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          },
          sources = cmp.config.sources {
            { name = "nvim_lsp", priority = 1000 },
            { name = "luasnip", priority = 750 },
            { name = "path", priority = 500 },
            { name = "buffer", priority = 250 },
          },
        }
      end,
    },
  },
  heirline = {
    -- -- Customize different separators between sections
    separators = {
      breadcrumbs = " > ",
      tab = { "", "" },
    },
    -- -- Customize colors for each element each element has a `_fg` and a `_bg`
    -- colors = function(colors)
    --   colors.git_branch_fg = astronvim.get_hlgroup "Conditional"
    --   return colors
    -- end,
    -- -- Customize attributes of highlighting in Heirline components
    -- attributes = {
    --   -- styling choices for each heirline element, check possible attributes with `:h attr-list`
    --   git_branch = { bold = true }, -- bold the git branch statusline component
    -- },
    -- -- Customize if icons should be highlighted
    -- icon_highlights = {
    --   breadcrumbs = false, -- LSP symbols in the breadcrumbs
    --   file_icon = {
    --     winbar = false, -- Filetype icon in the winbar inactive windows
    --     statusline = true, -- Filetype icon in the statusline
    --     tabline = true, -- Filetype icon in the tabline
    --   },
    -- },
  },
  polish = function()
    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
  end,
}

return config
