local api = vim.api

local M = {}

local function is_oil(bufnr)
	return api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].filetype == "oil"
end

local function is_blank(bufnr)
	if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].modified or api.nvim_buf_get_name(bufnr) ~= "" then
		return false
	end

	local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)

	return #lines == 1 and lines[1] == ""
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

local function select_name(name)
	if not name then
		return
	end

	local bufnr = api.nvim_get_current_buf()
	local oil = require("oil")

	for lnum = 1, api.nvim_buf_line_count(bufnr) do
		local entry = oil.get_entry_on_line(bufnr, lnum)

		if entry and entry.name == name then
			api.nvim_win_set_cursor(0, { lnum, 0 })
			return
		end
	end
end

function M.open()
	local bufnr = api.nvim_get_current_buf()
	local directory, selected = target()

	vim.w.oil_return_blank = is_blank(bufnr) or nil

	require("oil").open(directory, {}, function()
		select_name(selected)
	end)
end

function M.close()
	if vim.w.oil_return_blank then
		vim.w.oil_return_blank = nil
		vim.cmd.enew()
		return
	end

	require("oil.actions").close.callback()
end

function M.toggle()
	if is_oil(api.nvim_get_current_buf()) then
		M.close()
		return
	end

	M.open()
end

function M.select(mode)
	local opts = {}

	if mode == "vertical" then
		opts.vertical = true
	elseif mode == "horizontal" then
		opts.horizontal = true
	elseif mode == "tab" then
		opts.tab = true
	end

	require("oil").select(opts)
end

return M
