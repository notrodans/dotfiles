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

local function persist_theme(theme)
	local path = vim.fn.stdpath("config") .. "/lua/nvconfig.lua"
	local file, open_error = io.open(path, "r")

	if not file then
		return nil, open_error or ("failed to open " .. path)
	end

	local content = file:read("*a")
	file:close()

	local updated, replacements = content:gsub('(theme%s*=%s*)["\'][^"\']+["\']', '%1"' .. theme .. '"', 1)

	if replacements == 0 then
		return nil, "base46 theme field not found in " .. path
	end

	file, open_error = io.open(path, "w")
	if not file then
		return nil, open_error or ("failed to open " .. path .. " for writing")
	end

	local ok, write_error = file:write(updated)
	file:close()

	if not ok then
		return nil, write_error or ("failed to write " .. path)
	end

	return true
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

		local persisted, persist_error = persist_theme(theme)
		if not persisted then
			vim.notify("Failed to persist Base46 theme: " .. persist_error, vim.log.levels.ERROR)
			return
		end

		config.theme = theme
		require("modules.base46_cache").rebuild()
		vim.cmd.redraw()
	end)
end

return M
