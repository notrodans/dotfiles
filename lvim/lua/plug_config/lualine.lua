lvim.builtin.lualine.style                        = 'default'
lvim.builtin.lualine.options.theme                = 'auto'
lvim.builtin.lualine.options.icons_enabled        = true
lvim.builtin.lualine.options.globalstatus         = true
lvim.builtin.lualine.options.disabled_filetypes   = { "alpha", "toggleterm" }
lvim.builtin.lualine.options.section_separators   = { left = "", right = "" }
lvim.builtin.lualine.options.component_separators = ''
lvim.builtin.lualine.sections.lualine_a           = {
  {
    "mode",
    fmt = function()
      return "asirix"
    end,
  },
}
lvim.builtin.lualine.sections.lualine_b           = {
  { "filetype", colored = true },
  { "branch" },
  {
    "diff",
    symbols = { added = " ", modified = "柳", removed = " " },
    diff_color = {
      added = { fg = "#98be65" },
      modified = { fg = "#FF8800" },
      removed = { fg = "#ec5f67" },
    },
  },
}
lvim.builtin.lualine.sections.lualine_c           = {
  { "filename", color = { fg = "#ffffff" } },
  { "filesize" },
}
lvim.builtin.lualine.sections.lualine_x           = {
  {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = { error = " ", warn = " ", info = " ", hint = " " },
    sections = { "error", "warn", "info", "hint" },
  },
  {
    -- Lsp server name .
    function()
      local msg = "No Active Lsp"
      local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
      local clients = vim.lsp.get_active_clients()
      if next(clients) == nil then
        return msg
      end
      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
          return client.name
        end
      end
      return msg
    end,
    icon = "⚙",
    color = { fg = "#ffffff", gui = "bold" },
  },
  {
    "fileformat",
    fmt = string.upper,
    icons_enabled = false,
    color = { gui = "bold" },
  },
}
lvim.builtin.lualine.sections.lualine_y           = { "progress" }
lvim.builtin.lualine.sections.lualine_z           = { "location" }
lvim.builtin.lualine.inactive_sections.lualine_c  = { "filename" }
lvim.builtin.lualine.inactive_sections.lualine_x  = { "location" }
lvim.builtin.lualine.extensions                   = { "nvim-tree" }
