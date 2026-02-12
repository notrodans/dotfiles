return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
	build = ":TSUpdate | TSInstallAll",
	opts = function()
		local opts = require("nvchad.configs.treesitter")
		opts.textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["ap"] = "@parameter.outer",
					["ip"] = "@parameter.inner",
				},
			},
		}
		return opts
	end,
	config = function(_, opts)
		require("nvim-treesitter").setup(opts)
	end,
}
