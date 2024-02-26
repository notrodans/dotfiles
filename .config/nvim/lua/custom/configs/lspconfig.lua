local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "emmet_ls", "cssls", "lua_ls", "jsonls", "tsserver", "clangd", "tailwindcss" }

local json_settings = {
  json = {
    schemas = require("schemastore").json.schemas(),
    validate = true,
  },
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    formatting = {
      enabled = false,
    },
    settings = (lsp == "jsonls" and json_settings or {}),
  }
end

lspconfig.intelephense.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern("composer.json", "*.php"),
  settings = {
    intelephense = {
      telemetry = {
        enabled = false,
        stubs = {
          "bcmath",
          "bz2",
          "calendar",
          "Core",
          "curl",
          "zip",
          "zlib",
          "woocommerce",
          "acf-pro",
          "wordpress",
          "wordpress-globals",
          "wp-cli",
          "genesis",
          "polylang",
        },
        -- environment = {
        --   includePaths = "/home/notrodans/.composer/vendor/php-stubs/", -- this line forces the composer path for the stubs in case inteliphense don't find it...
        -- },
      },
      files = {
        maxSize = 5000000,
      },
    },
  },
}

lspconfig.prismals.setup {
  capabilities = capabilities,
}
-- "typescript.suggestionActions.enabled": false
lspconfig.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  formatting = {
    enabled = false,
  },
  settings = {
    diagnostics = { ignoredCodes = { 6133 } },
  },
}

--
-- lspconfig.pyright.setup { blabla}
