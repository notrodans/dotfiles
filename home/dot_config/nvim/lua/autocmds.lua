local autocmd = vim.api.nvim_create_autocmd

vim.filetype.add({
	pattern = {
		["docker%-compose.*%.yml"] = "yaml.docker-compose",
		["docker%-compose.*%.yaml"] = "yaml.docker-compose",
		["compose%.yml"] = "yaml.docker-compose",
		["compose%.yaml"] = "yaml.docker-compose",
	},
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

autocmd({ "BufEnter", "WinEnter" }, {
	callback = function()
		local win = vim.api.nvim_get_current_win()

		vim.schedule(function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_set_option_value("cursorline", true, {
					win = win,
				})
			end
		end)
	end,
})

-- autocmd("FileType", {
-- 	pattern = { "markdown", "text", "gitcommit" },
-- 	callback = function()
-- 		vim.opt_local.wrap = true
-- 	end,
-- })

vim.api.nvim_create_autocmd("RecordingEnter", {
	callback = function()
		vim.notify("MACRO RECORDING @" .. vim.fn.reg_recording(), vim.log.levels.WARN)
	end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
	callback = function()
		vim.notify("MACRO RECORDING STOPPED")
	end,
})

autocmd("FileType", {
	pattern = "lazy_backdrop",
	callback = function(args)
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_get_buf(win) == args.buf then
				vim.api.nvim_win_set_config(win, {
					border = "none",
				})
			end
		end
	end,
})
