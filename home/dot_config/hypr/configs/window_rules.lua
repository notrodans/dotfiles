---@module 'hl'

hl.window_rule({
	match = {
		class = "^(steam_app_.*)$",
	},
	tag = "-shader_active",
})

hl.window_rule({
	match = {
		class = "^(mpv)$",
	},
	tag = "-shader_active",
})
