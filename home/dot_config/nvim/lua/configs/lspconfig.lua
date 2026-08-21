local nvlsp = require("nvchad.configs.lspconfig")
local lspconfig = require("lspconfig")

local function get_install_path_for(package)
	return vim.fn.expand("$MASON/packages/" .. package)
end

local function string_split(target, separator)
	return vim.split(target, separator, { plain = true, trimempty = true })
end

nvlsp.defaults()

local servers = {
	"vue_ls",
	"jdtls",
	"gradle_ls",
	"prismals",
	"html",
	"cssmodules_ls",
	"clangd",
	"marksman",
	"bashls",
	"mdx_analyzer",
	"css_variables",
	"gopls",
	"cssls",
	"intelephense",
	"biome",
	"tailwindcss",
	"vtsls",
	"jsonls",
	"lemminx",
	"texlab",
	"graphql",
	"hyprls",
	"pyrefly",
	"emmet_language_server",
	"docker_compose_language_service",
	"jinja_lsp",
	"graphql",
	"svelte",
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
vim.lsp.config("jsonls", {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = {
				enable = true,
			},
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
		redhat = {
			telemetry = { enabled = false },
		},
		java = {
			jdt = {
				ls = {
					lombokSupport = {
						enabled = true,
					},
					protobufSupport = {
						enabled = true,
					},
				},
			},
			home = vim.fn.expand("$HOME") .. "/.sdkman/candidates/21.0.10-tem",
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			inlayHints = {
				parameterNames = {
					enabled = "all",
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
					profile = "Eclipse",
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
			signatureHelp = {
				enabled = true,
				description = {
					enabled = true,
				},
			},
			configuration = {
				runtimes = {
					{
						name = "JavaSE-25",
						path = vim.fn.expand("$HOME") .. "/.sdkman/candidates/25.0.2-tem",
					},
					{
						name = "JavaSE-21",
						path = vim.fn.expand("$HOME") .. "/.sdkman/candidates/21.0.10-tem",
					},
					{
						name = "JavaSE-17",
						path = vim.fn.expand("$HOME") .. "/.sdkman/candidates/17.0.10-tem",
					},
				},
			},
		},
	},

	init_options = {
		bundles = vim.iter({
			string_split(
				vim.fn.glob(
					get_install_path_for("java-debug-adapter")
						.. "/extension/server/"
						.. "com.microsoft.java.debug.plugin-*.jar",
					1
				),
				"\n"
			),
			string_split(vim.fn.glob(get_install_path_for("java-test") .. "/extension/server/" .. "*.jar", 1), "\n"),
		})
			:flatten()
			:totable(),
	},
})
vim.lsp.config("vtsls", {
	filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact", "json" },
	settings = {
		complete_function_calls = true,
		vtsls = {
			enableMoveToFileCodeAction = true,
			autoUseWorkspaceTsdk = true,
			experimental = {
				maxInlayHintLength = 30,
				completion = {
					enableServerSideFuzzyMatch = true,
				},
			},
			tsserver = {
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						location = get_install_path_for("vue-language-server") .. "/node_modules/@vue/language-server",
						languages = { "vue" },
						configNamespace = "typescript",
						enableForWorkspaceTypeScriptVersions = true,
					},
				},
			},
		},
		typescript = {
			updateImportsOnFileMove = { enabled = "always" },
			suggest = {
				completeFunctionCalls = true,
			},
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = false },
			},
		},
		javascript = {
			updateImportsOnFileMove = { enabled = "always" },
		},
	},
})
vim.lsp.enable(servers)
