local autocmd = vim.api.nvim_create_autocmd
local ucommand = vim.api.nvim_create_user_command

vim.filetype.add({
	filename = {
		["compose.yml"] = "yaml.docker-compose",
		["compose.yaml"] = "yaml.docker-compose",
	},
	pattern = {
		["docker%-compose.*%.yml$"] = "yaml.docker-compose",
		["docker%-compose.*%.yaml$"] = "yaml.docker-compose",
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

autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if client and client:supports_method("textDocument/linkedEditingRange") then
			vim.lsp.linked_editing_range.enable(true, {
				bufnr = args.buf,
				client_id = client.id,
			})
		end
	end,
})

-- autocmd("FileType", {
-- 	pattern = { "markdown", "text", "gitcommit" },
-- 	callback = function()
-- 		vim.opt_local.wrap = true
-- 	end,
-- })

autocmd("RecordingEnter", {
	callback = function()
		vim.notify("MACRO RECORDING @" .. vim.fn.reg_recording(), vim.log.levels.WARN)
	end,
})

autocmd("RecordingLeave", {
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

ucommand("Shell", function(opts)
	local function unique_buf_name(command)
		local base = ("*Shell: %s*"):format(command)
		local name = base
		local i = 2

		while vim.fn.bufexists(name) == 1 do
			name = ("%s <%d>"):format(base, i)
			i = i + 1
		end

		return name
	end

	local result = vim.system({ vim.o.shell, vim.o.shellcmdflag, opts.args }, { text = true }):wait()
	local output = vim.split(result.stdout or "", "\n", { plain = true, trimempty = true })

	if result.code ~= 0 then
		local message = vim.trim(result.stderr or "")

		if message == "" then
			message = ("Shell command exited with code %d"):format(result.code)
		end

		vim.notify(message, vim.log.levels.ERROR)
		return
	end

	if #output <= 1 then
		vim.notify(output[1] or "")
		return
	end

	vim.cmd("botright new")

	local buf = vim.api.nvim_get_current_buf()

	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

	vim.bo[buf].modifiable = false
	vim.bo[buf].filetype = "shelloutput"

	vim.api.nvim_buf_set_name(buf, unique_buf_name(opts.args))
end, {
	nargs = "+",
	complete = "shellcmd",
})
