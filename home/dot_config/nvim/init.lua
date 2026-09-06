vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	local result = vim.system(
		{ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath },
		{ text = true }
	)
		:wait()

	if result.code ~= 0 then
		error(vim.trim(result.stderr or "Failed to clone lazy.nvim"))
	end
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

-- load plugins
require("lazy").setup({
	{ import = "plugins" },
}, lazy_config)

vim.cmd.packadd("nvim.difftool")

-- Compile Base46 only when the effective theme configuration changed.
require("modules.base46_cache").sync()

require("commands")
require("modules.tabufline").setup()
require("options")
require("autocmds")
require("modules.buffer_close").setup()

vim.schedule(function()
	require("mappings")
end)
