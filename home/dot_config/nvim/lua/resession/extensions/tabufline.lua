local api = vim.api

local M = {}

local function tab_var(tabpage, name)
	local ok, value = pcall(api.nvim_tabpage_get_var, tabpage, name)

	if ok then
		return value
	end
end

local function filename(path)
	return path:match("([^/\\]+)[/\\]*$")
end

local function buffer_name(bufs, buf, index)
	local path = api.nvim_buf_get_name(buf)
	local name = filename(path)

	if not name then
		return "No Name"
	end

	for i, other in ipairs(bufs) do
		if i ~= index and filename(api.nvim_buf_get_name(other)) == name then
			local parent = fn.fnamemodify(path, ":h:t")

			return parent ~= "" and parent .. "/" .. name or name
		end
	end

	return name
end

local function icon_segment(name, hl)
	local tabufline_utils = utils()
	local icon, icon_hl = require("nvim-web-devicons").get_icon(name)

	if not icon then
		return tabufline_utils.txt(" 󰈚 ", hl)
	end

	local icon_color = api.nvim_get_hl(0, { name = icon_hl }).fg
	local buffer_color = api.nvim_get_hl(0, { name = "Tb" .. hl }).bg
	local combined = icon_hl .. hl

	api.nvim_set_hl(0, combined, {
		fg = icon_color,
		bg = buffer_color,
	})

	return "%#" .. combined .. "# " .. icon .. " "
end

local function rendered_width(content)
	return api.nvim_eval_statusline(content, {
		use_tabline = true,
	}).width
end

local function style_buffer(bufs, buf, index, width)
	local tabufline_utils = utils()
	local active = api.nvim_get_current_buf() == buf
	local hl = "BufO" .. (active and "n" or "ff")
	local modified = api.nvim_get_option_value("modified", { buf = buf })
	local modified_hl = active and "BufOnModified" or "BufOffModified"
	local original = buffer_name(bufs, buf, index)
	local name = original
	local truncated = false

	local function content()
		local label = truncated and name .. "…" or name
		local marker = modified and tabufline_utils.txt("  ", modified_hl) or ""

		return icon_segment(original, hl) .. tabufline_utils.txt(label, hl) .. marker
	end

	local body = content()

	while rendered_width(body) > width and fn.strchars(name) > 1 do
		name = fn.strcharpart(name, 0, fn.strchars(name) - 1)
		truncated = true
		body = content()
	end

	local missing = math.max(0, width - rendered_width(body))
	local left = math.floor(missing / 2)
	local right = missing - left
	local padding_left = tabufline_utils.txt(string.rep(" ", left), hl)
	local padding_right = tabufline_utils.txt(string.rep(" ", right), hl)

	return tabufline_utils.btn(padding_left .. body .. padding_right, nil, "GoToBuf", buf)
end

local function save_tab(tabpage)
	local result = {
		buffers = {},
	}

	local buffers = tab_var(tabpage, "bufs")

	if type(buffers) == "table" then
		for _, bufnr in ipairs(buffers) do
			local name = buffer_name(bufnr)

			if name then
				result.buffers[#result.buffers + 1] = name
			end
		end
	end

	result.anchor = buffer_name(tab_var(tabpage, "tabufline_anchor"))

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
