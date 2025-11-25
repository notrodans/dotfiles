return {
	"jiaoshijie/undotree",
	keys = {
		{
			"<C-,>",
			"<cmd>lua require('undotree').toggle()<CR>",
			desc = "undotree toggle window",
			mode = { "n", "v" },
		},
	},
}
