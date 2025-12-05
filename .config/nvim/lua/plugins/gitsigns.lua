return {
	"lewis6991/gitsigns.nvim",
	event = "User FilePost",
	opts = function()
		local gitsigns = require("gitsigns")

		vim.keymap.set("n", "<leader>gd", function()
			gitsigns.diffthis()
		end, { desc = "Git diffthis" })

		return require("nvchad.configs.gitsigns")
	end,
}
