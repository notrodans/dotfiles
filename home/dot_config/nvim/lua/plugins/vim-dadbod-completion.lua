return {
	{
		"kristijanhusak/vim-dadbod-completion",
		lazy = true,
	},
	{
		"saghen/blink.cmp",
		opts = {
			sources = {
				per_filetype = {
					sql = { "snippets", "dadbod", "buffer" },
					mysql = { "snippets", "dadbod", "buffer" },
					plsql = { "snippets", "dadbod", "buffer" },
				},
				providers = {
					dadbod = {
						name = "Dadbod",
						module = "vim_dadbod_completion.blink",
					},
				},
			},
		},
	},
}
