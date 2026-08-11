---@module 'hl'

local hy3 = hl.plugin.hy3

if hy3 == nil then
	return
end

hl.config({
	general = {
		layout = "hy3",
	},

	plugin = {
		hy3 = {
			node_collapse_policy = 2,
			group_inset = 10,
			tab_first_window = false,

			tabs = {
				height = 22,
				padding = 6,
				from_top = false,
				radius = 6,
				border_width = 2,

				render_text = true,
				text_center = true,
				text_font = "IBM Plex Sans Medium",
				text_height = 8,
				text_padding = 3,

				colors = {
					active = "rgba(00000040)",
					active_border = "rgba(606060aa)",
					active_text = "rgba(ffffffff)",

					active_alt_monitor = "rgba(60606040)",
					active_alt_monitor_border = "rgba(808080ee)",
					active_alt_monitor_text = "rgba(ffffffff)",

					focused = "rgba(60606040)",
					focused_border = "rgba(808080ee)",
					focused_text = "rgba(ffffffff)",

					inactive = "rgba(30303020)",
					inactive_border = "rgba(333333ee)",
					inactive_text = "rgba(ffffffff)",

					urgent = "rgba(ff223340)",
					urgent_border = "rgba(ff2233ee)",
					urgent_text = "rgba(ffffffff)",

					locked = "rgba(90903340)",
					locked_border = "rgba(909033ee)",
					locked_text = "rgba(ffffffff)",
				},

				blur = true,
				opacity = 1.0,
			},

			autotile = {
				enable = true,
				ephemeral_groups = true,
				trigger_width = 0,
				trigger_height = 0,
				workspaces = "all",
			},
		},
	},
})

local mod = "SUPER"

-- Create groups.
hl.bind(mod .. " + ALT + H", hy3.make_group("h"))
hl.bind(mod .. " + ALT + V", hy3.make_group("v"))
hl.bind(mod .. " + ALT + O", hy3.make_group("opposite"))

-- Change the layout of the current group.
hl.bind(mod .. " + CTRL + T", hy3.change_group("toggletab"))
hl.bind(mod .. " + CTRL + H", hy3.change_group("h"))
hl.bind(mod .. " + CTRL + V", hy3.change_group("v"))
hl.bind(mod .. " + CTRL + O", hy3.change_group("opposite"))

-- Move focus through the hy3 tree.
hl.bind(mod .. " + H", hy3.move_focus("l"))
hl.bind(mod .. " + J", hy3.move_focus("d"))
hl.bind(mod .. " + K", hy3.move_focus("u"))
hl.bind(mod .. " + L", hy3.move_focus("r"))

-- Move nodes through the hy3 tree.
hl.bind(mod .. " + CTRL + left", hy3.move_window("l"))
hl.bind(mod .. " + CTRL + right", hy3.move_window("r"))
hl.bind(mod .. " + CTRL + up", hy3.move_window("u"))
hl.bind(mod .. " + CTRL + down", hy3.move_window("d"))
