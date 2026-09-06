local utils = require("utils")

local map = vim.keymap.set

map("i", "jj", "<ESC>", { silent = true })

map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
map("n", "yY", "<cmd>%y+<CR>", { desc = "general copy whole file" })

map({ "n", "v" }, "<leader>u", function()
	vim.cmd("packadd nvim.undotree")
	vim.cmd("Undotree")
end, { desc = "undotree toggle window" })

-- tabs
map("n", "<leader>tc", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "tn", "<cmd>tabnext<CR>", { desc = "Go to next tab" })
map("n", "tb", "<cmd>tabprevious<CR>", { desc = "Go to previous tab" })

-- tabufline
map("n", "]b", function()
	require("modules.tabufline").next()
end, { desc = "buffer goto next", remap = true })

map("n", "[b", function()
	require("modules.tabufline").prev()
end, { desc = "buffer goto prev", remap = true })

map("n", "db", function()
	require("modules.tabufline").close_buffer()
end, { desc = "buffer close" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- oil
map("n", "<C-n>", function()
	require("modules.oil").toggle()
end, { desc = "oil toggle window" })

map("n", "<leader>th", function()
	require("modules.theme_picker").open()
end, { desc = "base46 themes" })

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

local function toggle_term(opts)
	require("modules.terminal").toggle(opts)

	if vim.bo.buftype == "terminal" then
		vim.cmd.startinsert()
	end
end

-- toggleable
map({ "n", "t" }, "<A-v>", function()
	toggle_term({ pos = "vsp", id = "vtoggleTerm" })
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
	toggle_term({ pos = "sp", id = "htoggleTerm" })
end, { desc = "terminal toggleable horizontal term" })

map({ "n", "t" }, "<A-i>", function()
	toggle_term({ pos = "float", id = "floatTerm" })
end, { desc = "terminal toggle floating term" })

-- quickfix list
map("n", "<A-k>", "<Up><CR><C-w>p", { remap = false, desc = "Navigate up quickfix" })
map("n", "<A-j>", "<Down><CR><C-w>p", { remap = false, desc = "Navigate down quickfix" })

-- lsp
map("n", "<leader>dt", function()
	local config = vim.diagnostic.config
	local vt = config().virtual_text
	config({ virtual_text = not vt })
end, { desc = "Toggle Virtual Text" })

-- scrolling
map({ "n", "x" }, "<C-d>", function()
	return vim.wo.scroll .. "j"
end, { desc = "scroll down", expr = true })

map({ "n", "x" }, "<C-u>", function()
	return vim.wo.scroll .. "k"
end, { desc = "scroll up", expr = true })

-- macroses
-- vim.keymap.set("n", "q", "<nop>", { silent = true }) -- fucking piece of shit

-- Grep within text selection
map("x", "/", function()
	local pattern = utils.visual_pattern()

	vim.cmd.normal({
		vim.keycode("<Esc>"),
		bang = true,
	})

	vim.fn.setreg("/", pattern)
end, { desc = "search visual selection" })

map("x", "<leader>q", function()
	local pattern = utils.visual_pattern()

	vim.cmd.normal({
		vim.keycode("<Esc>"),
		bang = true,
	})

	local escaped = pattern:gsub("/", "\\/")
	vim.cmd("silent vimgrep /" .. escaped .. "/gj %")
	vim.cmd.copen()
end, { desc = "quickfix visual matches" })

-- formatting
map("n", "<leader>fm", function()
	require("conform").format({
		async = true,
		lsp_format = "fallback",
	})
end, { desc = "format buffer" })
