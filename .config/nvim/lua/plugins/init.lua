return {
	{ "b0o/schemastore.nvim" },
	{
		"ccaglak/namespace.nvim",
		enabled = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"mfussenegger/nvim-jdtls",
		lazy = true,
		ft = {
			"java",
		},
	},

	{ "jiaoshijie/undotree", lazy = false },

	{
		"OXY2DEV/markview.nvim",
		lazy = false,
	},

	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		opts = function()
			return require("configs.nvimtree")
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = function()
			require("configs.conform")
		end,
	},

	{
		"mfussenegger/nvim-lint",
		event = { "BufWritePre", "BufNewFile" },
		config = function()
			require("configs.lint")
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = true,
				},
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		event = "User FilePost",
		config = function()
			require("configs.lspconfig")
		end,
	},

	{ import = "nvchad.blink.lazyspec" },

	{
		"Saghen/blink.cmp",
		opts = {},
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = false,
		config = function()
			require("todo-comments").setup()
		end,
	},

	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				move_cursor = false,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate",
		opts = {
			auto_install = true,
			indent = {
				enable = true,
			},
		},
		autotag = {
			enable = true,
		},
	},

	{
		"hrsh7th/nvim-cmp",
		enabled = false,
	},

	{
		"ibhagwan/fzf-lua",
		lazy = true,
		opts = {
			fzf_opts = {
				["--layout"] = "default",
			},
			winopts = {},
		},
	},
}
