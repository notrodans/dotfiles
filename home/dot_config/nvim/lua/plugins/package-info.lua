return {
	"vuki656/package-info.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	keys = {
		{
			"<leader>ps",
			function()
				require("package-info").show()
			end,
			ft = "json",
			desc = "Display latest package version",
		},
		{
			"<leader>pp",
			function()
				require("package-info").change_version()
			end,
			ft = "json",
			desc = "Install different version",
		},
		{
			"<leader>pu",
			function()
				require("package-info").update()
			end,
			ft = "json",
			desc = "Update package to latest version",
		},
	},
	config = function()
		require("package-info").setup({
			package_manager = vim.g.package_manager or "npm",
		})
	end,
}
