local api = vim.api

local M = {}

local sidebar_width = 40
local targets = {}

local function is_oil(bufnr)
	return api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].filetype == "oil"
end

local function sidebar()
	for _, winid in ipairs(api.nvim_tabpage_list_wins(0)) do
		local bufnr = api.nvim_win_get_buf(winid)

		if is_oil(bufnr) and vim.w[winid].oil_sidebar then
			return winid
		end
	end
end

local function target()
	local bufnr = api.nvim_get_current_buf()

	if is_oil(bufnr) then
		return require("oil").get_current_dir(bufnr) or vim.fn.getcwd(-1, -1)
	end

	if vim.bo[bufnr].buftype ~= "" then
		return vim.fn.getcwd(-1, -1)
	end

	local path = api.nvim_buf_get_name(bufnr)

	if path == "" then
		return vim.fn.getcwd(-1, -1)
	end

	local stat = vim.uv.fs_stat(path)

	if stat and stat.type == "directory" then
		return path
	end

	return vim.fs.dirname(path), vim.fs.basename(path)
end

local function restore_view(winid, view)
	vim.schedule(function()
		if not api.nvim_win_is_valid(winid) then
			return
		end

		api.nvim_win_call(winid, function()
			vim.fn.winrestview(view)
		end)
	end)
end

local function select_name(winid, name)
	if not name or not api.nvim_win_is_valid(winid) then
		return
	end

	local bufnr = api.nvim_win_get_buf(winid)
	local oil = require("oil")

	for lnum = 1, api.nvim_buf_line_count(bufnr) do
		local entry = oil.get_entry_on_line(bufnr, lnum)

		if entry and entry.name == name then
			api.nvim_win_set_cursor(winid, { lnum, 0 })
			return
		end
	end
end

local function target_window(sidebar_win)
	local preferred = targets[sidebar_win]

	if preferred
		and api.nvim_win_is_valid(preferred)
		and api.nvim_win_get_tabpage(preferred) == api.nvim_win_get_tabpage(sidebar_win)
	then
		return preferred
	end

	local tabpage = api.nvim_win_get_tabpage(sidebar_win)

	for _, winid in ipairs(api.nvim_tabpage_list_wins(tabpage)) do
		if winid ~= sidebar_win and not is_oil(api.nvim_win_get_buf(winid)) then
			return winid
		end
	end

	for _, winid in ipairs(api.nvim_tabpage_list_wins(tabpage)) do
		if winid ~= sidebar_win then
			return winid
		end
	end
end

local function open_buffer(sidebar_win, bufnr, mode)
	local target_win = target_window(sidebar_win)

	if mode == "tab" then
		vim.cmd.tabnew()
		target_win = api.nvim_get_current_win()
	elseif target_win then
		api.nvim_set_current_win(target_win)

		if mode == "vertical" then
			vim.cmd.vsplit()
			target_win = api.nvim_get_current_win()
		elseif mode == "horizontal" then
			vim.cmd.split()
			target_win = api.nvim_get_current_win()
		end
	end

	if not target_win then
		return
	end

	if mode ~= "tab" then
		targets[sidebar_win] = target_win
	end

	api.nvim_win_set_buf(target_win, bufnr)
	api.nvim_set_current_win(target_win)
end

function M.open()
	local origin_win = api.nvim_get_current_win()
	local origin_view = vim.fn.winsaveview()
	local directory, selected = target()

	vim.cmd("botright " .. sidebar_width .. "vsplit")

	local winid = api.nvim_get_current_win()

	vim.w[winid].oil_sidebar = true
	targets[winid] = origin_win

	require("oil").open(directory, {}, function()
		select_name(winid, selected)
	end)
	api.nvim_win_set_width(winid, sidebar_width)

	restore_view(origin_win, origin_view)

	return winid
end

function M.toggle()
	local winid = sidebar()

	if winid then
		targets[winid] = nil
		api.nvim_win_close(winid, false)
		return
	end

	M.open()
end

function M.select(mode)
	local oil = require("oil")
	local winid = api.nvim_get_current_win()
	local entry = oil.get_cursor_entry()
	local opts = {}

	if mode == "vertical" then
		opts.vertical = true
	elseif mode == "horizontal" then
		opts.horizontal = true
	elseif mode == "tab" then
		opts.tab = true
	end

	if not vim.w[winid].oil_sidebar or (entry and entry.type == "directory") then
		oil.select(opts)
		return
	end

	oil.select({
		handle_buffer_callback = function(bufnr)
			open_buffer(winid, bufnr, mode)
		end,
	})
end

return M
