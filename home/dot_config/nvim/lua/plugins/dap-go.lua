local function attach()
	require("dap").run({
		type = "go",
		name = "Attach to Go process",
		request = "attach",
		mode = "local",
		processId = require("dap.utils").pick_process,
	})
end

return {
	"leoluz/nvim-dap-go",

	ft = "go",

	dependencies = {
		"mfussenegger/nvim-dap",
	},

	keys = {
		{
			"<leader>Da",
			attach,
			ft = "go",
			desc = "Attach to Go process",
		},
		{
			"<leader>Dt",
			function()
				require("dap-go").debug_test()
			end,
			ft = "go",
			desc = "Debug Go test",
		},
		{
			"<leader>Dl",
			function()
				require("dap-go").debug_last_test()
			end,
			ft = "go",
			desc = "Debug last Go test",
		},
	},

	config = function()
		local dlv = vim.fn.exepath("dlv")
		assert(dlv ~= "", "Delve executable 'dlv' not found in PATH")

		require("dap-go").setup({
			delve = {
				path = dlv,
			},
		})
	end,
}
