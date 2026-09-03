local api = vim.api

local M = {}

local function oil()
	return require("oil")
end

local function resize_width(winid, width)
	if api.nvim_win_resize then
		pcall(api.nvim_win_resize, winid, width, -1, { anchor = "right" })
		return
	end

	pcall(api.nvim_win_set_width, winid, width)
end

local function restore_selection(winid, name)
	if not name or not api.nvim_win_is_valid(winid) then
		return
	end

	local bufnr = api.nvim_win_get_buf(winid)

	for lnum = 1, api.nvim_buf_line_count(bufnr) do
		local entry = oil().get_entry_on_line(bufnr, lnum)

		if entry and entry.name == name then
			api.nvim_win_set_cursor(winid, { lnum, 0 })
			return
		end
	end
end

local function restore_view(winid, state)
	if not api.nvim_win_is_valid(winid) then
		return
	end

	api.nvim_win_call(winid, function()
		restore_selection(winid, state.selected)

		if state.view then
			local view = vim.fn.winsaveview()

			for _, key in ipairs({
				"col",
				"coladd",
				"curswant",
				"leftcol",
				"skipcol",
				"topfill",
				"topline",
			}) do
				if state.view[key] ~= nil then
					view[key] = state.view[key]
				end
			end

			vim.fn.winrestview(view)
		end
	end)

	if state.width then
		resize_width(winid, state.width)
	end
end

M.is_win_supported = function(_, bufnr)
	return vim.bo[bufnr].filetype == "oil"
end

M.save_win = function(winid)
	local bufnr = api.nvim_win_get_buf(winid)
	local selected
	local view

	api.nvim_win_call(winid, function()
		local entry = oil().get_cursor_entry()

		selected = entry and entry.name or nil
		view = vim.fn.winsaveview()
	end)

	return {
		directory = oil().get_current_dir(bufnr),
		selected = selected,
		sidebar = vim.w[winid].oil_sidebar == true,
		view = view,
		width = api.nvim_win_get_width(winid),
	}
end

M.load_win = function(winid, state)
	api.nvim_set_current_win(winid)

	local directory = state.directory or vim.fn.getcwd(-1, -1)

	if state.sidebar then
		vim.w[winid].oil_sidebar = true
	end

	oil().open(directory, {}, function()
		restore_view(winid, state)
	end)

	return winid
end

return M
