---@class Base46Table
local M = {}

M.type = "dark"

---@class Base16Table
M.base_16 = {
	base00 = "#000000",
	base01 = "#151018",
	base02 = "#2a2030",
	base03 = "#60486d",
	base04 = "#9098a4",
	base05 = "#cedaeb",
	base06 = "#e1eaff",
	base07 = "#ffffff",
	base08 = "#e59db1",
	base09 = "#e1b4ce",
	base0A = "#ab8cae",
	base0B = "#9ea0d3",
	base0C = "#8bb8e9",
	base0D = "#71ade9",
	base0E = "#ab8cae",
	base0F = "#e59db1",
}

---@class Base30Table
M.base_30 = {
	white = "#cedaeb",
	black = "#000000",
	darker_black = "#000000",
	black2 = "#151018",
	one_bg = "#151018",
	one_bg2 = "#1f1824",
	one_bg3 = "#2a2030",
	grey = "#9098a4",
	grey_fg = "#9098a4",
	light_grey = "#cedaeb",
	line = "#2a2030",
	statusline_bg = "#151018",
	lightbg = "#1f1824",
	pmenu_bg = "#151018",
	folder_bg = "#8bb8e9",

	red = "#e59db1",
	green = "#9ea0d3",
	blue = "#71ade9",
	yellow = "#ab8cae",
	purple = "#ab8cae",
	orange = "#e1b4ce",
	cyan = "#8bb8e9",
	pink = "#e59db1",

	grey_fg2 = "#aab2bd",
	baby_pink = "#e1b4ce",
	vibrant_green = "#9ea0d3",
	nord_blue = "#8bb8e9",
	sun = "#e1b4ce",
	dark_purple = "#60486d",
	teal = "#8bb8e9",
}

M.polish_hl = {
	syntax = {
		Comment = { fg = M.base_16.base03, italic = true },
		String = { fg = M.base_16.base0B },
		Function = { fg = M.base_16.base0D, bold = true },
		Keyword = { fg = M.base_16.base0E, italic = true },
		Statement = { fg = M.base_16.base0E },
		Type = { fg = M.base_16.base0A },
		MatchParen = { fg = M.base_30.blue, underline = true },
		Pmenu = { bg = M.base_30.one_bg },
		PmenuSel = { bg = M.base_30.blue, fg = M.base_30.black, bold = true },
		St_Mode = { bg = M.base_30.one_bg, fg = M.base_16.base02, bold = true },
	},

	treesitter = {
		["@operator"] = { fg = M.base_16.base05, bold = true },
		["@variable"] = { fg = M.base_16.base05 },
		["@variable.builtin"] = { fg = M.base_16.base08 },
		["@tag.attribute"] = { fg = M.base_16.base08, italic = false },
	},
}

M.add_hl = {}

M = require("base46").override_theme(M, "ayaka")

return M
