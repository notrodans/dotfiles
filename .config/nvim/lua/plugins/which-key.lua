return {
	"folke/which-key.nvim",
	lazy = false,
	keys = { "<leader>" },
	cmd = "WhichKey",
	opts = function()
		dofile(vim.g.base46_cache .. "whichkey")
	end,
}
