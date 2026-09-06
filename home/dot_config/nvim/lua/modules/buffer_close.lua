local M = {}

local api = vim.api
local original_close

local function is_normal_buffer(bufnr)
	return bufnr
		and bufnr > 0
		and api.nvim_buf_is_valid(bufnr)
		and vim.bo[bufnr].buflisted
		and vim.bo[bufnr].buftype == ""
end

function M.close(bufnr)
	bufnr = bufnr or api.nvim_get_current_buf()

	-- Preserve tabufline behavior for terminals, plugin buffers, and
	-- closing a non-current buffer via the mouse.
	if bufnr ~= api.nvim_get_current_buf() or vim.bo[bufnr].buftype ~= "" then
		return original_close(bufnr)
	end

	local alternate = vim.fn.bufnr("#")

	if not is_normal_buffer(alternate) or alternate == bufnr then
		return original_close(bufnr)
	end

	local winid = api.nvim_get_current_win()
	local switched = pcall(api.nvim_win_set_buf, winid, alternate)

	if not switched then
		return original_close(bufnr)
	end

	local deleted = pcall(vim.cmd, ("confirm bdelete %d"):format(bufnr))

	if not deleted or (api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted) then
		if api.nvim_win_is_valid(winid) then
			pcall(api.nvim_win_set_buf, winid, bufnr)
		end
	end

	vim.cmd.redrawtabline()
end

function M.setup()
	local tabufline = require("modules.tabufline")

	if original_close then
		return
	end

	original_close = tabufline.close_buffer
	tabufline.close_buffer = M.close
end

return M
