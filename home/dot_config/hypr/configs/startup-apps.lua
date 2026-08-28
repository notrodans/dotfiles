-- -@module 'hl'

local home = os.getenv("HOME")
local coreScripts = home .. "/.config/hypr/core/scripts"

-- Autostart
hl.on("hyprland.start", function()
	hl.exec_cmd("hyprctl setcursor Adwaita 24")
	hl.exec_cmd("hyprpm reload -n")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user daemon-reload")
	hl.exec_cmd("systemctl --user start hyprland-session.target")
	hl.exec_cmd(coreScripts .. "/Polkit.sh")
end)
