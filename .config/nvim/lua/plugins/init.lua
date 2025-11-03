return {
	-- Java
	{
		"oclay1st/gradle.nvim",
		cmd = { "Gradle", "GradleExec", "GradleInit", "GradleFavorites" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "<leader>G", desc = "+Gradle", mode = { "n", "v" } },
			{ "<leader>Gg", "<cmd>Gradle<cr>", desc = "Gradle Projects" },
			{ "<leader>Gf", "<cmd>GradleFavorites<cr>", desc = "Gradle Favorite Commands" },
		},
	},

	{
		"oclay1st/maven.nvim",
		cmd = { "Maven", "MavenInit", "MavenExec", "MavenFavorites" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "<leader>M", desc = "+Maven", mode = { "n", "v" } },
			{ "<leader>Mm", "<cmd>Maven<cr>", desc = "Maven Projects" },
			{ "<leader>Mf", "<cmd>MavenFavorites<cr>", desc = "Maven Favorite Commands" },
		},
	},

	{
		"mfussenegger/nvim-jdtls",
		lazy = true,
		ft = {
			"java",
		},
	},
	--

	{ "b0o/schemastore.nvim" },

	{
		"ccaglak/namespace.nvim",
		enabled = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	{ "jiaoshijie/undotree" },

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
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = function()
			local fzf = require("fzf-lua")
			local actions = fzf.actions

			fzf.register_ui_select()

			return {
				"ivy",
				winopts = {
					fullscreen = true,
				},
				fzf_colors = true,
				keymap = {
					builtin = {
						true,
						["<C-u>"] = "preview-page-up",
						["<C-d>"] = "preview-page-down",
					},
					fzf = {
						true,
						["ctrl-u"] = "preview-page-up",
						["ctrl-d"] = "preview-page-down",
						["ctrl-q"] = "select-all+accept",
					},
				},
				actions = {
					files = {
						["enter"] = actions.file_edit_or_qf,
						["ctrl-x"] = actions.file_split,
						["ctrl-v"] = actions.file_vsplit,
						["ctrl-t"] = actions.file_tabedit,
						["alt-q"] = actions.file_sel_to_qf,
					},
				},
				buffers = {
					keymap = {
						builtin = {
							["<C-d>"] = false,
						},
					},
					actions = {
						files = {
							["ctrl-x"] = false,
							["ctrl-d"] = {
								actions.buf_del,
								actions.rename,
							},
						},
					},
				},
				default = {
					git_icons = false,
				},
				lsp = {
					code_actions = {
						prompt = "Code Actions> ",
						async_or_timeout = 5000,
						previewer = "codeaction",
					},
				},
			}
		end,
	},
}
