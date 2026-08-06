---@module 'hl'

--Commands & Apps to be executed at launch

local home = os.getenv("HOME")
local coreScripts = home .. "/.config/hypr/core/scripts"

local UserScripts = home .. "/.config/hypr/scripts"

local wallDIR = home .. "/Pictures/wallpapers"

-- plugin manager

-- wallpaper stuff / More wallpaper options below

-- Startup

-- Polkit (Polkit Gnome / KDE)

-- starup apps

-- exec-once = waybar &

--exec-once = blueman-applet &

--exec-once = rog-control-center &

--clipboard manager

-- sway-idle with lock only

-- exec-once = swayidle -w timeout 900 '$lock'

-- sway-idle with lock and sleep

--exec-once = swayidle -w timeout 900 '$lock' timeout 1200 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep '$lock'

-- sway idle without lock

--exec-once = swayidle -w  timeout 900 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'

-- xdg-desktop-portal-hyprland (should be auto starting. However, you can force to start)

-- exec-once = $coreScripts/PortalHyprland.sh

-- Autostart
hl.on("hyprland.start", function()
	hl.exec_cmd("hyprctl setcursor pixelfun 24")
	hl.exec_cmd("hyprpm reload -n")
	hl.exec_cmd("awww-daemon &")
	hl.exec_cmd("awww query && awww restore")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user start hyprland-session.target")
	hl.exec_cmd(coreScripts .. "/Polkit.sh")
	hl.exec_cmd("nm-applet --indicator &")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
