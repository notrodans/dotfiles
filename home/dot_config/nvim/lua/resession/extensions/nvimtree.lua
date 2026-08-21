local api = vim.api

local M = {}

local function tree()
	return require("nvim-tree.api")
end

local function root()
	local ok, core = pcall(require, "nvim-tree.core")

	if ok and core.get_cwd then
		return core.get_cwd()
	end

	local nodes = tree().tree.get_nodes()
	local first = nodes[1]

	if first and first.absolute_path then
		return vim.fs.dirname(first.absolute_path)
	end

	return vim.fn.getcwd(-1, -1)
end

local function normalize_local_cwd(winid)
	api.nvim_win_call(winid, function()
		if vim.fn.haslocaldir() == 1 then
			local cwd = vim.fn.getcwd(-1, -1)
			vim.cmd("lcd " .. vim.fn.fnameescape(cwd))
		end
	end)
end

local function collect_open(nodes, result)
	for _, node in ipairs(nodes or {}) do
		if node.open and node.absolute_path then
			result[#result + 1] = node.absolute_path
		end

		if node.nodes then
			collect_open(node.nodes, result)
		end
	end
end

local function restore_open(paths)
	local nvimtree = tree()
	local ordered = vim.deepcopy(paths or {})

	table.sort(ordered, function(left, right)
		return #left < #right
	end)

	for _, path in ipairs(ordered) do
		nvimtree.tree.find_file({
			buf = path,
			update_root = false,
		})

		local node = nvimtree.tree.get_node_under_cursor()
		local real = vim.uv.fs_realpath(path) or path

		if node and node.absolute_path == real and node.open == false then
			nvimtree.node.open.edit(node, { focus = true })
		end
	end
end

local function resize_width(winid, width)
	if api.nvim_win_resize then
		pcall(api.nvim_win_resize, winid, width, -1, { anchor = "right" })
		return
	end

	pcall(api.nvim_win_set_width, winid, width)
end

local function restore_view(winid, state)
	if not api.nvim_win_is_valid(winid) then
		return
	end

	api.nvim_win_call(winid, function()
		local nvimtree = tree()

		if state.selected then
			nvimtree.tree.find_file({
				buf = state.selected,
				update_root = false,
			})
		end

		if state.view then
			local view = vim.fn.winsaveview()

			for _, key in ipairs({
				"col",
				"coladd",
				"curswant",
				"leftcol",
				"skipcol",
				"topfill",
				"topline",
			}) do
				if state.view[key] ~= nil then
					view[key] = state.view[key]
				end
			end

			vim.fn.winrestview(view)
		end
	end)

	if state.width then
		resize_width(winid, state.width)
	end
end

M.is_win_supported = function(_, bufnr)
	return vim.bo[bufnr].filetype == "NvimTree"
end

M.save_win = function(winid)
	local nvimtree = tree()
	local selected
	local view

	api.nvim_win_call(winid, function()
		local node = nvimtree.tree.get_node_under_cursor()

		selected = node and node.absolute_path or nil
		view = vim.fn.winsaveview()
	end)

	local expanded = {}
	collect_open(nvimtree.tree.get_nodes(), expanded)

	return {
		expanded = expanded,
		root = root(),
		selected = selected,
		view = view,
		width = api.nvim_win_get_width(winid),
	}
end

M.load_win = function(winid, state)
	api.nvim_set_current_win(winid)

	local nvimtree = tree()

	nvimtree.tree.open({
		current_window = true,
		path = state.root,
	})

	local tree_win = nvimtree.tree.winid({
		tabpage = api.nvim_get_current_tabpage(),
	}) or api.nvim_get_current_win()

	api.nvim_set_current_win(tree_win)
	normalize_local_cwd(tree_win)
	restore_open(state.expanded)

	vim.schedule(function()
		restore_view(tree_win, state)
	end)

	return tree_win
end

return M
