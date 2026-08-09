local api = vim.api
local fn = vim.fn

local M = {}

local function config()
	return require("nvconfig").ui.tabufline
end

local function utils()
	return require("nvchad.tabufline.utils")
end

local function tabs_width()
	local count = fn.tabpagenr("$")

	if count <= 1 then
		return 0
	end

	local tabufline_utils = utils()
	local result = ""

	if vim.g.TbTabsToggled == 1 then
		result = tabufline_utils.btn(" 󰅁 ", "TabTitle", "ToggleTabs")
	else
		result = result
			.. tabufline_utils.btn(" 󰐕 ", "TabNewBtn", "NewTab")
			.. tabufline_utils.btn(" TABS ", "TabTitle", "ToggleTabs")

		for nr = 1, count do
			local hl = "TabO" .. (nr == fn.tabpagenr() and "n" or "ff")

			result = result .. tabufline_utils.btn(" " .. nr .. " ", hl, "GotoTab", nr)
		end
	end

	return api.nvim_eval_statusline(result, {
		use_tabline = true,
	}).width
end

local function available_width()
	return math.max(1, vim.o.columns - tabs_width())
end

local function current_index(bufs)
	local current = api.nvim_get_current_buf()

	for i, buf in ipairs(bufs) do
		if buf == current then
			return i
		end
	end

	return 1
end

local function visible_window(bufs, capacity)
	local current = current_index(bufs)

	local left = math.floor((capacity - 1) / 2)

	local first = current - left
	local last = first + capacity - 1

	if first < 1 then
		first = 1
		last = math.min(#bufs, capacity)
	end

	if last > #bufs then
		last = #bufs
		first = math.max(1, last - capacity + 1)
	end

	return first, last
end

function M.buffers()
	local opts = config()
	local tabufline_utils = utils()

	local bufs = vim.tbl_filter(api.nvim_buf_is_valid, vim.t.bufs or {})

	vim.t.bufs = bufs

	if #bufs == 0 then
		return ""
	end

	local available = available_width()

	local capacity = math.max(1, math.floor(available / opts.bufwidth))

	capacity = math.min(capacity, #bufs)

	local first, last = visible_window(bufs, capacity)
	local count = last - first + 1

	local width = math.floor(available / count)
	local remainder = available - width * count

	local result = {}

	for i = first, last do
		local extra = i - first < remainder and 1 or 0

		result[#result + 1] = tabufline_utils.style_buf(bufs[i], i, width + extra)
	end

	return table.concat(result) .. tabufline_utils.txt("%=", "Fill")
end

return M
