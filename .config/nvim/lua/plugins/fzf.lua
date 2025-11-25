return {
	"ibhagwan/fzf-lua",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		local fzf = require("fzf-lua")
		local actions = fzf.actions

		fzf.register_ui_select()

		return {
			"ivy",
			winopts = {
				fullscreen = true,
			},
			fzf_colors = true,
			keymap = {
				builtin = {
					true,
					["<C-u>"] = "preview-page-up",
					["<C-d>"] = "preview-page-down",
				},
				fzf = {
					true,
					["ctrl-u"] = "preview-page-up",
					["ctrl-d"] = "preview-page-down",
					["ctrl-q"] = "select-all+accept",
				},
			},
			actions = {
				files = {
					["enter"] = actions.file_edit_or_qf,
					["ctrl-x"] = actions.file_split,
					["ctrl-v"] = actions.file_vsplit,
					["ctrl-t"] = actions.file_tabedit,
					["alt-q"] = actions.file_sel_to_qf,
				},
			},
			buffers = {
				keymap = {
					builtin = {
						["<C-d>"] = false,
					},
				},
				actions = {
					files = {
						["ctrl-x"] = false,
						["ctrl-d"] = {
							actions.buf_del,
							actions.rename,
						},
					},
				},
			},
			default = {
				git_icons = false,
			},
			lsp = {
				code_actions = {
					prompt = "Code Actions> ",
					async_or_timeout = 5000,
					previewer = "codeaction",
				},
			},
		}
	end,
}
