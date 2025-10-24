---@type ChadrcConfig
return {
	base46 = {
		theme = "kanagawa-dragon",
		transparency = true,
		hl_override = {
			["CursorLine"] = { bg = "base00" },
		},
		theme_toggle = nil,
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
