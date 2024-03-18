-- EXAMPLE
local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities
local lspconfig = require "lspconfig"

local servers =
  { "html", "emmet_ls", "cssls", "lua_ls", "jsonls", "tsserver", "clangd", "tailwindcss", "marksman", "bashls" }

local json_settings = {
  json = {
    schemas = require("schemastore").json.schemas(),
    validate = true,
  },
}
local tsserver_settings = {
  diagnostics = { ignoredCodes = { 6133 } },
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    formatting = {
      enabled = false,
    },
    settings = (lsp == "jsonls" and json_settings or lsp == "tsserver" and tsserver_settings or {}),
  }
end

lspconfig.intelephense.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern("composer.json", "*.php"),
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
}

lspconfig.prismals.setup {
  capabilities = capabilities,
  on_init = on_init,
}
