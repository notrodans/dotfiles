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

autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("FilePost", { clear = true }),
	callback = function(args)
		local file = vim.api.nvim_buf_get_name(args.buf)
		local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

		if not vim.g.ui_entered and args.event == "UIEnter" then
			vim.g.ui_entered = true
		end

		if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
			vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
			vim.api.nvim_del_augroup_by_name("FilePost")

			vim.schedule(function()
				vim.api.nvim_exec_autocmds("FileType", {})

				if vim.g.editorconfig then
					require("editorconfig").config(args.buf)
				end
			end)
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

-- Override cursorline option for all buffers
-- autocmd({ "BufEnter", "WinEnter" }, {
-- 	callback = function()
-- 		local win = vim.api.nvim_get_current_win()
--
-- 		vim.schedule(function()
-- 			if vim.api.nvim_win_is_valid(win) then
-- 				vim.api.nvim_set_option_value("cursorline", true, {
-- 					win = win,
-- 				})
-- 			end
-- 		end)
-- 	end,
-- })

autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)

		local ok = pcall(vim.treesitter.get_parser, args.buf)

		if not ok then
			return
		end

		vim.opt_local.foldmethod = "expr"
		vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})

autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local function map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, {
				buffer = args.buf,
				desc = "LSP " .. desc,
			})
		end

		map("gD", vim.lsp.buf.declaration, "Go to declaration")
		map("gd", vim.lsp.buf.definition, "Go to definition")
		map("<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
		map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")

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

ucommand("TSInstallAll", function()
	require("nvim-treesitter").install(require("configs.treesitter").ensure_installed)
end, {})

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

autocmd("WinEnter", {
	callback = function()
		local win = vim.api.nvim_get_current_win()
		local config = vim.api.nvim_win_get_config(win)

		if config.relative == "" or vim.bo.filetype ~= "markdown" then
			return
		end

		vim.wo[win].conceallevel = 2
		vim.wo[win].concealcursor = "nv"
	end,
})
