--              AstroNvim Configuration Table
-- All configuration changes should go inside of the table below

-- You can think of a Lua "table" as a dictionary like data structure the
-- normal format is "key = value". These also handle array like data structures
-- where a value with no key simply has an implicit numeric key

local config = {
	updater = {
		remote = "origin", -- remote to use
		channel = "latest", -- "stable" or "nightly"
		version = "v3.5.1", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
		branch = "main", -- branch name (NIGHTLY ONLY)
		commit = nil, -- commit hash (NIGHTLY ONLY)
		pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
		skip_prompts = false, -- skip prompts about breaking changes
		show_changelog = true, -- show the changelog after performing an update
		auto_quit = false, -- automatically quit the current session after a successful update
		-- remotes = { -- easily add new remotes to track
		--   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
		--   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
		--   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
		-- },
	},
	-- Set colorscheme to use
	colorscheme = "rose-pine",
	-- Add highlight groups in any theme
	highlights = {
		-- init = { -- this table overrides highlights in all themes
		-- Normal = { bg = NONE },
		-- },
		-- duskfox = { -- a table of overrides/changes to the duskfox theme
		--   Normal = { bg = "#000000" },
		-- },
	},
	-- set vim options here (vim.<first_key>.<second_key> = value)

	options = {
		opt = {
			swapfile = false,
			relativenumber = true,
			signcolumn = "yes",
			cmdheight = 1,
			completeopt = { "menu", "menuone", "noselect" },
			clipboard = "unnamedplus",
			background = "dark",
			smartindent = false,
			expandtab = false,
			tabstop = 4,
			shiftwidth = 0,
			softtabstop = 0,
			smarttab = true,
			guicursor = "n-v-c:block",
		},
		g = {
			mapleader = " ", -- sets vim.g.mapleader
			autoformat_enabled = false, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
			cmp_enabled = true, -- enable completion at start
			autopairs_enabled = true, -- enable autopairs at start
			diagnostics_enabled = true, -- enable diagnostics at start
			icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
			ui_notifications_enabled = false, -- disable notifications when toggling UI elements
		},
	},
	-- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
	diagnostics = {
		virtual_text = true,
		underline = true,
		signs = false,
		update_in_insert = true,
	},
	-- Extend LSP configuration
	lsp = {
		-- enable servers that you already have installed without mason
		servers = {
			"tsserver",
		},
		formatting = {
			format_on_save = {
				enabled = false,
				allow_filetypes = {
					-- "go",
				},
				ignore_filetypes = {
					-- "python"
				},
			},
			disabled = {
				"jsonls",
				"html",
				"tsserver",
				"lua_ls",
			},
			async = true,
		},
		setup_handlers = {
			tsserver = function(_, opts)
				require("typescript").setup({ server = opts })
			end,
		},
		-- easily add or disable built in mappings added during LSP attaching
		mappings = {
			n = {
				["[d"] = false,
				["]d"] = false,
				["gl"] = false,
			},
		},
		config = {
			cssls = {
				-- override table for require("lspconfig").cssls.setup({...})
				settings = {
					css = {
						validate = false,
					},
					less = {
						validate = false,
					},
					scss = {
						validate = false,
					},
				},
			},
		},
	},
	mappings = {
		n = {
			["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
			["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
			["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
			["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
			["<leader>b"] = { name = "Buffers" },
			["<C-f>"] = {
				"<Cmd>Lspsaga lsp_finder<CR>",
				desc = "lspsaga lsp finder",
			},
			["[d"] = {
				"<Cmd>Lspsaga diagnostic_jump_prev<CR>",
				desc = "prev diagnostic line",
			},
			["]d"] = {
				"<Cmd>Lspsaga diagnostic_jump_next<CR>",
				desc = "next diagnostic line",
			},
			["gl"] = {
				"<Cmd>Lspsaga show_line_diagnostics<CR>",
				desc = "diagnostics line",
			},
		},
		t = {},
	},
	lazy = {
		defaults = { lazy = true },
		performance = {
			rtp = {
				-- customize default disabled vim plugins
				disabled_plugins = {
					"tohtml",
					"gzip",
					"matchit",
					"zipPlugin",
					"netrwPlugin",
					"tarPlugin",
					"matchparen",
				},
			},
		},
	},
	-- Configure plugins
	plugins = {
		{ "avneesh0612/react-nextjs-snippets" },
		{
			"onsails/lspkind.nvim",
			config = function()
				require("lspkind").init({
					mode = "symbol_text",
				})
			end,
		},
		{ "mcchrish/zenbones.nvim", dependencies = { "rktjmp/lush.nvim" } },
		{
			"AstroNvim/astrocommunity",
			{ import = "astrocommunity.pack.rust" },
			{ import = "astrocommunity.colorscheme.rose-pine" },
			{ import = "astrocommunity.colorscheme.catppuccin" },
			{ import = "astrocommunity.colorscheme.oxocarbon" },
			{ import = "astrocommunity.colorscheme.tokyonight" },
		},
		{ "jay-babu/mason-nvim-dap.nvim", enabled = false },
		{ "mfussenegger/nvim-dap", enabled = false },
		{ "rcarriga/nvim-dap-ui", enabled = false },
		{ "rcarriga/nvim-notify", enabled = false },
		{
			"rebelot/heirline.nvim",
			opts = function(_, opts)
				opts.winbar = nil
				return opts
			end,
		},
		{
			"nvim-neo-tree/neo-tree.nvim",
			opts = function(_, config)
				config.default_component_configs = {
					indent = { padding = 0, indent_size = 2 },
				}
				return config
			end,
		},
		{
			"andweeb/presence.nvim",
			event = { "BufNewFile", "BufRead", "BufAdd" },
			config = function()
				require("presence"):setup({
					neovim_image_text = "Лучше чем твоё говно",
					editing_text = "Строчу %s",
					file_explorer_text = "Чекаю %s",
					git_commit_text = "Пошёл в гит",
					plugin_manager_text = "Плагиныыы",
					reading_text = "Задрочу %s",
					workspace_text = "Воркаю %s",
					line_number_text = "Line %s out of %s",
				})
			end,
		},
		{ "lukas-reineke/indent-blankline.nvim", enabled = false },
		{
			"windwp/nvim-ts-autotag",
		},
		{
			"folke/todo-comments.nvim",
			lazy = false,
			config = function()
				require("todo-comments").setup({})
			end,
		},
		{
			"glepnir/lspsaga.nvim",
			event = "BufRead",
			config = function()
				require("lspsaga").setup({
					symbol_in_winbar = {
						enable = false,
					},
					ui = {
						winblend = 10,
						border = "rounded",
						colors = {
							normal_bg = "#002b36",
						},
					},
				})
			end,
		},
		{
			"L3MON4D3/LuaSnip",
			config = function(plugin, opts)
				require("plugins.configs.luasnip")(plugin, opts) -- include the default astronvim config that calls the setup call
				local luasnip = require("luasnip")
				luasnip.filetype_extend("javascript", { "javascriptreact" })
				require("luasnip.loaders.from_vscode").load({ paths = { "./lua/user/snippets" } })
			end,
		},
		{
			"folke/which-key.nvim",
			config = function()
				vim.o.timeoutlen = 300
				local wk = require("which-key")
				wk.register({
					b = { name = "Buffer" },
				}, { mode = "n", prefix = "<leader>" })
			end,
		},
		{
			"goolord/alpha-nvim",
			opts = function(_, opts)
				opts.section.header.val = {
					" █████  ███████ ████████ ██████   ██████",
					"██   ██ ██         ██    ██   ██ ██    ██",
					"███████ ███████    ██    ██████  ██    ██",
					"██   ██      ██    ██    ██   ██ ██    ██",
					"██   ██ ███████    ██    ██   ██  ██████",
					" ",
					"    ███    ██ ██    ██ ██ ███    ███",
					"    ████   ██ ██    ██ ██ ████  ████",
					"    ██ ██  ██ ██    ██ ██ ██ ████ ██",
					"    ██  ██ ██  ██  ██  ██ ██  ██  ██",
					"    ██   ████   ████   ██ ██      ██",
				}
				return opts
			end,
		},
		"jose-elias-alvarez/typescript.nvim",
		{
			"jose-elias-alvarez/null-ls.nvim",
			opts = function(_, config)
				local null_ls = require("null-ls")
				config.sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.eslint_d,
					null_ls.builtins.formatting.stylelint,
					null_ls.builtins.formatting.prettierd.with({
						filetypes = {
							"javascriptreact",
							"javascript",
							"typescriptreact",
							"typescript",
							"html",
							"json",
						},
					}),
					null_ls.builtins.diagnostics.stylelint,
					null_ls.builtins.diagnostics.eslint_d,
					require("typescript.extensions.null-ls.code-actions"),
				}
				return config
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			opts = {
				auto_install = true,
				ensure_installed = {
					"tsx",
					"javascript",
					"typescript",
					"scss",
					"css",
					"html",
					"json",
					"lua",
				},
			},
		},
		{
			"williamboman/mason-lspconfig.nvim",
			opts = {
				ensure_installed = {
					"tsserver",
					"lua_ls",
					"html",
					"cssls",
					"jsonls",
					"emmet_ls",
					"lemminx",
					"tailwindcss",
					"cssmodules_ls",
				},
			},
		},
		{
			"jay-babu/mason-null-ls.nvim",
			opts = {
				ensure_installed = {
					"eslint_d",
					"prettierd",
					"xmlformatter",
					"stylua",
				},
				automatic_setup = false,
			},
		},
		{
			"hrsh7th/nvim-cmp",
			opts = function(_, config)
				local cmp = require("cmp")
				local luasnip = require("luasnip")
				config.duplicates = {
					nvim_lsp = 1,
					luasnip = 1,
					cmp_tabnine = 1,
					buffer = 1,
					path = 1,
				}
				config.mapping = {
					["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
					["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
					["<C-y>"] = cmp.config.disable,
					["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}
			end,
		},
	},
}

return config
