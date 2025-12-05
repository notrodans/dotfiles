return {
	"folke/which-key.nvim",
	keys = { "<leader>" },
	cmd = "WhichKey",
	opts = function()
		dofile(vim.g.base46_cache .. "whichkey")
	end,
}
