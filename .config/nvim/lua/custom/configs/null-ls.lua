local null_ls = require "null-ls"

local b = null_ls.builtins

local sources = {
  b.formatting.stylua,
  b.formatting.eslint_d,
  b.formatting.stylelint,
  b.formatting.prettierd.with {
    filetypes = {
      "javascriptreact",
      "javascript",
      "typescriptreact",
      "typescript",
      "html",
      "json",
    },
  },
  b.formatting.phpcsfixer,
  b.diagnostics.stylelint,
  b.diagnostics.eslint_d,
  require "typescript.extensions.null-ls.code-actions",
}

null_ls.setup {
  debug = true,
  sources = sources,
}
