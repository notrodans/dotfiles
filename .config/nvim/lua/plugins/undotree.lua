return {
	"jiaoshijie/undotree",
	keys = {
		{
			"<leader>u",
			"<cmd>lua require('undotree').toggle()<CR>",
			desc = "undotree toggle window",
			mode = { "n", "v" },
		},
	},
}
