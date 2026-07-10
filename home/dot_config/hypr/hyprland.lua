---@module 'hl'

-- Sourcing external config files

-- User Configs

local home = os.getenv("HOME")
local configs = home .. "/.config/hypr/configs"

dofile(configs .. "/env-variables.lua")
dofile(configs .. "/window-rules.lua")
dofile(configs .. "/monitors.lua")
dofile(configs .. "/user-settings.lua")
dofile(configs .. "/user-keybinds.lua")
dofile(configs .. "/startup-apps.lua")

-- Autostart
hl.on("hyprland.start", function()
	hl.exec_cmd(home .. "/.config/hypr/initial-boot.sh")
end)
