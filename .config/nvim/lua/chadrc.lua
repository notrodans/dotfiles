---@type ChadrcConfig
return {
  base46 = {
    theme = "kanagawa",
    theme_toggle = { "tokyodark", "one_light" },
    transparency = false,
    hl_override = {
      -- CursorLine = {
      --   bg = "one_bg",
      -- },
      CmpDoc = {
        bg = "none",
      },
    },
    hl_add = {
      NvimTreeOpenedFolderName = { fg = "green", bold = true },
    },
  },

  ui = {
    statusline = {
      theme = "default",
      separator_style = "round",
    },
  },

  nvdash = {
    load_on_startup = true,
    header = {
      [[_       _______________________ _______ ______ _______ _          _______]],
      [[( (    /(  ___  \__   __(  ____ (  ___  (  __  \(  ___  ( (    /(  ____ \]],
      [[|  \  ( | (   ) |  ) (  | (    )| (   ) | (  \  | (   ) |  \  ( | (    \/]],
      [[|   \ | | |   | |  | |  | (____)| |   | | |   ) | (___) |   \ | | (_____ ]],
      [[| (\ \) | |   | |  | |  |     __| |   | | |   | |  ___  | (\ \) (_____  )]],
      [[| | \   | |   | |  | |  | (\ (  | |   | | |   ) | (   ) | | \   |     ) |]],
      [[| )  \  | (___) |  | |  | ) \ \_| (___) | (__/  | )   ( | )  \  /\____) |]],
      [[|/    )_(_______)  )_(  |/   \__(_______(______/|/     \|/    )_\_______)]],
			[[                                                                         ]]
    },
  },
}
