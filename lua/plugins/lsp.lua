return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("mason-lspconfig").setup({
				automatic_enable = false,
			})

			vim.lsp.config("ts_ls", {
				before_init = function(params)
					local root = params.rootPath
						or (params.rootUri and vim.uri_to_fname(params.rootUri) or "")
					if root ~= "" then
						local local_tsdk = root .. "/node_modules/typescript/lib"
						if vim.fn.isdirectory(local_tsdk) == 1 then
							params.initializationOptions = vim.tbl_deep_extend(
								"force",
								params.initializationOptions or {},
								{ tsserver = { path = local_tsdk } }
							)
						end
					end
				end,
				init_options = {
					preferences = { importModuleSpecifierPreference = "relative" },
				},
			})
			vim.lsp.enable("ts_ls")

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
					},
				},
			})
			vim.lsp.enable("lua_ls")

			vim.lsp.enable("jsonls")

			vim.lsp.config("eslint", {
				root_markers = {
					".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.mjs",
					".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml",
					"eslint.config.js", "eslint.config.mjs", "eslint.config.cjs",
				},
			})
			vim.lsp.enable("eslint")

			vim.lsp.config("biome", {
				root_markers = { "biome.json", "biome.jsonc" },
			})
			vim.lsp.enable("biome")

			vim.lsp.config("markdown_oxide", {
				capabilities = {
					workspace = {
						didChangeWatchedFiles = {
							-- markdown-oxide needs this to resolve completions
							-- for unindexed blocks and unresolved files
							dynamicRegistration = true,
						},
					},
				},
			})
			vim.lsp.enable("markdown_oxide")

			vim.lsp.config("rust_analyzer", {
				settings = {
					["rust-analyzer"] = {
						check = { command = "clippy" },
					},
				},
			})
			vim.lsp.enable("rust_analyzer")

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
				callback = function(args)
					local buf = args.buf
					local function map(lhs, rhs, desc)
						vim.keymap.set("n", lhs, rhs, { buffer = buf, silent = true, desc = desc })
					end

					map("<C-]>", vim.lsp.buf.definition, "Go to definition")
					map("<C-h>", vim.lsp.buf.hover, "Hover documentation")
					map("<Leader>rn", vim.lsp.buf.rename, "Rename symbol")
					map("<Leader>rf", function()
						vim.lsp.buf.code_action({ context = { only = { "refactor" } } })
					end, "Refactor")
					map("<Leader>fl", vim.lsp.buf.code_action, "Code action")
					map("<Leader>cr", "<cmd>LspRestart<CR>", "Restart LSP")
				end,
			})
		end,
	},
}
