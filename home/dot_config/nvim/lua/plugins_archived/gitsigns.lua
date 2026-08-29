return {
	enabled = false,
	"lewis6991/gitsigns.nvim",
	event = "User FilePost",
	opts = function(opts)
		dofile(vim.g.base46_cache .. "git")

		opts.signs = {
			delete = { text = "󰍵" },
			changedelete = { text = "󱕖" },
		}

		local gitsigns = require("gitsigns")
		local map = vim.keymap.set

		map("n", "]h", function()
			gitsigns.nav_hunk("next")
		end, { desc = "Git next hunk" })

		map("n", "[h", function()
			gitsigns.nav_hunk("prev")
		end, { desc = "Git previous hunk" })

		map("n", "<leader>gp", function()
			gitsigns.preview_hunk()
		end, { desc = "Git preview hunk" })

		map("n", "<leader>gd", function()
			gitsigns.diffthis()
		end, { desc = "Git diffthis" })
	end,
}
