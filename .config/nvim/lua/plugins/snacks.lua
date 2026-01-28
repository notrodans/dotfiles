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
							packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools" },
						},
					},
					convert = {
						notify = false,
						magick = {
							math = {
								"-density",
								"600",
								"{src}[{page}]",
								"-background",
								"transparent",
								"-alpha",
								"remove",
								"-trim",
								"-bordercolor",
								"transparent",
								"-border",
								"50x50",
								"+repage",
								"-scale",
								"150%",
							},
						},
					},
					resolve = function(path, src)
						local api = require("obsidian.api")
						if api.path_is_note(path) then
							return api.resolve_attachment_path(src)
						end
					end,
				},
			}
		)
	end,
}
