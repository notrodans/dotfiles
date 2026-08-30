local javascript_roots = {
	"eslint.config.js",
	"eslint.config.mjs",
	"eslint.config.cjs",
	".eslintrc",
	".eslintrc.js",
	".eslintrc.cjs",
	".eslintrc.json",
	"package.json",
	".git",
}

local roots = {
	javascript = javascript_roots,
	javascriptreact = javascript_roots,
	typescript = javascript_roots,
	typescriptreact = javascript_roots,
	php = { "phpcs.xml", "phpcs.xml.dist", "composer.json", ".git" },
	sql = { ".sqlfluff", "pyproject.toml", ".git" },
}

return {
	"mfussenegger/nvim-lint",
	ft = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"php",
		"sql",
	},
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			php = { "phpcs" },
			sql = { "sqlfluff" },
		}

		local function run(buf)
			if not vim.api.nvim_buf_is_valid(buf) then
				return
			end

			local markers = roots[vim.bo[buf].filetype]
			local cwd = markers and vim.fs.root(buf, markers) or nil

			lint.try_lint(nil, cwd and { cwd = cwd } or nil)
		end

		local group = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
			group = group,
			callback = function(args)
				run(args.buf)
			end,
		})

		vim.schedule(function()
			run(vim.api.nvim_get_current_buf())
		end)
	end,
}
