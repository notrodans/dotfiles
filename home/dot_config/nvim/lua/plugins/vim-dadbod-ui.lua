return {
	{
		"kristijanhusak/vim-dadbod-ui",
		lazy = true,
		cmd = {
			"DB",
			"DBUI",
			"DBUIToggle",
			"DBUIFindBuffer",
		},
		ft = { "sql", "mysql", "plsql" },
		keys = {
			{
				"<leader>db",
				"<cmd>DBUIToggle<CR>",
				desc = "Database UI toggle",
			},
			{
				"<leader>df",
				"<cmd>DBUIFindBuffer<CR>",
				desc = "Database find buffer",
			},
		},
		config = function()
			local group = vim.api.nvim_create_augroup("DadbodUISignColumn", { clear = true })

			vim.api.nvim_create_autocmd("FileType", {
				group = group,
				pattern = "dbui",
				callback = function()
					vim.opt_local.signcolumn = "yes"
				end,
			})

			vim.g.db_ui_disable_info_notifications = 1
			vim.g.db_ui_save_location = vim.fn.getcwd() .. "/sql/"
			vim.g.db_ui_table_helpers = {
				postgresql = {
					["Table Size"] = [[
						select table_name, pg_size_pretty(pg_total_relation_size(quote_ident(table_name))), pg_total_relation_size(quote_ident(table_name)) from information_schema.tables where table_schema = 'public' and table_name = '{table}';
					]],
					["Count"] = [[
						select count(*) from {table};
					]],
				},
			}
		end,
		dependencies = {
			"tpope/vim-dadbod",
			"kristijanhusak/vim-dadbod-completion",
		},
	},
}
