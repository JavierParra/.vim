local M = {
	"nvim-telescope/telescope.nvim",
	dependencies = {
	"danielfalk/smart-open.nvim",
		"fannheyward/telescope-coc.nvim",
		"nvim-lua/plenary.nvim",
	},
	lazy = false,
	config = function()
		local telescope = require('telescope')
		local actions = require('telescope.actions')

		telescope.load_extension('smart_open')
		telescope.load_extension('coc')

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
				path_display = {"absolute", "shorten", "smart"},
				layout_config = {
					cursor = {
						preview_width = 0.4,
					}
				},
			},
			extensions = {
				smart_open = {
					disable_devicons = false,
				}
			},
		}

		telescope.setup(telescopeConfig)
	end
}

return M
