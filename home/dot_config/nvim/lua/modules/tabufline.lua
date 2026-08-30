local api = vim.api
local fn = vim.fn

local M = {}

local icon_highlights = {}

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

local function filename(path)
	return path:match("([^/\\]+)[/\\]*$")
end

local function buffer_metadata(bufs)
	local names = {}
	local items = {}
	local current = api.nvim_get_current_buf()

	for index, buf in ipairs(bufs) do
		local path = api.nvim_buf_get_name(buf)
		local name = filename(path)

		if name then
			names[name] = (names[name] or 0) + 1
		end

		items[index] = {
			buf = buf,
			path = path,
			name = name,
			active = current == buf,
			modified = api.nvim_get_option_value("modified", { buf = buf }),
		}
	end

	for _, item in ipairs(items) do
		if not item.name then
			item.label = "No Name"
		elseif names[item.name] > 1 then
			local parent = fn.fnamemodify(item.path, ":h:t")
			item.label = parent ~= "" and parent .. "/" .. item.name or item.name
		else
			item.label = item.name
		end
	end

	return items
end

local function icon_segment(name, hl)
	local tabufline_utils = utils()
	local icon, icon_hl = require("nvim-web-devicons").get_icon(name)

	if not icon then
		local fallback = " 󰈚 "
		return tabufline_utils.txt(fallback, hl), fn.strdisplaywidth(fallback)
	end

	local icon_color = api.nvim_get_hl(0, { name = icon_hl }).fg
	local buffer_color = api.nvim_get_hl(0, { name = "Tb" .. hl }).bg
	local combined = icon_hl .. hl
	local signature = tostring(icon_color) .. ":" .. tostring(buffer_color)

	if icon_highlights[combined] ~= signature then
		api.nvim_set_hl(0, combined, {
			fg = icon_color,
			bg = buffer_color,
		})
		icon_highlights[combined] = signature
	end

	local segment = " " .. icon .. " "
	return "%#" .. combined .. "#" .. segment, fn.strdisplaywidth(segment)
end

local function truncate_label(label, width)
	if width <= 0 then
		return "", 0
	end

	local full_width = fn.strdisplaywidth(label)

	if full_width <= width then
		return label, full_width
	end

	local ellipsis = "…"
	local budget = math.max(0, width - fn.strdisplaywidth(ellipsis))
	local chars = fn.strchars(label)
	local truncated = label

	while chars > 0 and fn.strdisplaywidth(truncated) > budget do
		chars = chars - 1
		truncated = fn.strcharpart(label, 0, chars)
	end

	truncated = truncated .. ellipsis
	return truncated, fn.strdisplaywidth(truncated)
end

local function style_buffer(item, width)
	local tabufline_utils = utils()
	local hl = "BufO" .. (item.active and "n" or "ff")
	local modified_hl = item.active and "BufOnModified" or "BufOffModified"
	local icon, icon_width = icon_segment(item.name or item.label, hl)
	local marker_text = item.modified and "  " or ""
	local marker = item.modified and tabufline_utils.txt(marker_text, modified_hl) or ""
	local marker_width = fn.strdisplaywidth(marker_text)
	local label, label_width = truncate_label(item.label, math.max(0, width - icon_width - marker_width))
	local body = icon .. tabufline_utils.txt(label, hl) .. marker
	local missing = math.max(0, width - icon_width - label_width - marker_width)
	local left = math.floor(missing / 2)
	local right = missing - left
	local padding_left = tabufline_utils.txt(string.rep(" ", left), hl)
	local padding_right = tabufline_utils.txt(string.rep(" ", right), hl)

	return tabufline_utils.btn(padding_left .. body .. padding_right, nil, "GoToBuf", item.buf)
end

local function anchor_buffer(bufs)
	local current = api.nvim_get_current_buf()

	for i, buf in ipairs(bufs) do
		if buf == current then
			vim.t.tabufline_anchor = buf
			return buf, i
		end
	end

	local anchor = vim.t.tabufline_anchor

	if anchor then
		for i, buf in ipairs(bufs) do
			if buf == anchor then
				return buf, i
			end
		end
	end

	vim.t.tabufline_anchor = bufs[1]

	return bufs[1], 1
end

local function visible_window(bufs, capacity, current)
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

	local items = buffer_metadata(bufs)
	local _, current = anchor_buffer(bufs)
	local available = available_width()
	local capacity = math.max(1, math.floor(available / opts.bufwidth))

	capacity = math.min(capacity, #bufs)

	local first, last = visible_window(bufs, capacity, current)
	local count = last - first + 1
	local width = math.floor(available / count)
	local remainder = available - width * count
	local result = {}

	for i = first, last do
		local extra = i - first < remainder and 1 or 0
		result[#result + 1] = style_buffer(items[i], width + extra)
	end

	return table.concat(result) .. tabufline_utils.txt("%=", "Fill")
end

return M
