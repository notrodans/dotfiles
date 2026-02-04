vim.api.nvim_create_user_command("BufOnly", function()
	vim.cmd('silent! execute "%bdelete|edit #|bdelete #"')
end, {})
