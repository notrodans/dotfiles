return {
	"stevearc/oil.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		return require("configs.oil")
	end,
	config = function(_, opts)
		require("oil").setup(opts)
	end,
}
