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
		"php",
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
		"phpcsfixer",
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
