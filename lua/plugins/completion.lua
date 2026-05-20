return {
	{
		"saghen/blink.cmp",
		lazy = false,
		version = "*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<CR>"] = { "select_and_accept", "fallback" },
			},
			completion = {
				list = {
					selection = {
						preselect = false,
						auto_insert = true,
					},
				},
				ghost_text = {
					enabled = true,
					show_without_selection = true,
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},
			},
			signature = {
				enabled = false,
			},
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
		},
	},
}
