---@type ChadrcConfig
return {
	base46 = {
		theme = "kanagawa-dragon",
		theme_toggle = { "kanagawa-dragon", "one_light" },
		transparency = true,
		hl_override = {
			["CursorLine"] = { bg = "base00" },
		},
	},
	lsp = {
		signature = true,
	},
	ui = {
		statusline = {
			theme = "vscode",
			separator_style = "default",
		},
		cmp = {
			style = "default",
			icons_left = true,
			format_colors = {
				lsp = true,
			},
		},
	},
	nvdash = {
		load_on_startup = false,
	},
}
