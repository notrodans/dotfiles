return {
	"stevearc/resession.nvim",
	keys = {
		{
			"<leader>ws",
			function()
				require("modules.workspace").save()
			end,
			desc = "Workspace save",
		},
		{
			"<leader>wl",
			function()
				require("modules.workspace").load()
			end,
			desc = "Workspace load",
		},
		{
			"<leader>wd",
			function()
				require("modules.workspace").delete()
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
