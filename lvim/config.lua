vim.cmd [[
  let g:indent_blankline_filetype_exclude = ['alpha','packer', 'toggleterm']
  let ayucolor="mirage"
]]

lvim.transparent_window = true
lvim.format_on_save     = { timeout = 3000 }
lvim.colorscheme        = "material"
lvim.use_icons          = true
vim.opt.list            = true

lvim.leader = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

lvim.builtin.alpha.active               = true
lvim.builtin.alpha.mode                 = "dashboard"
lvim.builtin.notify.active              = false
lvim.builtin.terminal.active            = true
lvim.lsp.automatic_servers_installation = true

require("plug_config.dashboard")
require("plug_config.lualine")
require("plug_config.bufferline")
require("plug_config.nvim-tree")
require("plug_config.cmp")
require("plug_config.material")
require("plug_config.treesitter")
require("plug_config.bindings")
require("plug_config.formatters")
require("plug_config.plugins")
