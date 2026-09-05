local M = {}

local function theme_names()
	local seen = {}
	local themes = {}

	local paths = vim.fn.globpath(vim.o.runtimepath, "lua/base46/themes/*.lua", false, true)
	vim.list_extend(paths, vim.fn.globpath(vim.fn.stdpath("config"), "lua/themes/*.lua", false, true))

	for _, path in ipairs(paths) do
		local name = vim.fn.fnamemodify(path, ":t:r")

		if name ~= "" and not seen[name] then
			seen[name] = true
			themes[#themes + 1] = name
		end
	end

	table.sort(themes)

	return themes
end

function M.open()
	local config = require("nvconfig").base46

	vim.ui.select(theme_names(), {
		prompt = "Base46 theme",
		format_item = function(theme)
			if theme == config.theme then
				return theme .. " (current)"
			end

			return theme
		end,
	}, function(theme)
		if not theme or theme == config.theme then
			return
		end

		config.theme = theme
		require("base46").load_all_highlights()
		vim.cmd.redraw()
	end)
end

return M
