return {
	"vuki656/package-info.nvim",
	ft = { "json" },
	dependencies = { "MunifTanjim/nui.nvim" },
	config = function()
		local package_info = require("package-info")
		vim.keymap.set("n", "<leader>ps", function()
			package_info.show()
		end, { desc = "Display latest package version" })

		vim.keymap.set("n", "<leader>pp", function()
			package_info.change_version()
		end, { desc = "Install different version" })

		vim.keymap.set("n", "<leader>pu", function()
			package_info.update()
		end, { desc = "Update package to latest version" })

		print(vim.g.package_manager)
		package_info.setup({
			package_manager = vim.g.package_manager or "npm",
		})
	end,
}
