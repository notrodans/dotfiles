return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conf = require("conform")

		conf.setup({
			formatters = {
				["tex-fmt"] = {
					args = { "--config", vim.fn.expand("$HOME/") .. ".config/tex-fmt/tex-fmt.toml", "--stdin" },
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				html = { "biome", "biome-organize-imports", "eslint_d" },
				json = { "biome", "biome-organize-imports", "eslint_d" },
				javascript = { "biome", "biome-organize-imports", "eslint_d" },
				typescript = { "biome", "biome-organize-imports", "eslint_d" },
				javascriptreact = { "biome", "biome-organize-imports", "eslint_d" },
				typescriptreact = { "biome", "biome-organize-imports", "eslint_d" },
				php = { "phpcsfixer" },
				css = { "biome", "biome-organize-imports" },
				scss = { "biome", "biome-organize-imports" },
				less = { "biome", "biome-organize-imports" },
				tex = { "tex-fmt" },
				sql = { "pg_format" },
			},
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				conf.format({ bufnr = args.buf, lsp_fallback = true })
			end,
		})
	end,
}
