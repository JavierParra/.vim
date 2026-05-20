local OXC_CONFIGS = {
	"oxlint.json",
	".oxlintrc.jsonc",
	".oxlintrc.json",
	".oxlintrc",
}
local BIOME_CONFIGS = { "biome.json", "biome.jsonc" }

local JS_FTS = {
	typescript = true,
	typescriptreact = true,
	javascript = true,
	javascriptreact = true,
}

return {
	{
		"mfussenegger/nvim-lint",
		lazy = false,
		config = function()
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
				callback = function(args)
					if not JS_FTS[vim.bo[args.buf].filetype] then
						return
					end

					local path = vim.api.nvim_buf_get_name(args.buf)
					if path == "" then
						return
					end

					local linters = {}
					if vim.fs.root(path, OXC_CONFIGS) then
						table.insert(linters, "oxlint")
					elseif vim.fs.root(path, BIOME_CONFIGS) then
						table.insert(linters, "biomejs")
					end

					if #linters > 0 then
						require("lint").try_lint(linters)
					end
				end,
			})
		end,
	},
}
