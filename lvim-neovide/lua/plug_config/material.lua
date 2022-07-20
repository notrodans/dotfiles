vim.g.material_style = 'palenight'

require('material').setup({
  contrast = {
    sidebars = true,
    floating_windows = true,
  },
  italics = {
    keywords = false,
    functions = false,
  },
  contrast_filetypes = {
    'terminal',
    'packer',
    'qf',
  },
  disable = {
    borders = false,
    eob_lines = false
  }
})

vim.cmd [[
  highlight WinSeparator guifg=#c0bfbc
]]
