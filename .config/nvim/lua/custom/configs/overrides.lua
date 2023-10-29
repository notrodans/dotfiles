local M = {}

M.treesitter = {
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
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    "typescript-language-server",
    "tailwindcss-language-server",
    "prisma-language-server",
    "html-lsp",
    "css-lsp",
    "json-lsp",
    "emmet-ls",
    "rust-analyzer",
    "eslint_d",
    "prettierd",
    "stylua",
    "rustfmt",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
