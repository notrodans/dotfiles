local M = {}

local api = vim.api
local scroll = 4

local function apply(winid)
	if not api.nvim_win_is_valid(winid) then
		return
	end

	if api.nvim_get_option_value("scroll", { win = winid }) == scroll then
		return
	end

	api.nvim_win_call(winid, function()
		vim.cmd(("noautocmd setlocal scroll=%d"):format(scroll))
	end)
end

local function sync()
	for _, winid in ipairs(api.nvim_list_wins()) do
		apply(winid)
	end
end

function M.setup()
	local group = api.nvim_create_augroup("FixedScroll", { clear = true })

	sync()

	api.nvim_create_autocmd({ "WinNew", "WinEnter", "WinResized", "VimResized", "FocusGained" }, {
		group = group,
		callback = function()
			vim.schedule(sync)
		end,
	})

	api.nvim_create_autocmd("OptionSet", {
		group = group,
		pattern = "scroll",
		callback = function()
			vim.schedule(sync)
		end,
	})
end

return M
