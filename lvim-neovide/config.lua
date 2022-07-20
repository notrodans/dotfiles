vim.cmd [[
  let g:neovide_cursor_vfx_mode               = "pixiedust"
  let g:neovide_cursor_vfx_particle_lifetime  = 2
  let g:neovide_cursor_vfx_particle_density   = '10'
  let g:neovide_scroll_animation_length       = 0.5
  let g:neovide_refresh_rate                  = 75
  let g:neovide_transparency                  = 0.85
  let g:neovide_input_use_logo                = v:true
  let g:neovide_cursor_antialiasing           = v:true
]]

lvim.format_on_save = { timeout = 3000 }
lvim.colorscheme    = "material"
lvim.use_icons      = true
vim.opt.list        = true
vim.opt.guifont     = "JetBrains Mono:h15"

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
