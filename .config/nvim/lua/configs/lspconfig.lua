local lspconfig = require "lspconfig"
local configs = require "nvchad.configs.lspconfig"

local servers = {
  prismals = {},
  html = {},
  emmet_ls = {},
  lua_ls = {},
  cssmodules_ls = {},
  clangd = {},
  marksman = {},
  bashls = {},
  mdx_analyzer = {},

  tailwindcss = {
    settings = {
      tailwindCSS = {
        experimental = {
          classRegex = {
            { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
            { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
          },
        },
      },
    },
  },

  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = true,
      },
    },
  },

  ts_ls = {
    settings = {
      diagnostics = { ignoredCodes = { 6133 } },
    },
  },

  cssls = {
    settings = {
      css = {
        validate = false,
      },
      scss = {
        validate = false,
      },
      less = {
        validate = false,
      },
    },
  },

  stylelint_lsp = {
    filetypes = { "css", "scss", "less" },
    settings = {
      stylelintplus = {
        autoFixOnFormat = true,
      },
    },
  },

  intelephense = {
    root_dir = lspconfig.util.root_pattern("composer.json", "*.php"),
    filetypes = { "php" },
    settings = {
      intelephense = {
        telemetry = {
          enabled = false,
        },
        files = {
          maxSize = 5000000,
        },
      },
    },
  },
}

for name, opts in pairs(servers) do
  opts.on_init = configs.on_init
  opts.on_attach = configs.on_attach
  opts.capabilities = configs.capabilities
  opts.filetypes = servers[name].filetypes
  opts.root_dir = servers[name].root_dir

  require("lspconfig")[name].setup(opts)
end

return nil
