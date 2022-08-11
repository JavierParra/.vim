local actions = require('telescope.actions')
local telescope = require('telescope')

telescope.load_extension('coc')

telescope.setup{
	pickers = {
		builtin = {
			initial_mode = "insert",
			theme = "dropdown",
			preview = {
				hide_on_startup = true,
			},
		},
		colorscheme = {
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
}
