return {
	"stevearc/resession.nvim",
	keys = {
		{
			"<leader>ws",
			function()
				require("resession").save()
			end,
			desc = "Workspace save",
		},
		{
			"<leader>wl",
			function()
				require("resession").load()
			end,
			desc = "Workspace load",
		},
		{
			"<leader>wd",
			function()
				require("resession").delete()
			end,
			desc = "Workspace delete",
		},
	},
	opts = {
		dir = "workspace",
		load_detail = true,
		load_order = "modification_time",
		autosave = {
			enabled = true,
			interval = 60,
			notify = false,
		},
		extensions = {
			nvimtree = {},
			tabufline = {
				enable_in_tab = true,
			},
		},
	},
}
