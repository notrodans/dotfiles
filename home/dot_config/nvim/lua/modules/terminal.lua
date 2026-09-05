local api = vim.api

local M = {}
local terms = {}
local config = require("nvconfig").term

local positions = {
	sp = {
		resize = "height",
		area = "lines",
	},
	vsp = {
		resize = "width",
		area = "columns",
	},
	["bo sp"] = {
		resize = "height",
		area = "lines",
	},
	["bo vsp"] = {
		resize = "width",
		area = "columns",
	},
}

local function load_colors()
	if config.base46_colors then
		pcall(dofile, vim.g.base46_cache .. "term")
	end
end

local function float_options(overrides)
	local opts = vim.tbl_deep_extend("force", {}, config.float, overrides or {})

	opts.width = math.ceil(opts.width * vim.o.columns)
	opts.height = math.ceil(opts.height * vim.o.lines)
	opts.row = math.ceil(opts.row * vim.o.lines)
	opts.col = math.ceil(opts.col * vim.o.columns)

	return opts
end

local function display(term, opts)
	local win

	if opts.pos == "float" then
		win = api.nvim_open_win(term.buf, true, float_options(opts.float_opts))
	else
		vim.cmd(opts.pos)
		win = api.nvim_get_current_win()
		api.nvim_win_set_buf(win, term.buf)

		local position = positions[opts.pos]
		local size = opts.size or config.sizes[opts.pos]

		if position and size then
			local value = math.floor(vim.o[position.area] * size)
			api["nvim_win_set_" .. position.resize](win, value)
		end
	end

	term.win = win

	vim.bo[term.buf].buflisted = false
	vim.bo[term.buf].filetype = "Term_" .. opts.pos:gsub(" ", "")

	local winopts = vim.tbl_deep_extend("force", {}, config.winopts, opts.winopts or {})
	for name, value in pairs(winopts) do
		vim.wo[win][name] = value
	end

	if config.startinsert then
		vim.cmd.startinsert()
	end
end

local function create(opts)
	local term = terms[opts.id]
	local new_buffer = not term or not api.nvim_buf_is_valid(term.buf)

	if new_buffer then
		term = {
			id = opts.id,
			buf = api.nvim_create_buf(false, true),
		}
		terms[opts.id] = term
	end

	display(term, opts)

	if new_buffer then
		vim.fn.termopen({ vim.o.shell }, {
			detach = false,
			on_exit = function()
				terms[opts.id] = nil
			end,
		})
	end

	return term
end

function M.toggle(opts)
	assert(opts and opts.id and opts.pos, "terminal toggle requires id and pos")

	local term = terms[opts.id]

	if term and api.nvim_buf_is_valid(term.buf) then
		local win = vim.fn.bufwinid(term.buf)

		if win ~= -1 and api.nvim_win_is_valid(win) then
			api.nvim_win_close(win, true)
			return
		end
	end

	create(opts)
end

load_colors()

api.nvim_create_autocmd("User", {
	pattern = "NvThemeReload",
	callback = load_colors,
})

return M
