---@type ChadrcConfig
return {
	base46 = {
		theme = "kanagawa-dragon",
		theme_toggle = { "kanagawa-dragon", "one_light" },
		transparency = true,
		hl_add = {
			["colorcolumn"] = { bg = "#1c1c1c" },
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
		load_on_startup = true,
		header = {
			[[_       _______________________ _______ ______ _______ _          _______]],
			[[( (    /(  ___  \__   __(  ____ (  ___  (  __  \(  ___  ( (    /(  ____ \]],
			[[|  \  ( | (   ) |  ) (  | (    )| (   ) | (  \  | (   ) |  \  ( | (    \/]],
			[[|   \ | | |   | |  | |  | (____)| |   | | |   ) | (___) |   \ | | (_____ ]],
			[[| (\ \) | |   | |  | |  |     __| |   | | |   | |  ___  | (\ \) (_____  )]],
			[[| | \   | |   | |  | |  | (\ (  | |   | | |   ) | (   ) | | \   |     ) |]],
			[[| )  \  | (___) |  | |  | ) \ \_| (___) | (__/  | )   ( | )  \  /\____) |]],
			[[|/    )_(_______)  )_(  |/   \__(_______(______/|/     \|/    )_\_______)]],
			[[                                                                         ]],
		},
	},
}
