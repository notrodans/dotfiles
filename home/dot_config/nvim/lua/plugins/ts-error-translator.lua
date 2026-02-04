return {
	"dmmulroy/ts-error-translator.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("ts-error-translator").setup({
			auto_attach = true,
			servers = {
				"vtsls",
			},
		})
	end,
}
