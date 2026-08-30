dofile(vim.g.base46_cache .. "nvimtree")

local fsd_order = {
	app = 1,
	pages = 2,
	screens = 2,
	widgets = 3,
	features = 4,
	entities = 5,
	shared = 6,
}

local function sort_key(node)
	local directory = node.type == "directory"
	local mtime

	if node.fs_stat and node.fs_stat.mtime then
		mtime = node.fs_stat.mtime.sec or node.fs_stat.mtime
	end

	return {
		directory = directory,
		priority = directory and fsd_order[node.name] or nil,
		number = tonumber(node.name:match("^%d+")),
		mtime = mtime,
		length = #node.name,
		name = node.name:lower(),
	}
end

local sorter = function(nodes)
	local keys = {}

	for _, node in ipairs(nodes) do
		keys[node] = sort_key(node)
	end

	table.sort(nodes, function(a, b)
		local a_key = keys[a]
		local b_key = keys[b]

		if a_key.directory ~= b_key.directory then
			return a_key.directory
		end

		if a_key.directory then
			if a_key.priority and b_key.priority then
				if a_key.priority ~= b_key.priority then
					return a_key.priority < b_key.priority
				end
			elseif a_key.priority or b_key.priority then
				return a_key.priority ~= nil
			end
		end

		if a_key.number and b_key.number then
			if a_key.number ~= b_key.number then
				return a_key.number < b_key.number
			end
		elseif a_key.number then
			return true
		elseif b_key.number then
			return false
		end

		if a_key.mtime and b_key.mtime and a_key.mtime ~= b_key.mtime then
			return a_key.mtime > b_key.mtime
		end

		if a_key.directory and a_key.length ~= b_key.length then
			return a_key.length < b_key.length
		end

		return a_key.name < b_key.name
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
		highlight_git = false,
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
			},
		},
	},
	git = {
		enable = false,
	},
	diagnostics = {
		enable = true,
	},
	sort = {
		sorter = sorter,
	},
}
