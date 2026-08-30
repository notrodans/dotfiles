return {
	"saghen/blink.cmp",

	version = "1.*",

	event = {
		"InsertEnter",
		"CmdLineEnter",
	},

	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			dependencies = {
				"rafamadriz/friendly-snippets",
			},
			opts = {
				history = true,
				updateevents = "TextChanged,TextChangedI",
			},
			config = function(_, opts)
				require("luasnip").config.set_config(opts)
				require("nvchad.configs.luasnip")
			end,
		},

		{
			"windwp/nvim-autopairs",
			opts = {
				fast_wrap = {},
				disable_filetype = {
					"vim",
				},
			},
		},
	},

	opts = {
		keymap = {
			preset = "enter",

			["<C-p>"] = {
				"select_prev",
				"fallback",
			},

			["<C-n>"] = {
				"select_next",
				"fallback",
			},

			["<C-d>"] = {
				"scroll_documentation_up",
				"fallback",
			},

			["<C-f>"] = {
				"scroll_documentation_down",
				"fallback",
			},

			["<C-space>"] = {
				"show",
				"show_documentation",
				"hide_documentation",
			},

			["<C-e>"] = {
				"hide",
				"fallback",
			},

			["<Tab>"] = {
				"fallback",
			},

			["<S-Tab>"] = {
				"fallback",
			},
		},

		completion = {
			menu = {
				auto_show = false,
			},
			documentation = {
				auto_show = false,
				auto_show_delay_ms = 0,
			},
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		snippets = {
			preset = "luasnip",
		},

		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
			},
		},
	},

	opts_extend = {
		"sources.default",
	},

	config = function(_, opts)
		-- Load NvChad/Base46 Blink highlight groups before Blink initializes.
		dofile(vim.g.base46_cache .. "blink")

		require("blink.cmp").setup(opts)
	end,
}
