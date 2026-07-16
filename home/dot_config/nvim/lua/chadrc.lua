---@type ChadrcConfig
return {
	base46 = {
		---@diagnostic disable-next-line: assign-type-mismatch <my theme>
		theme = "blackmetal",
		transparency = false,
		hl_override = {
			CursorLine = { bg = "line" },
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
			enabled = true,
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
