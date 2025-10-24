---@type ChadrcConfig
return {
	base46 = {
		theme = "kanagawa-dragon",
		transparency = true,
		hl_override = {
			WinSeparator = { bg = nil },
			CursorLine = { bg = "base00" },
		},
	},
	lsp = {
		signature = true,
	},
	ui = {
		tabufline = {
			modules = {
				btns = function()
					return ""
				end,
			},
		},
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
