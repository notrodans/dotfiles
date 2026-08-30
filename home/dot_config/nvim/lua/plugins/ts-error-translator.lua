return {
	"dmmulroy/ts-error-translator.nvim",
	ft = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
	},
	config = function()
		require("ts-error-translator").setup({
			auto_attach = true,
			servers = {
				"vtsls",
			},
		})
	end,
}
