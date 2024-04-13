---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "ashes",
  theme_toggle = { "ashes", "one_light" },
  transparency = true,

  hl_override = {
    CursorLine = {
      bg = "one_bg",
    },
    CmpDoc = {
      bg = "none",
    },
  },

  hl_add = {
    NvimTreeOpenedFolderName = { fg = "green", bold = true },
  },

  statusline = {
    theme = "default",
    separator_style = "round",
  },

  nvdash = {
    load_on_startup = true,
  },
}

return M
