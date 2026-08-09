return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"theHamsta/nvim-dap-virtual-text",
	},
	keys = {
		{
			"<F2>",
			function()
				require("dap").terminate()
			end,
			desc = "Stop debugging",
		},
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Continue debugging",
		},
		{
			"<F6>",
			function()
				require("dap").repl.open()
			end,
			desc = "Open REPL",
		},
		{
			"<F7>",
			function()
				require("dap").run_to_cursor()
			end,
			desc = "Run debugging to cursor",
		},
		{
			"<F10>",
			function()
				require("dap").step_over()
			end,
			desc = "Step over",
		},
		{
			"<F11>",
			function()
				require("dap").step_into()
			end,
			desc = "Step into",
		},
		{
			"<F12>",
			function()
				require("dap").step_out()
			end,
			desc = "Step out",
		},
		{
			"<leader>Db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle Debug breakpoint",
		},
		{
			"<leader>DB",
			function()
				local condition = vim.fn.input("Breakpoint condition: ")
				require("dap").set_breakpoint(condition)
			end,
			desc = "Toggle Debug conditional Breakpoint",
		},
	},

	config = function()
		require("nvim-dap-virtual-text").setup()
	end,
}
