---@module 'hl'

local mainMod = "SUPER"
local files = "pcmanfm"
local term = "kitty"
local home = os.getenv("HOME")
local coreScripts = home .. "/.config/hypr/core/scripts"
local userScripts = home .. "/.config/hypr/scripts"

-- rofi App launcher

hl.bind(
	mainMod .. " + " .. mainMod .. "_L",
	hl.dsp.exec_cmd("pkill rofi || rofi -show drun -modi drun,filebrowser,run,window"),
	{ repeating = true }
)

hl.bind(mainMod .. " + " .. "D", hl.dsp.exec_cmd("pkill rofi || rofi -show drun -modi drun,filebrowser,run,window"))

hl.bind(mainMod .. " + " .. "Return", hl.dsp.exec_cmd(term))

-- Launch terminal

hl.bind(mainMod .. " + " .. "T", hl.dsp.exec_cmd(files))

-- hl.bind("CTRL + ALT" .. " + " .. "Delete", hl.dispatch(exit))

hl.bind(mainMod .. " + " .. "Q", hl.dsp.window.close())

hl.bind(mainMod .. " + " .. "F", hl.dsp.window.fullscreen({ action = "toggle" }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "Q", hl.dsp.window.close())

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "Space", hl.dsp.window.float())

-- bind = $mainMod ALT, F, exec, hyprctl dispatch workspaceopt allfloat

-- FEATURES / EXTRAS

hl.bind(mainMod .. " + " .. "ALT" .. " + " .. "R", hl.dsp.exec_cmd(coreScripts .. "/Refresh.sh"))

-- Refresh waybar, rofi

-- FEATURES / EXTRAS (UserScripts)

hl.bind(mainMod .. " + " .. "W", hl.dsp.exec_cmd(userScripts .. "/WallpaperSelect.sh"))

-- Select wallpaper to apply

-- Waybar / Bar related

hl.bind(mainMod .. " + " .. "B", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))

-- Toggle hide/show waybar

-- Master Layout

hl.bind(mainMod .. " + " .. "CTRL" .. " + " .. "D", hl.dsp.layout("removemaster"))

hl.bind(mainMod .. " + " .. "I", hl.dsp.layout("addmaster"))

hl.bind(mainMod .. " + " .. "J", hl.dsp.layout("cyclenext"))

hl.bind(mainMod .. " + " .. "K", hl.dsp.layout("cycleprev"))

hl.bind(mainMod .. " + " .. "M", hl.dsp.exec_cmd("hyprctl dispatch splitratio 0.3"))

hl.bind(mainMod .. " + " .. "P", hl.dsp.window.pseudo())

-- dwindle

hl.bind(mainMod .. " + " .. "CTRL" .. " + " .. "Return", hl.dsp.layout("swapwithmaster"))

-- Special Keys / Hot Keys

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(coreScripts .. "/Volume.sh --inc"))

--volume up

hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(coreScripts .. "/Volume.sh --dec"))

--volume down

hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(coreScripts .. "/Volume.sh --toggle-mic"))

--mute mic

hl.bind("XF86AudioMute", hl.dsp.exec_cmd(coreScripts .. "/Volume.sh --toggle"))

hl.bind("XF86Sleep", hl.dsp.exec_cmd("systemctl suspend"))

-- sleep button

hl.bind("xf86Rfkill", hl.dsp.exec_cmd(coreScripts .. "/AirplaneMode.sh"))

--Airplane mode

-- brightness

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s +10%"))

-- Screenshot keybindings

hl.bind(mainMod .. " + " .. "Print", hl.dsp.exec_cmd(coreScripts .. "/ScreenShot.sh --now"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "Print", hl.dsp.exec_cmd(coreScripts .. "/ScreenShot.sh --area"))

hl.bind("ALT" .. " + " .. "Print", hl.dsp.exec_cmd(coreScripts .. "/ScreenShot.sh --active"))

--screenshot in 10 secs

-- screenshot with swappy (another screenshot tool)

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "S", hl.dsp.exec_cmd(coreScripts .. "/ScreenShot.sh --swappy"))

-- Move windows

hl.bind(mainMod .. " + " .. "CTRL" .. " + " .. "left", hl.dsp.window.move({ direction = "l" }))

hl.bind(mainMod .. " + " .. "CTRL" .. " + " .. "right", hl.dsp.window.move({ direction = "r" }))

hl.bind(mainMod .. " + " .. "CTRL" .. " + " .. "up", hl.dsp.window.move({ direction = "u" }))

hl.bind(mainMod .. " + " .. "CTRL" .. " + " .. "down", hl.dsp.window.move({ direction = "d" }))

-- Workspaces related

hl.bind(mainMod .. " + " .. "tab", hl.dsp.focus({ workspace = "m+1" }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "tab", hl.dsp.focus({ workspace = "m-1" }))

-- The following mappings use the key codes to better support various keyboard layouts

-- 1 is code:10, 2 is code 11, etc

-- Switch workspaces with mainMod + [0-9]

hl.bind(mainMod .. " + " .. "code:10", hl.dsp.focus({ workspace = 1 }))

hl.bind(mainMod .. " + " .. "code:11", hl.dsp.focus({ workspace = 2 }))

hl.bind(mainMod .. " + " .. "code:12", hl.dsp.focus({ workspace = 3 }))

hl.bind(mainMod .. " + " .. "code:13", hl.dsp.focus({ workspace = 4 }))

hl.bind(mainMod .. " + " .. "code:14", hl.dsp.focus({ workspace = 5 }))

hl.bind(mainMod .. " + " .. "code:15", hl.dsp.focus({ workspace = 6 }))

hl.bind(mainMod .. " + " .. "code:16", hl.dsp.focus({ workspace = 7 }))

hl.bind(mainMod .. " + " .. "code:17", hl.dsp.focus({ workspace = 8 }))

hl.bind(mainMod .. " + " .. "code:18", hl.dsp.focus({ workspace = 9 }))

hl.bind(mainMod .. " + " .. "code:19", hl.dsp.focus({ workspace = 10 }))

-- Move active window and follow to workspace mainMod + SHIFT [0-9]

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "code:10", hl.dsp.window.move({ workspace = 1 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "code:11", hl.dsp.window.move({ workspace = 2 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "code:12", hl.dsp.window.move({ workspace = 3 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "code:13", hl.dsp.window.move({ workspace = 4 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "code:14", hl.dsp.window.move({ workspace = 5 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "code:15", hl.dsp.window.move({ workspace = 6 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "code:16", hl.dsp.window.move({ workspace = 7 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "code:17", hl.dsp.window.move({ workspace = 8 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "code:18", hl.dsp.window.move({ workspace = 9 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "code:19", hl.dsp.window.move({ workspace = 10 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "bracketleft", hl.dsp.window.move({ workspace = "-1" }))

-- brackets [ or ]

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "bracketright", hl.dsp.window.move({ workspace = "+1" }))

-- Move active window to a workspace silently mainMod + CTRL [0-9]

hl.bind(mainMod .. " + " .. "CTRL" .. " + " .. "code:10", hl.dsp.window.move({ workspace = 1 }, { follow = false }))

hl.bind(mainMod .. " + " .. "CTRL" .. " + " .. "code:11", hl.dsp.window.move({ workspace = 2 }, { follow = false }))

hl.bind(mainMod .. " + " .. "CTRL" .. " + " .. "code:12", hl.dsp.window.move({ workspace = 3 }, { follow = false }))

hl.bind(mainMod .. " + " .. "CTRL" .. " + " .. "code:13", hl.dsp.window.move({ workspace = 4 }, { follow = false }))

hl.bind(mainMod .. " + " .. "CTRL" .. " + " .. "code:14", hl.dsp.window.move({ workspace = 5 }, { follow = false }))

hl.bind(mainMod .. " + " .. "CTRL" .. " + " .. "code:15", hl.dsp.window.move({ workspace = 6 }, { follow = false }))

hl.bind(mainMod .. " + " .. "CTRL" .. " + " .. "code:16", hl.dsp.window.move({ workspace = 7 }, { follow = false }))

hl.bind(mainMod .. " + " .. "CTRL" .. " + " .. "code:17", hl.dsp.window.move({ workspace = 8 }, { follow = false }))

hl.bind(mainMod .. " + " .. "CTRL" .. " + " .. "code:18", hl.dsp.window.move({ workspace = 9 }, { follow = false }))

hl.bind(mainMod .. " + " .. "CTRL" .. " + " .. "code:19", hl.dsp.window.move({ workspace = 10 }, { follow = false }))

hl.bind(
	mainMod .. " + " .. "CTRL" .. " + " .. "bracketleft",
	hl.dsp.window.move({ workspace = "-1" }, { follow = false })
)

-- brackets [ or ]

hl.bind(
	mainMod .. " + " .. "CTRL" .. " + " .. "bracketright",
	hl.dsp.window.move({ workspace = "+1" }, { follow = false })
)

-- Move/resize windows with mainMod + LMB/RMB and dragging

hl.bind(mainMod .. " + " .. "mouse:272", hl.dsp.window.drag(), { mouse = true })

hl.bind(mainMod .. " + " .. "mouse:273", hl.dsp.window.resize(), { mouse = true })
