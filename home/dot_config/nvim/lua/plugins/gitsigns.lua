return {
	"lewis6991/gitsigns.nvim",
	event = "User FilePost",
	opts = function(opts)
		dofile(vim.g.base46_cache .. "git")

		opts.signs = {
			delete = { text = "󰍵" },
			changedelete = { text = "󱕖" },
		}

		local gitsigns = require("gitsigns")

		vim.keymap.set("n", "<leader>gd", function()
			gitsigns.diffthis()
		end, { desc = "Git diffthis" })
	end,
}
