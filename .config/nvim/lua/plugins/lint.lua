return {
	"mfussenegger/nvim-lint",
	event = { "BufWritePre", "BufNewFile" },
	config = function()
		require("configs.lint")
	end,
}
