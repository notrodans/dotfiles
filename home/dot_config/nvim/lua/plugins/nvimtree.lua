return {
	"nvim-tree/nvim-tree.lua",
	cmd = { "NvimTreeToggle", "NvimTreeFocus" },
	dependencies = {
		{
			"antosha417/nvim-lsp-file-operations",
			requires = {
				"nvim-lua/plenary.nvim",
			},
			config = function()
				require("lsp-file-operations").setup()
			end,
		},
	},
	opts = function()
		return require("configs.nvimtree")
	end,
}
