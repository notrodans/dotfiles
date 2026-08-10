local M = {}

local api = vim.api

local namespace = api.nvim_create_namespace("AdaptiveScrolloff")

local keyboard_scrolloff = 100
local mouse_scrolloff = 0

local function is_mouse_input(key)
	local name = vim.fn.keytrans(key)

	return name:find("Mouse", 1, true) ~= nil
		or name:find("Drag", 1, true) ~= nil
		or name:find("Release", 1, true) ~= nil
		or name:find("ScrollWheel", 1, true) ~= nil
end

local function window_under_mouse()
	local position = vim.fn.getmousepos()

	if position.winid == 0 then
		return nil
	end

	if not api.nvim_win_is_valid(position.winid) then
		return nil
	end

	return position.winid
end

local function mouse()
	local winid = window_under_mouse()

	if not winid then
		return
	end

	-- Change scrolloff before Neovim processes the mouse input itself.
	api.nvim_set_option_value("scrolloff", mouse_scrolloff, {
		win = winid,
	})
end

local function keyboard()
	api.nvim_set_option_value("scrolloff", keyboard_scrolloff, {
		win = api.nvim_get_current_win(),
	})
end

function M.setup()
	-- Protect against re-registration after :source.
	vim.on_key(nil, namespace)

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
