local M = {}

local api = vim.api

local namespace = api.nvim_create_namespace("AdaptiveScrolloff")

local keyboard_scrolloff = 100
local mouse_scrolloff = 0

local mouse_input = false

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

	mouse_input = true

	-- Important: `scrolloff` changes before
	-- Neovim processes the click itself.
	api.nvim_set_option_value("scrolloff", mouse_scrolloff, {
		win = winid,
	})
end

local function keyboard()
	local winid = api.nvim_get_current_win()

	mouse_input = false

	api.nvim_set_option_value("scrolloff", keyboard_scrolloff, {
		win = winid,
	})
end

function M.setup()
	local group = api.nvim_create_augroup("AdaptiveScrolloff", {
		clear = true,
	})

	-- protection against re-registration after :source.
	vim.on_key(nil, namespace)

	vim.on_key(function(key, typed)
		local input = typed ~= "" and typed or key

		if is_mouse_input(input) then
			mouse()
			return
		end

		-- Set to “empty” for programmatically generated events.
		-- We are only interested in actual keyboard input.
		if typed ~= "" then
			keyboard()
		end
	end, namespace)

	api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		group = group,
		callback = function()
			if mouse_input then
				return
			end

			vim.cmd("normal! zz")
		end,
	})
end

return M
