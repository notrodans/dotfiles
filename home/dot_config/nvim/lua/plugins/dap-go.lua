return {
	"leoluz/nvim-dap-go",

	dependencies = {
		"mfussenegger/nvim-dap",
	},

	keys = {
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
		require("dap-go").setup({
			delve = {
				path = "dlv",
				initialize_timeout_sec = 20,
				port = "${port}",
				args = {},
				build_flags = "",
				detached = vim.fn.has("win32") == 0,
			},
		})

		local dap = require("dap")

		-- Override dap-go's adapter to run the project-managed Delve.
		dap.adapters.go = function(callback)
			callback({
				type = "server",
				host = "127.0.0.1",
				port = "${port}",

				executable = {
					command = "go",
					args = {
						"tool",
						"dlv",
						"dap",
						"-l",
						"127.0.0.1:${port}",
					},
					cwd = vim.fn.getcwd(),
				},

				options = {
					initialize_timeout_sec = 20,
				},
			})
		end
	end,
}
