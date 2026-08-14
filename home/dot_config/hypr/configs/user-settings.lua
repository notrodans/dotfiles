---@module 'hl'

hl.config({
	master = {
		new_on_top = 1,
		mfact = 0.5,
	},
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,
		resize_on_border = 1,
		extend_border_grab_area = 1,
		allow_tearing = 1,
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
		dim_inactive = 0,
		dim_strength = 0,
		screen_shader = "./shaders/vibrance.glsl.mustache",
		shadow = {
			enabled = 0,
		},
		blur = {
			enabled = 1,
		},
	},
	animations = {
		enabled = 0,
	},
	input = {
		kb_layout = "us,ru",
		kb_options = "grp:alt_shift_toggle,compose:rctrl,ctrl:swapcaps",
		follow_mouse = 1,
		float_switch_override_focus = 0,
		repeat_rate = 25,
		repeat_delay = 150,
		numlock_by_default = 0,
		accel_profile = "flat",
		force_no_accel = 0,
		sensitivity = 0,
		scroll_method = "on_button_down",
		scroll_factor = 1,
		focus_on_close = 0,
		mouse_refocus = 0,
		touchpad = {
			disable_while_typing = 1,
			scroll_factor = 2,
		},
	},
	misc = {
		disable_hyprland_logo = 1,
		disable_splash_rendering = 1,
		mouse_move_enables_dpms = 1,
		enable_swallow = 1,
		focus_on_activate = 1,
		swallow_regex = "^(kitty)$",
		font_family = "IBM Plex Sans",
	},
	cursor = {
		no_warps = 1,
		sync_gsettings_theme = 1,
		no_hardware_cursors = 2,
		enable_hyprcursor = 1,
	},
	ecosystem = {
		no_donation_nag = 1,
		no_update_news = 0,
	},
	xwayland = {
		force_zero_scaling = 1,
	},
})
