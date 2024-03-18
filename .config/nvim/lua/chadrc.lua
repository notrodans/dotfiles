---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "nightlamp",
  theme_toggle = { "nightlamp", "one_light" },

  hl_override = {
    CursorLine = {
      bg = "line",
    },
  },

  hl_add = {
    NvimTreeOpenedFolderName = { fg = "green", bold = true },
  },

  transparency = true,

  nvdash = {
    load_on_startup = true,
  },
}

return M
