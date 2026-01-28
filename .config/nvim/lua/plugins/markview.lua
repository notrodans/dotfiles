return {
	"OXY2DEV/markview.nvim",
	lazy = true,
	ft = "markdown",
	config = function()
		require("markview").setup({
			markdown_inline = {
				images = {
					enable = true,
				},
			},
			latex = {
				enable = false,
			},
		})
	end,
}
