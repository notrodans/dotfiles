local command = vim.api.nvim_create_user_command

command("BufOnly", function()
	require("modules.tabufline").closeAllBufs(false)
end, {})
