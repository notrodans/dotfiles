return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	config = function()
		require("snacks").setup(
			---@type snacks.Config
			{
				image = {
					enabled = true,
					backend = "kitty",
					doc = {
						inline = true,
						float = false,
						max_width = 3000,
						max_height = 800,
					},
					math = {
						enabled = true,
						latex = {
							font_size = "small",
						},
					},
				},
			}
		)
	end,
}
