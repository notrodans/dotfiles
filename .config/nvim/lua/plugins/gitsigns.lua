return {
	"lewis6991/gitsigns.nvim",
	event = "User FilePost",
	opts = function()
		require("configs.gitsigns")

		local gitsigns = require("gitsigns")

		vim.keymap.set("n", "<leader>gd", function()
			gitsigns.diffthis()
		end, { desc = "Git diffthis" })
	end,
}
