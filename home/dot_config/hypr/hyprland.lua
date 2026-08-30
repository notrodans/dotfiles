---@module 'hl'
-- Sourcing external config files

-- User Configs

local home = os.getenv("HOME")
local configs = home .. "/.config/hypr/configs"
local plugins = home .. "/.config/hypr/plugins"

dofile(configs .. "/env.lua")
dofile(configs .. "/window_rules.lua")
dofile(configs .. "/monitors.lua")
dofile(configs .. "/settings.lua")
dofile(configs .. "/keybinds.lua")
dofile(configs .. "/startup.lua")
dofile(plugins .. "/hy3.lua")

-- Autostart
hl.on("hyprland.start", function()
	hl.exec_cmd(home .. "/.config/hypr/initial-boot.sh")
end)
