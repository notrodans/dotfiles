local api = vim.api

local M = {}

local function tab_var(tabpage, name)
	local ok, value = pcall(api.nvim_tabpage_get_var, tabpage, name)

	if ok then
		return value
	end
end

local function buffer_path(bufnr)
	if type(bufnr) ~= "number" or not api.nvim_buf_is_valid(bufnr) then
		return nil
	end

	local path = api.nvim_buf_get_name(bufnr)
	return path ~= "" and path or nil
end

local function save_tab(tabpage)
	local result = {
		buffers = {},
	}

	local buffers = tab_var(tabpage, "bufs")

	if type(buffers) == "table" then
		for _, bufnr in ipairs(buffers) do
			local path = buffer_path(bufnr)

			if path then
				result.buffers[#result.buffers + 1] = path
			end
		end
	end

	result.anchor = buffer_path(tab_var(tabpage, "tabufline_anchor"))

	return result
end

local function buffers_by_name()
	local result = {}

	for _, bufnr in ipairs(api.nvim_list_bufs()) do
		if api.nvim_buf_is_valid(bufnr) then
			local name = api.nvim_buf_get_name(bufnr)

			if name ~= "" then
				result[name] = bufnr

				local real = vim.uv.fs_realpath(name)
				if real then
					result[real] = bufnr
				end
			end
		end
	end

	return result
end

local function resolve_buffer(name, lookup)
	if not name then
		return nil
	end

	local bufnr = lookup[name]

	if bufnr then
		return bufnr
	end

	local real = vim.uv.fs_realpath(name)
	return real and lookup[real] or nil
end

local function restore_tab(tabpage, state, lookup)
	if not api.nvim_tabpage_is_valid(tabpage) then
		return
	end

	local buffers = {}
	local seen = {}

	for _, name in ipairs(state.buffers or {}) do
		local bufnr = resolve_buffer(name, lookup)

		if bufnr and not seen[bufnr] then
			seen[bufnr] = true
			buffers[#buffers + 1] = bufnr
		end
	end

	api.nvim_tabpage_set_var(tabpage, "bufs", buffers)

	local anchor = resolve_buffer(state.anchor, lookup)

	if not anchor then
		local current_win = api.nvim_tabpage_get_win(tabpage)
		local current_buf = api.nvim_win_get_buf(current_win)

		if seen[current_buf] then
			anchor = current_buf
		else
			anchor = buffers[1]
		end
	end

	if anchor then
		api.nvim_tabpage_set_var(tabpage, "tabufline_anchor", anchor)
	else
		pcall(api.nvim_tabpage_del_var, tabpage, "tabufline_anchor")
	end
end

M.on_save = function(opts)
	local tabpages

	if opts.tabpage then
		tabpages = { opts.tabpage }
	else
		tabpages = api.nvim_list_tabpages()
	end

	local tabs = {}

	for _, tabpage in ipairs(tabpages) do
		tabs[#tabs + 1] = save_tab(tabpage)
	end

	return {
		tab_scoped = opts.tabpage ~= nil,
		tabs = tabs,
	}
end

M.on_post_load = function(data)
	local tabpages

	if data.tab_scoped then
		tabpages = { api.nvim_get_current_tabpage() }
	else
		tabpages = api.nvim_list_tabpages()
	end

	local lookup = buffers_by_name()

	for index, state in ipairs(data.tabs or {}) do
		local tabpage = tabpages[index]

		if tabpage then
			restore_tab(tabpage, state, lookup)
		end
	end

	vim.schedule(function()
		vim.cmd("redrawtabline")
	end)
end

return M
