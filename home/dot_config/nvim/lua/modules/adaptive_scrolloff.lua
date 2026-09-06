local M = {}

local api = vim.api

local namespace = api.nvim_create_namespace("AdaptiveScrolloff")
local keyboard_scrolloff = 100
local mouse_scrolloff = 0
local mouse_windows = {}

local function is_mouse_input(key)
	local byte = key:byte()

	if #key == 1 and byte and byte < 128 then
		return false
	end

	local name = vim.fn.keytrans(key)

	return name:find("Mouse", 1, true) ~= nil
		or name:find("Drag", 1, true) ~= nil
		or name:find("Release", 1, true) ~= nil
		or name:find("ScrollWheel", 1, true) ~= nil
end

local function window_under_mouse()
	local position = vim.fn.getmousepos()

	if position.winid == 0 or not api.nvim_win_is_valid(position.winid) then
		return nil
	end

	return position.winid
end

local function scrolloff(winid)
	return mouse_windows[winid] and mouse_scrolloff or keyboard_scrolloff
end

local function apply(winid)
	if not api.nvim_win_is_valid(winid) then
		return
	end

	local value = scrolloff(winid)

	if api.nvim_get_option_value("scrolloff", { win = winid }) == value then
		return
	end

	api.nvim_win_call(winid, function()
		vim.cmd(("noautocmd setlocal scrolloff=%d"):format(value))
	end)
end

local function sync()
	for _, winid in ipairs(api.nvim_list_wins()) do
		apply(winid)
	end
end

local function mouse()
	local winid = window_under_mouse()

	if not winid or mouse_windows[winid] then
		return
	end

	mouse_windows[winid] = true
	apply(winid)
end

local function keyboard()
	local winid = api.nvim_get_current_win()

	if not mouse_windows[winid] then
		return
	end

	mouse_windows[winid] = nil
	apply(winid)
end

function M.setup()
	vim.o.scrolloff = keyboard_scrolloff

	-- Protect against re-registration after :source.
	vim.on_key(nil, namespace)

	local group = api.nvim_create_augroup("AdaptiveScrolloff", { clear = true })

	api.nvim_create_autocmd({ "WinNew", "WinEnter" }, {
		group = group,
		callback = function()
			vim.schedule(sync)
		end,
	})

	api.nvim_create_autocmd("OptionSet", {
		group = group,
		pattern = "scrolloff",
		callback = function()
			vim.schedule(sync)
		end,
	})

	api.nvim_create_autocmd("WinClosed", {
		group = group,
		callback = function(args)
			local winid = tonumber(args.match)

			if winid then
				mouse_windows[winid] = nil
			end
		end,
	})

	vim.on_key(function(key, typed)
		local input = typed ~= "" and typed or key

		if is_mouse_input(input) then
			mouse()
			return
		end

		-- Ignore programmatically generated input.
		if typed ~= "" then
			keyboard()
		end
	end, namespace)
end

return M
