---@module 'hl'

hl.config({
	master = {
		new_on_top = true,
		mfact = 0.5,
	},
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,
		resize_on_border = true,
		extend_border_grab_area = 1,
		allow_tearing = true,
		layout = "master",
		col = {
			active_border = "rgba(60606040)",
			inactive_border = "rgb(000000)",
		},
	},
	decoration = {
		rounding = 5,
		active_opacity = 1.0,
		fullscreen_opacity = 1.0,
		dim_inactive = false,
		dim_strength = 0,
		screen_shader = "./shaders/vibrance.glsl.mustache",
		shadow = {
			enabled = false,
		},
		blur = {
			enabled = true,
		},
	},
	animations = {
		enabled = false,
	},
	input = {
		kb_layout = "us,ru",
		kb_options = "grp:alt_shift_toggle,compose:rctrl,ctrl:swapcaps",
		follow_mouse = 1,
		float_switch_override_focus = 0,
		repeat_rate = 25,
		repeat_delay = 120,
		numlock_by_default = false,
		accel_profile = "flat",
		force_no_accel = false,
		sensitivity = 0,
		scroll_method = "on_button_down",
		scroll_factor = 1,
		focus_on_close = 0,
		mouse_refocus = false,
		touchpad = {
			disable_while_typing = true,
			scroll_factor = 2,
		},
	},
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		mouse_move_enables_dpms = true,
		enable_swallow = true,
		focus_on_activate = true,
		swallow_regex = "^(kitty)$",
		font_family = "IBM Plex Sans",
	},
	cursor = {
		no_warps = true,
		sync_gsettings_theme = true,
		no_hardware_cursors = 2,
		enable_hyprcursor = true,
	},
	ecosystem = {
		no_donation_nag = true,
		no_update_news = false,
	},
	xwayland = {
		force_zero_scaling = true,
	},
})
