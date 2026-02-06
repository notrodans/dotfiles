local autocmd = vim.api.nvim_create_autocmd

autocmd({ "CursorMoved", "CursorMovedI" }, {
	group = vim.api.nvim_create_augroup("CenterCursor", { clear = true }),
	callback = function()
		vim.cmd("normal! zz")
	end,
})

autocmd("FileType", {
	pattern = "*",
	callback = function()
		-- setting up folds
		if require("nvim-treesitter.parsers").has_parser() then
			vim.opt_local.foldmethod = "expr"
			vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		else
			vim.opt_local.foldmethod = "syntax"
		end
	end,
})

autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		local line = vim.fn.line("'\"")
		if
			line > 1
			and line <= vim.fn.line("$")
			and vim.bo.filetype ~= "commit"
			and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
		then
			vim.cmd('normal! g`"')
		end
	end,
})

local scroll = vim.o.scroll

autocmd({
	"BufEnter",
	"VimResized",
	"UIEnter",
	"MenuPopup",
	"TermEnter",
}, {
	pattern = "*",
	callback = function(args)
		-- NvChad themes fix
		if string.len(args.match) ~= 0 then
			vim.wo.scroll = scroll
		end
	end,
})
