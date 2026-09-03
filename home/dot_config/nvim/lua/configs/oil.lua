return {
	default_file_explorer = true,
	columns = { "icon" },
	watch_for_changes = true,
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = false,
	},
	keymaps = {
		["<C-s>"] = false,
		["<C-h>"] = false,
		["<C-l>"] = false,
		["<CR>"] = function()
			require("modules.oil").select()
		end,
		["<C-v>"] = function()
			require("modules.oil").select("vertical")
		end,
		["<C-x>"] = function()
			require("modules.oil").select("horizontal")
		end,
		["<C-t>"] = function()
			require("modules.oil").select("tab")
		end,
		["R"] = "actions.refresh",
	},
	view_options = {
		show_hidden = false,
		natural_order = true,
		case_insensitive = true,
		sort = {
			{ "type", "asc" },
			{ "name", "asc" },
		},
	},
}
