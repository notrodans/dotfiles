local M = {}

M.type = "dark"

M.base_16 = {
	base00 = "#000000",
	base01 = "#333333",
	base02 = "#ffffff",
	base03 = "#888888",
	base04 = "#999999",
	base05 = "#ffffff",
	base06 = "#c1c1c1",
	base07 = "#c1c1c1",
	base08 = "#dd9999",
	base09 = "#a06666",
	base0A = "#a06666",
	base0B = "#5f8787",
	base0C = "#5f8787",
	base0D = "#888888",
	base0E = "#999999",
	base0F = "#aaaaaa",
}

M.base_30 = {
	white = "#ffffff",
	black = "#000000",
	darker_black = "#000000",
	black2 = "#333333",
	one_bg = "#333333",
	one_bg2 = "#333333",
	one_bg3 = "#333333",
	grey = "#888888",
	grey_fg = "#999999",
	light_grey = "#aaaaaa",
	line = "#333333",
	statusline_bg = "#000000",
	lightbg = "#333333",
	pmenu_bg = "#ffffff",
	folder_bg = "#888888",

	red = "#dd9999",
	green = "#5f8787",
	blue = "#888888",
	yellow = "#a06666",
	purple = "#999999",
	orange = "#a06666",
	cyan = "#5f8787",
	pink = "#dd9999",

	grey_fg2 = "#999999",
	baby_pink = "#dd9999",
	vibrant_green = "#5f8787",
	nord_blue = "#888888",
	sun = "#a06666",
	dark_purple = "#999999",
	teal = "#5f8787",
}

M.polish_hl = {
	defaults = {
		NonText = { fg = M.base_30.black2 },
		Whitespace = { fg = M.base_30.black2 },
	},

	syntax = {
		Delimiter = { fg = M.base_30.grey_fg, bold = true },
		MatchParen = { fg = M.base_30.white, underline = true },
		Pmenu = { fg = M.base_30.grey_fg, bg = M.base_30.one_bg },
		PmenuSel = { fg = M.base_16.base06, bg = M.base_30.black, underline = true, bold = true },
		Visual = { fg = M.base_30.blue, bg = M.base_30.one_bg },
		VisualNOS = { fg = M.base_30.blue, bg = M.base_30.one_bg },
	},

	treesitter = {
		["@operator"] = { fg = M.base_30.grey_fg, bold = true },
		["@function"] = { fg = M.base_30.yellow },
	},
}

M.add_hl = {}

M = require("base46").override_theme(M, "blackmetal")

return M
