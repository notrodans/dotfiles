return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	config = function()
		require("snacks").setup({
			image = {
				enabled = true,
				resolve = function(path, src)
					local api = require("obsidian.api")
					if api.path_is_note(path) then
						return api.resolve_attachment_path(src)
					end
				end,
			},
		})
	end,
}
