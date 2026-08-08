vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

-- load plugins
require("lazy").setup({
	{
		"notrodans/NvChad",
		lazy = false,
		branch = "v2.5",
		import = "nvchad.plugins",
	},

	change_detection = {
		enabled = false,
		notify = false, -- get a notification when changes are found
	},

	{ import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require("commands")
require("options")
require("autocmds")
require("nvchad.autocmds")
require("modules.buffer_close").setup()
require("modules.adaptive_scrolloff").setup()

if vim.g.neovide then
	vim.g.neovide_scroll_animation_length = 0
	vim.g.neovide_cursor_animation_length = 0.05
	vim.g.neovide_refresh_rate = 144
	vim.g.neovide_progress_bar_enabled = false
	vim.cmd([[
		" system clipboard
		nmap <c-c> "+y
		vmap <c-c> "+y
		nmap <c-v> "+p
		inoremap <c-v> <c-r>+
		cnoremap <c-v> <c-r>+
		" use <c-r> to insert original character without triggering things like auto-pairs
		inoremap <c-r> <c-v>
	]])
end

vim.schedule(function()
	require("mappings")
end)
