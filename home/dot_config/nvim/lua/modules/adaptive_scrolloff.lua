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

local function mouse()
	local winid = window_under_mouse()

	if not winid or mouse_windows[winid] then
		return
	end

	api.nvim_set_option_value("scrolloff", mouse_scrolloff, {
		win = winid,
	})
	mouse_windows[winid] = true
end

local function keyboard()
	local winid = api.nvim_get_current_win()

	if not mouse_windows[winid] then
		return
	end

	api.nvim_set_option_value("scrolloff", keyboard_scrolloff, {
		win = winid,
	})
	mouse_windows[winid] = nil
end

function M.setup()
	vim.o.scrolloff = keyboard_scrolloff

	-- Protect against re-registration after :source.
	vim.on_key(nil, namespace)

	local group = api.nvim_create_augroup("AdaptiveScrolloff", { clear = true })
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
