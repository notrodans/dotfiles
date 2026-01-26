return {
	"OXY2DEV/markview.nvim",
	lazy = true,
	ft = "markdown",
	config = function()
		require("markview").setup({
			latex = {
				enable = false,
			},
		})
	end,
}
