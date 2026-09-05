return {
	base46 = {
		theme = "monochrome",
		hl_add = {},
		hl_override = {
			["@comment"] = { italic = true },
			["@keyword"] = { italic = true },
			["@function"] = { bold = true },
			["@function.method"] = { bold = true },
			["@type"] = { bold = true },
			["@variable.parameter"] = { italic = true },
			["@lsp.type.parameter"] = { italic = true },
			["@lsp.type.typeParameter"] = {
				bold = true,
				italic = true,
			},
		},
		integrations_dir = nil,
		integrations = {},
		changed_themes = {},
		transparency = true,
		theme_toggle = { "onedark", "one_light" },
	},

	ui = {
		cmp = {
			icons_left = true,
			style = "default",
			abbr_maxwidth = 60,
			format_colors = {
				lsp = true,
				icon = "󱓻 ",
			},
		},

		telescope = {
			style = "borderless",
		},

		statusline = {
			enabled = false,
			theme = "vscode",
			separator_style = "default",
			order = nil,
			modules = nil,
		},

		tabufline = {
			enabled = true,
			lazyload = true,
			treeOffsetFt = "NvimTree",
			order = { "buffers", "tabs" },
			bufwidth = 21,
		},
	},

	term = {
		startinsert = false,
		base46_colors = true,
		winopts = {
			number = false,
			relativenumber = false,
		},
		sizes = {
			sp = 0.3,
			vsp = 0.2,
			["bo sp"] = 0.3,
			["bo vsp"] = 0.2,
		},
		float = {
			relative = "editor",
			row = 0.3,
			col = 0.25,
			width = 0.5,
			height = 0.4,
			border = "single",
		},
	},

	lsp = {
		signature = false,
	},
}
