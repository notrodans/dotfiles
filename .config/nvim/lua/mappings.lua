require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "<C-g>", function()
  return vim.fn["codeium#Accept"]()
end, { expr = true })
map({ "n", "t" }, "<C-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Terminal Toggle Floating term" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
