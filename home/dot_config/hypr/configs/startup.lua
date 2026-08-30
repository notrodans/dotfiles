-- -@module 'hl'

-- Autostart
hl.on("hyprland.start", function()
	hl.exec_cmd("hyprctl setcursor Adwaita 24")
	hl.exec_cmd("hyprpm reload -n")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user daemon-reload")
	hl.exec_cmd("systemctl --user start hyprland-session.target")
end)

hl.on("hyprland.shutdown", function()
	hl.exec_cmd("systemctl --user stop hyprland-session.target")
end)
