return {
	{
		"neovim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		dependencies = { "neovim-treesitter/treesitter-parser-registry" },
		config = function()
			local parsers = {
				"bash",
				"comment",
				"diff",
				"dockerfile",
				"go",
				"graphql",
				"html",
				"http",
				"javascript",
				"jsdoc",
				"json",
				"json5",
				"latex",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"php",
				"prisma",
				"query",
				"regex",
				"scss",
				"scheme",
				"sql",
				"swift",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
			}

			require("nvim-treesitter").install(parsers)

			local enabled = {}
			for _, p in ipairs(parsers) do
				enabled[p] = true
			end

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local ft = vim.bo[args.buf].filetype
					local lang = vim.treesitter.language.get_lang(ft) or ft
					if enabled[lang] and pcall(vim.treesitter.start, args.buf, lang) then
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
}
