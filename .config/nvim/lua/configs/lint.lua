local lint = require("lint")

lint.linters_by_ft = {
	javascript = { "biomejs", "eslint_d" },
	typescript = { "biomejs", "eslint_d" },
	javascriptreact = { "biomejs", "eslint_d" },
	typescriptreact = { "biomejs", "eslint_d" },
	php = { "phpcs" },
	-- go = { "staticcheck" },
	sql = { "sqlfluff" },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
	group = lint_augroup,
	callback = function()
		lint.try_lint()
	end,
})
