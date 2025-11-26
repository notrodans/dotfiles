return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		auto_install = true,
		indent = {
			enable = true,
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = {
						query = "@function.outer",
						desc = "Select outer part of a function definition",
					},
					["if"] = {
						query = "@function.inner",
						desc = "Select inner part of a function definition",
					},
					["ac"] = {
						query = "@class.outer",
						desc = "Select outer part of a type",
					},
					["ic"] = {
						query = "@class.inner",
						desc = "Select inner part of a type",
					},
					["ap"] = {
						query = "@parameter.outer",
						desc = "Select outer part of a parameter",
					},
					["ip"] = {
						query = "@parameter.inner",
						desc = "Select inner part of a parameter",
					},
				},
			},
		},
	},
}
