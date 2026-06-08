local OXFMT_CONFIGS = {
	".oxfmtrc.json",
	".oxfmtrc.jsonc",
	"oxfmt.config.ts",
}
local BIOME_CONFIGS = { "biome.json", "biome.jsonc" }

local function js_formatters(bufnr)
	if vim.fs.root(bufnr, OXFMT_CONFIGS) then
		return { "oxfmt" }
	end
	if vim.fs.root(bufnr, BIOME_CONFIGS) then
		return { "biome" }
	end
	return { "prettier" }
end

local function json_formatters(bufnr)
	if vim.fs.root(bufnr, BIOME_CONFIGS) then
		return { "biome" }
	end
	return { "prettier" }
end

return {
	{
		"stevearc/conform.nvim",
		lazy = false,
		opts = {
			format_on_save = { timeout_ms = 3000, lsp_format = "fallback" },
			formatters_by_ft = {
				lua = { "stylua" },
				typescript = js_formatters,
				typescriptreact = js_formatters,
				javascript = js_formatters,
				javascriptreact = js_formatters,
				json = json_formatters,
				jsonc = json_formatters,
				html = { "prettier" },
			},
		},
	},
}
