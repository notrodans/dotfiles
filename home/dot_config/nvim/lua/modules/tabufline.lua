local api = vim.api
local fn = vim.fn

local M = {}
local icon_highlights = {}
local enabled = false
local setup_done = false

local function config()
	return require("nvconfig").ui.tabufline
end

local function txt(str, hl)
	return "%#Tb" .. hl .. "#" .. (str or "")
end

local function btn(str, hl, func, arg)
	str = hl and txt(str, hl) or str
	return "%" .. (arg or "") .. "@Tb" .. func .. "@" .. str .. "%X"
end

local function valid_listed_buffer(buf)
	return api.nvim_buf_is_valid(buf) and api.nvim_get_option_value("buflisted", { buf = buf })
end

local function buffers()
	local bufs = vim.t.bufs

	if type(bufs) ~= "table" then
		bufs = vim.tbl_filter(valid_listed_buffer, api.nvim_list_bufs())
	end

	bufs = vim.tbl_filter(valid_listed_buffer, bufs)
	vim.t.bufs = bufs

	return bufs
end

local function buffer_index(bufnr)
	for index, buf in ipairs(buffers()) do
		if buf == bufnr then
			return index
		end
	end
end

local function render_tabs()
	local count = fn.tabpagenr("$")

	if count <= 1 then
		return ""
	end

	if vim.g.TbTabsToggled == 1 then
		return btn(" 󰅁 ", "TabTitle", "ToggleTabs")
	end

	local result = btn(" 󰐕 ", "TabNewBtn", "NewTab") .. btn(" TABS ", "TabTitle", "ToggleTabs")

	for nr = 1, count do
		local hl = "TabO" .. (nr == fn.tabpagenr() and "n" or "ff")
		result = result .. btn(" " .. nr .. " ", hl, "GotoTab", nr)
	end

	return result
end

local function tabs_width()
	return api.nvim_eval_statusline(render_tabs(), {
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
	local icon, icon_hl = require("nvim-web-devicons").get_icon(name)

	if not icon then
		local fallback = " 󰈚 "
		return txt(fallback, hl), fn.strdisplaywidth(fallback)
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
	local hl = "BufO" .. (item.active and "n" or "ff")
	local modified_hl = item.active and "BufOnModified" or "BufOffModified"
	local icon, icon_width = icon_segment(item.name or item.label, hl)
	local marker_text = item.modified and "  " or ""
	local marker = item.modified and txt(marker_text, modified_hl) or ""
	local marker_width = fn.strdisplaywidth(marker_text)
	local label, label_width = truncate_label(item.label, math.max(0, width - icon_width - marker_width))
	local body = icon .. txt(label, hl) .. marker
	local missing = math.max(0, width - icon_width - label_width - marker_width)
	local left = math.floor(missing / 2)
	local right = missing - left
	local padding_left = txt(string.rep(" ", left), hl)
	local padding_right = txt(string.rep(" ", right), hl)

	return btn(padding_left .. body .. padding_right, nil, "GoToBuf", item.buf)
end

local function anchor_buffer(bufs)
	local current = api.nvim_get_current_buf()

	for index, buf in ipairs(bufs) do
		if buf == current then
			vim.t.tabufline_anchor = buf
			return buf, index
		end
	end

	local anchor = vim.t.tabufline_anchor

	if anchor then
		for index, buf in ipairs(bufs) do
			if buf == anchor then
				return buf, index
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
	local bufs = buffers()

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

	for index = first, last do
		local extra = index - first < remainder and 1 or 0
		result[#result + 1] = style_buffer(items[index], width + extra)
	end

	return table.concat(result) .. txt("%=", "Fill")
end

function M.tabs()
	return render_tabs()
end

function M.render()
	local result = {}

	for _, module in ipairs(config().order) do
		if module == "buffers" then
			result[#result + 1] = M.buffers()
		elseif module == "tabs" then
			result[#result + 1] = M.tabs()
		end
	end

	return table.concat(result)
end

function M.next()
	local bufs = buffers()

	if #bufs == 0 then
		return
	end

	local current = buffer_index(api.nvim_get_current_buf())

	if not current then
		api.nvim_set_current_buf(bufs[1])
		return
	end

	api.nvim_set_current_buf(current == #bufs and bufs[1] or bufs[current + 1])
end

function M.prev()
	local bufs = buffers()

	if #bufs == 0 then
		return
	end

	local current = buffer_index(api.nvim_get_current_buf())

	if not current then
		api.nvim_set_current_buf(bufs[1])
		return
	end

	api.nvim_set_current_buf(current == 1 and bufs[#bufs] or bufs[current - 1])
end

function M.goto_buf(bufnr)
	if not valid_listed_buffer(bufnr) then
		return
	end

	local current_win = api.nvim_get_current_win()
	local fixed = api.nvim_get_option_value("winfixbuf", { win = current_win })

	if fixed then
		for _, win in ipairs(api.nvim_list_wins()) do
			local buf = api.nvim_win_get_buf(win)
			local listed = api.nvim_get_option_value("buflisted", { buf = buf })
			local win_fixed = api.nvim_get_option_value("winfixbuf", { win = win })

			if listed and not win_fixed then
				api.nvim_set_current_win(win)
				break
			end
		end
	end

	api.nvim_set_current_buf(bufnr)
end

function M.close_buffer(bufnr)
	bufnr = bufnr or api.nvim_get_current_buf()

	if not api.nvim_buf_is_valid(bufnr) then
		return
	end

	if vim.bo[bufnr].buftype == "terminal" then
		if vim.bo[bufnr].buflisted then
			vim.cmd("set nobl | enew")
		else
			vim.cmd("hide")
		end
	else
		local current_index = buffer_index(bufnr)
		local bufhidden = vim.bo[bufnr].bufhidden

		if api.nvim_win_get_config(0).zindex then
			vim.cmd("bw")
			return
		elseif current_index and #buffers() > 1 then
			local offset = current_index == #buffers() and -1 or 1
			M.goto_buf(buffers()[current_index + offset])
		elseif not vim.bo[bufnr].buflisted then
			local first = buffers()[1]

			if first then
				local win = fn.bufwinid(first)
				api.nvim_set_current_win(win ~= -1 and win or 0)
				api.nvim_set_current_buf(first)
			end

			vim.cmd("bw" .. bufnr)
			return
		else
			vim.cmd("enew")
		end

		if bufhidden ~= "delete" then
			vim.cmd("confirm bd" .. bufnr)
		end
	end

	vim.cmd.redrawtabline()
end

function M.closeAllBufs(include_current)
	local current = api.nvim_get_current_buf()
	local targets = vim.deepcopy(buffers())

	for _, buf in ipairs(targets) do
		if include_current ~= false or buf ~= current then
			M.close_buffer(buf)
		end
	end
end

local function enable()
	if enabled then
		return
	end

	enabled = true
	vim.o.showtabline = 2
	vim.o.tabline = "%!v:lua.require('modules.tabufline').render()"
	dofile(vim.g.base46_cache .. "tbline")
end

local function maybe_enable()
	if #fn.getbufinfo({ buflisted = 1 }) >= 2 or #api.nvim_list_tabpages() >= 2 then
		enable()
		return true
	end

	return false
end

local function define_click_handlers()
	vim.cmd([[
		function! TbGoToBuf(bufnr,b,c,d)
			call luaeval('require("modules.tabufline").goto_buf(_A)', a:bufnr)
		endfunction

		function! TbKillBuf(bufnr,b,c,d)
			call luaeval('require("modules.tabufline").close_buffer(_A)', a:bufnr)
		endfunction

		function! TbNewTab(a,b,c,d)
			tabnew
		endfunction

		function! TbGotoTab(tabnr,b,c,d)
			execute a:tabnr .. 'tabnext'
		endfunction

		function! TbToggleTabs(a,b,c,d)
			let g:TbTabsToggled = !g:TbTabsToggled
			redrawtabline
		endfunction
	]])
end

function M.setup()
	if setup_done or not config().enabled then
		return
	end

	setup_done = true
	vim.g.TbTabsToggled = vim.g.TbTabsToggled or 0
	vim.t.bufs = buffers()

	define_click_handlers()

	local group = api.nvim_create_augroup("Tabufline", { clear = true })

	api.nvim_create_autocmd({ "BufAdd", "BufEnter", "TabNew" }, {
		group = group,
		callback = function(args)
			local bufs = buffers()

			if valid_listed_buffer(args.buf) and not vim.tbl_contains(bufs, args.buf) then
				bufs[#bufs + 1] = args.buf
			end

			if args.event == "BufAdd" and #bufs > 1 then
				local first = bufs[1]

				if
					first ~= api.nvim_get_current_buf()
					and api.nvim_buf_get_name(first) == ""
					and not api.nvim_get_option_value("modified", { buf = first })
				then
					table.remove(bufs, 1)
				end
			end

			vim.t.bufs = bufs
			vim.cmd.redrawtabline()
		end,
	})

	api.nvim_create_autocmd("BufDelete", {
		group = group,
		callback = function(args)
			for _, tab in ipairs(api.nvim_list_tabpages()) do
				local bufs = vim.t[tab].bufs

				if type(bufs) == "table" then
					for index, buf in ipairs(bufs) do
						if buf == args.buf then
							table.remove(bufs, index)
							vim.t[tab].bufs = bufs
							break
						end
					end
				end
			end
		end,
	})

	api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "qf",
		callback = function()
			vim.opt_local.buflisted = false
		end,
	})

	if config().lazyload then
		if not maybe_enable() then
			api.nvim_create_autocmd({ "BufNew", "BufNewFile", "BufRead", "TabEnter", "TermOpen" }, {
				group = group,
				callback = function()
					if maybe_enable() then
						return true
					end
				end,
			})
		end
	else
		enable()
	end
end

return M
