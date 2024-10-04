local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    html = { "prettierd" },
    json = { "prettierd" },
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    php = { "phpcsfixer" },
		css = { "prettierd" },
		scss = { "prettierd" },
		less = { "prettierd" },
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

require("conform").setup(options)
