return {
	"nvchad/base46",
	branch = "v3.0",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	build = function()
		require("base46").load_all_highlights()
	end,
}
