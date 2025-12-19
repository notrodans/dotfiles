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
				html = { "biome", "biome-organize-imports" },
				json = { "biome", "biome-organize-imports" },
				javascript = { "biome", "biome-organize-imports" },
				typescript = { "biome", "biome-organize-imports" },
				javascriptreact = { "biome", "biome-organize-imports" },
				typescriptreact = { "biome", "biome-organize-imports" },
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
				require("conform").format({ bufnr = args.buf, lsp_fallback = true })
			end,
		})
	end,
}
