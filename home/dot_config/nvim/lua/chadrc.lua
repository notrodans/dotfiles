---@type ChadrcConfig
return {
	base46 = {
		---@diagnostic disable-next-line: assign-type-mismatch <my theme>
		theme = "monochrome",
		transparency = true,
	},
	lsp = {
		signature = false,
	},
	ui = {
		tabufline = {
			order = { "buffers", "tabs" },
			modules = {
				buffers = function()
					return require("modules.tabufline").buffers()
				end,
			},
		},
		statusline = {
			enabled = false,
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
