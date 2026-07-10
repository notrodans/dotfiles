---@module 'hl'

-- fonts
hl.env("FREETYPE_PROPERTIES", "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0")

-- Toolkit Backend Variables
hl.env("GDK_BACKEND", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- xdg Specifications
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

-- QT Variables
-- env = QT_AUTO_SCREEN_SCALE_FACTOR,1

hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", 1)
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- hyprland-qt-support
hl.env("QT_QUICK_CONTROLS_STYLE", "org.hyprland.style")

-- xwayland apps scale fix (useful if you are use monitor scaling).
-- Set same value if you use scaling in Monitors.conf
-- 1 is 100% 1.5 is 150%
-- see https://wiki.hyprland.org/Configuring/XWayland/
-- env = GDK_SCALE,1
-- env = QT_SCALE_FACTOR,1

hl.env("LIBVA_DRIVER_NAME", "radeonsi")
-- firefox
hl.env("MOZ_ENABLE_WAYLAND", 1)
