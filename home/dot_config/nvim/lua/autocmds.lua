local autocmd = vim.api.nvim_create_autocmd

autocmd({ "CursorMoved", "CursorMovedI" }, {
	group = vim.api.nvim_create_augroup("CenterCursor", { clear = true }),
	callback = function()
		vim.cmd("normal! zz")
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
		vim.wo.cursorline = true
	end,
})

autocmd({ "BufRead", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("DockerComposeFiletype", { clear = true }),
	pattern = {
		"docker-compose*.yml",
		"docker-compose*.yaml",
		"compose.yml",
		"compose.yaml",
	},
	callback = function()
		vim.bo.filetype = "yaml.docker-compose"
	end,
})

autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		local last_pos = vim.fn.line("'\"")
		if last_pos > 0 and last_pos <= vim.fn.line("$") then
			vim.cmd('normal! g`"')
		end
	end,
})

-- autocmd("FileType", {
-- 	pattern = { "markdown", "text", "gitcommit" },
-- 	callback = function()
-- 		vim.opt_local.wrap = true
-- 	end,
-- })

autocmd("BufWinLeave", {
	pattern = "*.*",
	command = "mkview",
})

autocmd("BufWinEnter", {
	pattern = "*.*",
	command = "silent! loadview",
})
