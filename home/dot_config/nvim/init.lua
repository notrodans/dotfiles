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

-- Recompile Base46 on startup so local nvconfig changes such as
-- transparency and highlight overrides are reflected in the cache.
require("base46").load_all_highlights()

require("commands")
require("options")
require("autocmds")
require("modules.tabufline").setup()
require("modules.buffer_close").setup()
require("modules.adaptive_scrolloff").setup()

vim.schedule(function()
	require("mappings")
end)
