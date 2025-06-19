local M = {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"danielfalk/smart-open.nvim",
		"fannheyward/telescope-coc.nvim",
		"nvim-lua/plenary.nvim",
	},
	lazy = false,
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.load_extension("smart_open")
		telescope.load_extension("coc")

		local telescopeConfig = {
			pickers = {
				builtin = {
					initial_mode = "insert",
					theme = "dropdown",
					preview = {
						hide_on_startup = false,
					},
				},
				colorscheme = {
					theme = "dropdown",
					enable_preview = true,
				},
			},
			defaults = {
				winblend = 0,
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
					},
				},
				path_display = { "absolute", "shorten", "smart" },
				layout_config = {
					cursor = {
						preview_width = 0.4,
					},
				},
			},
			extensions = {
				smart_open = {
					disable_devicons = false,
				},
			},
		}

		telescope.setup(telescopeConfig)
	end,
	keys = {
		{
			"<C-p>",
			desc = "Open something",
			function()
				require("telescope").extensions.smart_open.smart_open({
					prompt_title = require("custom.path_utils").normalize_to_home(vim.fn.getcwd()),
					cwd = vim.fn.getcwd(),
					cwd_only = true,
				})
			end,
		},
		{ "<Leader>db", "<cmd>Telescope buffers show_all_buffers=true sort_mru=true cwd_only=true  <CR>", desc = "List buffers" },
		{ "<Leader>d", "<cmd>Telescope builtin<CR>", desc = "List telescope commands" },
		{ "<Leader>dd", "<cmd>Telescope builtin<CR>", desc = "List telescope commands" },
		{ "<Leader>dc", "<cmd>Telescope colorscheme<CR>", desc = "List colorschemes" },
		{ "<Leader>dh", "<cmd>Telescope command_history<CR>", desc = "Show command history" },
		{ "<Leader>d/", "<cmd>Telescope live_grep<CR>", desc = "Find across workspace" },
		{ "<Leader>dn", "<cmd>Telescope resume initial_mode=normal<CR>", desc = "Resume telescope" },
		{ "<Leader>do", "<cmd>Telescope coc document_symbols<CR>", desc = "List document's symbols" },
		{ "<Leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Find in file" },
		-- Find references
		{
			"<leader>fr",
			"<cmd>Telescope coc references initial_mode=normal theme=cursor<CR>",
			desc = "Find symbol's references",
		},
	},
}

return M