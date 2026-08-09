---@type ChadrcConfig
return {
	base46 = {
		---@diagnostic disable-next-line: assign-type-mismatch <my theme>
		theme = "mountain",
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
				treeOffset = function()
					return ""
				end,

				buffers = function()
					return require("modules.tabufline").buffers()
				end,

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
