local map = vim.keymap.set

map("i", "jj", "<ESC>", { silent = true })

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
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
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

-- tabs
map("n", "<leader>tc", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
map("n", "tn", "<cmd>tabnext<CR>", { desc = "Go to next tab" })
map("n", "tb", "<cmd>tabprevious<CR>", { desc = "Go to previous tab" })

-- tabufline
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

map("n", "<C-i>", function()
	require("nvchad.tabufline").next()
end, { desc = "buffer goto next", remap = true })

map("n", "<C-o>", function()
	require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev", remap = true })

map("n", "db", function()
	require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- tabulation
map("i", "<S-tab>", "<C-d>", { desc = "delete level of indentation", remap = true })

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })

-- undotree
map("n", "<C-m>", "<cmd>lua require('undotree').toggle()<CR>", { desc = "undotree toggle window" })

-- Fzf
map("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", { desc = "Fzf live grep" })
map("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "Fzf find buffers" })
map("n", "<leader>fh", "<cmd>FzfLua helptags<CR>", { desc = "Fzf find help pages" })
map("n", "<leader>ma", "<cmd>FzfLua marks<CR>", { desc = "Fzf find marks" })
map("n", "<leader>fo", "<cmd>FzfLua oldfiles<CR>", { desc = "Fzf find oldfiles" })
map("n", "<leader>fz", "<cmd>FzfLua lgrep_curbuf<CR>", { desc = "Fzf find in current buffer" })
map("n", "<leader>fz", "<cmd>FzfLua lgrep_curbuf<CR>", { desc = "Fzf find in current buffer" })
map("n", "<leader>fk", "<cmd>FzfLua keymaps<CR>", { desc = "Fzf find keymaps" })
map({ "n", "v" }, "<leader>fw", "<cmd>FzfLua grep_cword<CR>", { desc = "Fzf find current word" })
map({ "n", "v" }, "<leader>fW", "<cmd>FzfLua grep_cWORD<CR>", { desc = "Fzf find current WORD" })
map({ "n", "v" }, "<leader>fi", "<cmd>FzfLua lsp_implementations<CR>", { desc = "Fzf find lsp implementations" })
map({ "n", "v" }, "<leader>fd", "<cmd>FzfLua lsp_definitions<CR>", { desc = "Fzf find lsp definitions" })
map("n", "<leader>ft", "<cmd>TodoFzfLua<CR>", { desc = "Fzf find todo comments" })

-- git
map("n", "<leader>gbb", "<cmd>FzfLua git_branches<CR>", { desc = "Fzf git branches" })
map("n", "<leader>gbc", "<cmd>FzfLua git_bcommits<CR>", { desc = "Fzf git branch commits" })
map("n", "<leader>gc", "<cmd>FzfLua git_commits<CR>", { desc = "Fzf git commits" })
map("n", "<leader>gs", "<cmd>FzfLua git_status<CR>", { desc = "Fzf git status" })

-- global lsp mappings
map("n", "<leader>dd", "<cmd>FzfLua diagnostics_document<CR>", { desc = "LSP diagnostics document" })
map("n", "<leader>dw", "<cmd>FzfLua diagnostics_workspace<CR>", { desc = "LSP diagnostics workspace" })

map("n", "<leader>th", function()
	require("nvchad.themes").open()
end, { desc = "nvchad themes" })

map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Fzf find files" })

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- new terminals
map("n", "<leader>h", function()
	require("nvchad.term").new({ pos = "sp" })
end, { desc = "terminal new horizontal term" })

map("n", "<leader>v", function()
	require("nvchad.term").new({ pos = "vsp" })
end, { desc = "terminal new vertical term" })

-- toggleable
map({ "n", "t" }, "<A-v>", function()
	require("nvchad.term").toggle({ pos = "vsp", id = "vtoggleTerm" })
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
	require("nvchad.term").toggle({ pos = "sp", id = "htoggleTerm" })
end, { desc = "terminal toggleable horizontal term" })

map({ "n", "t" }, "<A-i>", function()
	require("nvchad.term").toggle({ pos = "float", id = "floatTerm" })
end, { desc = "terminal toggle floating term" })

-- code actions
map({ "n", "x" }, "gra", function()
	require("fzf-lua").lsp_code_actions({ silent = true })
end, { desc = "LSP code actions", noremap = true, silent = true })

-- quickfix list
map("n", "<A-k>", "<Up><CR><C-w>p", { remap = false, desc = "Navigate up quickfix" })
map("n", "<A-j>", "<Down><CR><C-w>p", { remap = false, desc = "Navigate down quickfix" })
