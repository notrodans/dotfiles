---@type ChadrcConfig
return {
	base46 = {
		---@diagnostic disable-next-line: assign-type-mismatch <my theme>
		theme = "monochrome",
		transparency = true,
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
