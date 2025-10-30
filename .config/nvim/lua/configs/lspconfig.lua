local nvlsp = require("nvchad.configs.lspconfig")
local lspconfig = require("lspconfig")

nvlsp.defaults()

local servers = {
	"jdtls",
	"gradle_ls",
	"prismals",
	"html",
	"emmet_ls",
	"lua_ls",
	"cssmodules_ls",
	"clangd",
	"marksman",
	"bashls",
	"mdx_analyzer",
	"css_variables",
	"gopls",
	"cssls",
	"intelephense",
	"stylelint_lsp",
	"biome",
	"tailwindcss",
	"vtsls",
	"jsonls",
	"lemminx",
	"eslint",
}

vim.lsp.enable(servers)
vim.lsp.config("intelephense", {
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
})
vim.lsp.config("stylelint_lsp", {
	filetypes = { "css", "scss", "less" },
	settings = {
		stylelintplus = {
			autoFixOnFormat = true,
		},
	},
})
vim.lsp.config("jsonls", {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = true,
		},
	},
})
vim.lsp.config("tailwindcss", {
	settings = {
		tailwindCSS = {
			experimental = {
				classRegex = {
					{ "cva|cn|cx\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
				},
			},
		},
	},
})
vim.lsp.config("biome", {
	settings = {
		biome = {
			requireConfiguration = true,
		},
	},
})
vim.lsp.config("jdtls", {
	settings = {
		java = {
			home = "~/.sdkman/candidates/java/21.0.2-open",
			configuration = {
				runtimes = {
					{
						name = "JavaSE-25",
						path = "~/.sdkman/candidates/java/25-open",
					},
					{
						name = "JavaSE-21",
						path = "~/.sdkman/candidates/java/21.0.2-open",
					},
					{
						name = "JavaSE-17",
						path = "~/.sdkman/candidates/java/17.0.8-tem",
					},
				},
			},
		},
	},
})
