local M = {}

M.type = "dark"

-- Ayaka theme
-- background: #000000
-- foreground: #cedaeb
-- color1 (Blue in kitty): #71ADE9 -> Using as Blue
-- color2 (Purple in kitty): #AB8CAE -> Using as Keyword/Purple
-- color3 (Pink in kitty): #E59DB1 -> Using as Red/Warning
-- color4 (Periwinkle in kitty): #9EA0D3 -> Using as Green/String
-- color5 (Light Blue in kitty): #8BB8E9 -> Using as Cyan
-- color6 (Light Pink in kitty): #E1B4CE -> Using as Orange

M.base_16 = {
	base00 = "#000000", -- Default Background
	base01 = "#151018", -- Lighter Background (Status bars)
	base02 = "#2a2030", -- Selection Background (Visual Mode)
	base03 = "#60486d", -- Comments, Line Highlighting
	base04 = "#9098a4", -- Dark Foreground, Status bars
	base05 = "#cedaeb", -- Default Foreground
	base06 = "#e1eaff", -- Light Foreground
	base07 = "#ffffff", -- Lightest Foreground
	base08 = "#E59DB1", -- Variables, Errors (Pink)
	base09 = "#E1B4CE", -- Integers, Constants (Light Pink)
	base0A = "#AB8CAE", -- Classes, Search Text (Purple)
	base0B = "#9EA0D3", -- Strings (Periwinkle/Blue-ish)
	base0C = "#8BB8E9", -- Constructor, Regex (Light Blue)
	base0D = "#71ADE9", -- Functions, Methods (Sky Blue)
	base0E = "#AB8CAE", -- Keywords (Purple)
	base0F = "#E59DB1", -- Delimiters (Pink)
}

M.base_30 = {
	white = "#cedaeb",
	black = "#000000",
	darker_black = "#000000",
	black2 = "#151018", -- UI Elements
	one_bg = "#151018", -- Pmenu bg
	one_bg2 = "#1f1824", -- Lighter UI
	one_bg3 = "#2a2030", -- Borders
	grey = "#9098a4",
	grey_fg = "#9098a4",
	grey_fg2 = "#aab2bd",
	light_grey = "#cedaeb",
	line = "#2a2030", -- Split lines
	statusline_bg = "#151018",
	lightbg = "#1f1824",
	pmenu_bg = "#151018",
	folder_bg = "#8BB8E9", -- Blue for folders

	red = "#E59DB1", -- Pink
	pink = "#E59DB1", -- Pink
	baby_pink = "#E1B4CE", -- Light Pink
	orange = "#E1B4CE", -- Light Pink as Orange
	yellow = "#AB8CAE", -- Purple as Yellow (Theme aesthetic)
	green = "#9EA0D3", -- Periwinkle as Green
	vibrant_green = "#9EA0D3",
	blue = "#71ADE9", -- Sky Blue
	nord_blue = "#8BB8E9",
	teal = "#8BB8E9", -- Light Blue
	cyan = "#8BB8E9",
	purple = "#AB8CAE", -- Purple
	dark_purple = "#60486d",
	sun = "#E1B4CE",
}

M.polish_hl = {
	defaults = {
		Normal = { bg = M.base_16.base00 },
		Cursor = { bg = "#cedaeb", fg = "#000000" },
		Visual = { bg = "#2a2030" },
	},

	syntax = {
		Comment = { fg = "#60486d", italic = true },
		String = { fg = M.base_16.base0B },
		Function = { fg = M.base_16.base0D, bold = true },
		Keyword = { fg = M.base_16.base0E, italic = true },
		Statement = { fg = M.base_16.base0E },
		Type = { fg = M.base_16.base0A },
		MatchParen = { fg = M.base_30.blue, underline = true },
		Pmenu = { bg = M.base_30.one_bg },
		PmenuSel = { bg = M.base_30.blue, fg = M.base_30.black, bold = true },
	},

	treesitter = {
		["@operator"] = { fg = M.base_16.base05, bold = true },
		["@variable"] = { fg = M.base_16.base05 },
		["@variable.builtin"] = { fg = M.base_16.base08 },
		["@tag.attribute"] = { fg = M.base_16.base08, italic = false },
	},
}

M = require("base46").override_theme(M, "ayaka")

return M
