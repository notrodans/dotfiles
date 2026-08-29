local M = {}

local function visual_text()
	local mode = vim.fn.mode()
	local start = vim.fn.getpos("v")
	local finish = vim.fn.getpos(".")

	local lines = vim.fn.getregion(start, finish, {
		type = mode,
	})

	return table.concat(lines, "\n")
end

function M.visual_pattern()
	local text = visual_text()

	return "\\V" .. vim.fn.escape(text, "\\"):gsub("\n", "\\n")
end

return M
