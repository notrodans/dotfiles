dofile(vim.g.base46_cache .. "nvimtree")

local fsd_folder_length_sorter = function(nodes)
	local fsd_order = {
		app = 1,
		pages = 2,
		screens = 2,
		widgets = 3,
		features = 4,
		entities = 5,
		shared = 6,
	}

	table.sort(nodes, function(a, b)
		if a.type == "directory" and b.type ~= "directory" then
			return true
		end
		if a.type ~= "directory" and b.type == "directory" then
			return false
		end

		if a.type == "directory" and b.type == "directory" then
			local a_prio = fsd_order[a.name]
			local b_prio = fsd_order[b.name]

			if a_prio and b_prio then
				return a_prio < b_prio
			end

			if a_prio or b_prio then
				return a_prio ~= nil
			end

			return #a.name < #b.name
		end

		return a.name:lower() < b.name:lower()
	end)
end

return {
	filters = { dotfiles = true },
	disable_netrw = false,
	hijack_cursor = true,
	sync_root_with_cwd = true,
	update_focused_file = {
		enable = true,
		update_root = false,
	},
	view = {
		centralize_selection = true,
		side = "right",
		width = {
			min = 40,
			padding = 0,
		},
		preserve_window_proportions = true,
	},
	renderer = {
		-- LITERALLY FOR JAVA
		group_empty = false,
		--
		root_folder_label = false,
		add_trailing = false,
		highlight_git = true,
		indent_width = 1,
		indent_markers = { enable = false },
		icons = {
			glyphs = {
				default = "󰈚",
				folder = {
					default = "",
					empty = "",
					empty_open = "",
					open = "",
					symlink = "",
				},
				git = { unmerged = "" },
			},
		},
	},
	git = {
		show_on_dirs = false,
	},
	diagnostics = {
		enable = true,
	},
	sort = {
		sorter = fsd_folder_length_sorter,
	},
}
