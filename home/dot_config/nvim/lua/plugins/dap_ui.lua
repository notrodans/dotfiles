return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
	},
	keys = {
		"<leader>Du",
		"<leader>DU",
	},
	config = function()
		local api = vim.api
		local dapui = require("dapui")
		local signcolumns = {}

		local function is_dapui_window(win)
			local buf = api.nvim_win_get_buf(win)
			return vim.bo[buf].filetype:match("^dapui_") ~= nil
		end

		local function dapui_open()
			for _, win in ipairs(api.nvim_list_wins()) do
				if api.nvim_win_is_valid(win) and is_dapui_window(win) then
					return true
				end
			end

			return false
		end

		local function sync_signcolumns()
			if dapui_open() then
				for _, win in ipairs(api.nvim_list_wins()) do
					if api.nvim_win_is_valid(win) and not is_dapui_window(win) then
						if signcolumns[win] == nil then
							signcolumns[win] = vim.wo[win].signcolumn
						end

						vim.wo[win].signcolumn = "yes"
					end
				end

				return
			end

			for win, value in pairs(signcolumns) do
				if api.nvim_win_is_valid(win) then
					vim.wo[win].signcolumn = value
				end
			end

			signcolumns = {}
		end

		local group = api.nvim_create_augroup("DapUISignColumn", { clear = true })

		api.nvim_create_autocmd({ "BufWinEnter", "WinNew", "WinClosed" }, {
			group = group,
			callback = function()
				vim.schedule(sync_signcolumns)
			end,
		})

		dapui.setup()

		vim.keymap.set("n", "<leader>Du", function()
			dapui.toggle({ layout = 2 })
			vim.schedule(sync_signcolumns)
		end, {
			desc = "Toggle Simple Debug ui, I mainly use it to run tests",
		})

		vim.keymap.set("n", "<leader>DU", function()
			dapui.toggle()
			vim.schedule(sync_signcolumns)
		end, {
			desc = "Toggle Full Debug ui",
		})
	end,
}
