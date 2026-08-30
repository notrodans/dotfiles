return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	cmd = "WhichKey",
	opts = function()
		dofile(vim.g.base46_cache .. "whichkey")
	end,
}
