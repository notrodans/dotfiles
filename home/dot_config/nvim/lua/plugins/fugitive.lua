return {
	"tpope/vim-fugitive",
	cmd = {
		"Git",
		"Gdiffsplit",
		"Gvdiffsplit",
	},
	keys = {
		{
			"<leader>gs",
			"<cmd>Git<CR>",
			desc = "Git status",
		},
		{
			"<leader>gd",
			"<cmd>Gdiffsplit<CR>",
			desc = "Git diff current file",
		},
		{
			"<leader>gD",
			"<cmd>Git diff<CR>",
			desc = "Git diff repository",
		},
		{
			"]h",
			"]c",
			remap = true,
			desc = "Git next hunk",
		},
		{
			"[h",
			"[c",
			remap = true,
			desc = "Git previous hunk",
		},
	},
}
