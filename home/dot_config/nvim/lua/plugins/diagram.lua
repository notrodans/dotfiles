return {
	"3rd/diagram.nvim",
	lazy = true,
	ft = "markdown",
	dependencies = {
		{ "3rd/image.nvim", opts = {} }, -- you'd probably want to configure image.nvim manually instead of doing this
	},
	opts = {
		events = {
			render_buffer = {}, -- Empty = no automatic rendering
			clear_buffer = { "BufLeave" },
		},
		renderer_options = {
			mermaid = {
				scale = 2,
				max_width = 3000,
				max_height = 800,
				cli_args = { "--no-sandbox" },
			},
		},
	},
	keys = {
		{
			"K", -- or any key you prefer
			function()
				require("diagram").show_diagram_hover()
			end,
			mode = "n",
			ft = { "markdown", "norg" }, -- Only in these filetypes
			desc = "Show diagram in new tab",
		},
	},
}
