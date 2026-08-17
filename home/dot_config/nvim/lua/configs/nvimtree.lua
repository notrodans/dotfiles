dofile(vim.g.base46_cache .. "nvimtree")

local sorter = function(nodes)
	local fsd_order = {
		app = 1,
		pages = 2,
		screens = 2,
		widgets = 3,
		features = 4,
		entities = 5,
		shared = 6,
	}

	local function get_num(name)
		return tonumber(name:match("^%d+"))
	end

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
				if a_prio ~= b_prio then
					return a_prio < b_prio
				end
			elseif a_prio or b_prio then
				return a_prio ~= nil
			end
		end

		local a_num = get_num(a.name)
		local b_num = get_num(b.name)

		if a_num and b_num then
			if a_num ~= b_num then
				return a_num < b_num
			end
		elseif a_num then
			return true
		elseif b_num then
			return false
		end

		if a.fs_stat and b.fs_stat and a.fs_stat.mtime and b.fs_stat.mtime then
			local a_time = a.fs_stat.mtime.sec or a.fs_stat.mtime
			local b_time = b.fs_stat.mtime.sec or b.fs_stat.mtime

			if a_time ~= b_time then
				return a_time > b_time
			end
		end

		if a.type == "directory" and b.type == "directory" then
			if #a.name ~= #b.name then
				return #a.name < #b.name
			end
		end

		return a.name:lower() < b.name:lower()
	end)
end

return {
	filters = { dotfiles = true },
	disable_netrw = false,
	hijack_cursor = true,
	sync_root_with_cwd = false,
	actions = {
		change_dir = {
			enable = false,
		},
	},
	update_focused_file = {
		enable = false,
		update_root = false,
	},
	view = {
		centralize_selection = false,
		side = "right",
		width = {
			min = 40,
			padding = 0,
		},
		preserve_window_proportions = true,
	},
	renderer = {
		-- LITERALLY FOR JAVA
		group_empty = true,
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
		sorter = sorter,
	},
}
