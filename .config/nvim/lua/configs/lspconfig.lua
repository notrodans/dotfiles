local nvlsp = require("nvchad.configs.lspconfig")
local lspconfig = require("lspconfig")

local function get_install_path_for(package)
	return vim.fn.expand("$MASON/packages/" .. package)
end

nvlsp.defaults()

local servers = {
	"jdtls",
	"gradle_ls",
	"prismals",
	"html",
	"emmet_ls",
	"lua_ls",
	"cssmodules_ls",
	"clangd",
	"marksman",
	"bashls",
	"mdx_analyzer",
	"css_variables",
	"gopls",
	"cssls",
	"intelephense",
	"stylelint_lsp",
	"biome",
	"tailwindcss",
	"vtsls",
	"jsonls",
	"lemminx",
	"eslint",
	"texlab",
}

vim.lsp.config("intelephense", {
	root_dir = lspconfig.util.root_pattern("composer.json", "*.php"),
	filetypes = { "php" },
	settings = {
		intelephense = {
			telemetry = {
				enabled = false,
			},
			files = {
				maxSize = 5000000,
			},
		},
	},
})
vim.lsp.config("stylelint_lsp", {
	filetypes = { "css", "scss", "less" },
	settings = {
		stylelintplus = {
			autoFixOnFormat = true,
		},
	},
})
vim.lsp.config("jsonls", {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = true,
		},
	},
})
vim.lsp.config("tailwindcss", {
	settings = {
		tailwindCSS = {
			experimental = {
				classRegex = {
					{ "cva|cn|cx\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
				},
			},
		},
	},
})
vim.lsp.config("biome", {
	settings = {
		biome = {
			requireConfiguration = true,
		},
	},
})
vim.lsp.config("jdtls", {
	cmd = {
		"jdtls",
		"--data",
		"--jvm-arg=-javaagent:" .. get_install_path_for("jdtls") .. "/lombok.jar",
	},

	root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw" }),

	settings = {
		java = {
			home = "/usr/lib/jvm/java-21-openjdk",
			redhat = {
				telemetry = { enabled = false },
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				hashCodeEquals = {
					useJava7Objects = true,
				},
				useBlocks = true,
			},
			maven = { downloadSources = true },
			format = {
				settings = {
					url = vim.fn.expand("$HOME") .. "/eclipse-my-style.xml",
					profile = "GoogleStyle",
				},
			},
			compile = {
				nullAnalysis = {
					nonnull = {
						"lombok.NonNull",
						"javax.annotation.Nonnull",
						"org.eclipse.jdt.annotation.NonNull",
						"org.springframework.lang.NonNull",
					},
				},
			},
			eclipse = { downloadSources = true },
			completion = {
				chain = { enabled = false },
				guessMethodArguments = "off",
				favouriteStaticMembers = {
					"org.junit.jupiter.api.Assertions.*",
					"org.junit.jupiter.api.Assumptions.*",
					"org.mockito.Mockito.*",
					"java.util.Objects.*",
				},
			},
			configuration = {
				runtimes = {
					{
						name = "JavaSE-25",
						path = "/usr/lib/jvm/java-25-openjdk",
					},
					{
						name = "JavaSE-21",
						path = "/usr/lib/jvm/java-21-openjdk",
					},
					{
						name = "JavaSE-17",
						path = "/usr/lib/jvm/java-17-openjdk",
					},
				},
			},
		},
	},
})
vim.lsp.enable(servers)
