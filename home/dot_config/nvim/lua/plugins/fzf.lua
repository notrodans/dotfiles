return {
	"ibhagwan/fzf-lua",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		local fzf = require("fzf-lua")
		local actions = fzf.actions

		fzf.register_ui_select()

		vim.keymap.set("n", "<leader>fq", function()
			fzf.quickfix_stack()
		end, { desc = "Fzf find quickfix stacks" })

		vim.keymap.set("n", "<leader>fr", function()
			fzf.resume()
		end, { desc = "Fzf resume previous picker" })

		vim.keymap.set("n", "<leader>fg", function()
			fzf.live_grep()
		end, { desc = "Fzf live grep" })

		vim.keymap.set("n", "<leader>fb", function()
			fzf.buffers()
		end, { desc = "Fzf find buffers" })

		vim.keymap.set("n", "<leader>fh", function()
			fzf.helptags()
		end, { desc = "Fzf find help pages" })

		vim.keymap.set("n", "<leader>ma", function()
			fzf.marks()
		end, { desc = "Fzf find marks" })

		vim.keymap.set("n", "<leader>ff", function()
			fzf.files()
		end, { desc = "Fzf find files" })

		vim.keymap.set("n", "<leader>fo", function()
			fzf.oldfiles()
		end, { desc = "Fzf find oldfiles" })

		vim.keymap.set("n", "<leader>fz", function()
			fzf.grep_curbuf()
		end, { desc = "Fzf find in current buffer" })

		vim.keymap.set("n", "<leader>fk", function()
			fzf.keymaps()
		end, { desc = "Fzf find keymaps" })

		vim.keymap.set({ "n", "v" }, "<leader>fw", function()
			fzf.grep_cword()
		end, { desc = "Fzf find current word" })

		vim.keymap.set({ "n", "v" }, "<leader>fW", function()
			fzf.grep_cWORD()
		end, { desc = "Fzf find current WORD" })

		vim.keymap.set({ "n", "v" }, "<leader>fi", function()
			fzf.lsp_implementations()
		end, { desc = "Fzf find lsp implementations" })

		vim.keymap.set({ "n", "v" }, "<leader>fd", function()
			fzf.lsp_definitions()
		end, { desc = "Fzf find lsp definitions" })

		vim.keymap.set("n", "<leader>ft", "<cmd>TodoFzfLua<CR>", { desc = "Fzf find todo comments" })

		-- diagnostics
		vim.keymap.set("n", "<leader>dd", function()
			fzf.diagnostics_document()
		end, { desc = "LSP diagnostics document" })

		vim.keymap.set("n", "<leader>dw", function()
			fzf.diagnostics_workspace()
		end, { desc = "LSP diagnostics workspace" })

		-- git
		vim.keymap.set("n", "<leader>gbb", function()
			fzf.git_branches()
		end, { desc = "Fzf git branches" })

		vim.keymap.set("n", "<leader>gbc", function()
			fzf.git_bcommits()
		end, { desc = "Fzf git branch commits" })

		vim.keymap.set("n", "<leader>gc", function()
			fzf.git_commits()
		end, { desc = "Fzf git commits" })

		vim.keymap.set("n", "<leader>gs", function()
			fzf.git_status()
		end, { desc = "Fzf git status" })

		-- lsp
		vim.keymap.set({ "n", "x" }, "gra", function()
			fzf.lsp_code_actions({ silent = true })
		end, { desc = "LSP code actions", noremap = true, silent = true })

		vim.keymap.set("n", "<leader>flr", function()
			fzf.lsp_references()
		end, { desc = "Fzf lsp references" })

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
		}
	end,
}
