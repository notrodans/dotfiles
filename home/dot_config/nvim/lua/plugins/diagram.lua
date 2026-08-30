return {
	"notrodans/diagram.nvim",
	branch = "fix/security-cache-modernization",
	dependencies = {
		{ "3rd/image.nvim", opts = {} },
	},
	config = function()
		require("diagram").setup({
			events = {
				render_buffer = {},
				clear_buffer = { "BufLeave" },
			},
			renderer_options = {
				mermaid = {
					theme = "neutral",
					scale = 8,
				},
			},
		})
	end,
	keys = {
		{
			"K",
			function()
				require("diagram").show_diagram_hover()
			end,
			mode = "n",
			ft = { "markdown", "norg" },
			desc = "Show diagram in new tab",
		},
	},
}
