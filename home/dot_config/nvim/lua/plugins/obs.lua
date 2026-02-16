return {
	"obsidian-nvim/obsidian.nvim",
	version = "*",
	ft = "markdown",
	lazy = true,
	cmd = "Obsidian",
	---@module 'obsidian'
	config = function()
		local obsidian = require("obsidian")
		obsidian.setup({
			legacy_commands = false, -- this will be removed in the next major release
			workspaces = {
				{
					name = "person",
					path = "~/obsidian-vault",
				},
			},
			attachments = {
				folder = "/System/Attachments",
			},
			templates = {
				folder = "/System/Templates",
				date_format = "%Y-%m-%d-%a",
				time_format = "%H:%M",
			},
		})

		vim.keymap.set("n", "<leader>Ot", ":Obsidian tags<CR>", { desc = "Obsidian find notes by tag" })
		vim.keymap.set("n", "<leader>Og", ":Obsidian search<CR>", { desc = "Obsidian grep" })
		vim.keymap.set("n", "<leader>Oi", ":Obsidian paste_img<CR>", { desc = "Obsidian paste_image" })
	end,
}
