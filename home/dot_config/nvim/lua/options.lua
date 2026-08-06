local opt = vim.opt
local o = vim.o
local g = vim.g
local wo = vim.wo

-------------------------------------- options ------------------------------------------

opt.paste = false

-- folds
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt_local.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

--latex
opt.conceallevel = 2

-- spelling
vim.o.spelllang = "ru_ru,en_us"

-- mouse
o.mouse = "a"
o.mousefocus = false
o.mousemoveevent = false

-- windows
o.winborder = "rounded"

-- netrw
g.netrw_banner = 0 -- Now we won't have bloated top of the window
g.netrw_liststyle = 3 -- Now it will be a tree view
g.netrw_bufsettings = "nu nobl"

o.cmdheight = 0
o.laststatus = 3
o.showmode = false
o.virtualedit = "all"

o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "number,line"
o.scroll = 4
opt.scrolloff = 100
wo.wrap = false
wo.linebreak = false

-- Indenting
o.expandtab = false
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4
o.list = true
o.listchars = "tab:  ,eol:¬"

opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true

-- Numbers
o.number = true
o.numberwidth = 1
o.relativenumber = true
o.ruler = false

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true
-- opt.guicursor = "n-v-c:block,i-ci-ve:ver25"
opt.guicursor = "a:block-blinkon250"
o.swapfile = false

-- local nvim config
o.secure = true
o.exrc = true

-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 250

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH
