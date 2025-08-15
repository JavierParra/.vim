local h = require("helpers")

local M = {
	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			view = {
				preserve_window_proportions = true,
			},
			renderer = {
				icons = {
					glyphs = {
						folder = {
							arrow_closed = "▸",
							arrow_open = "▾",
						},
					},
				}
			},
		},
		keys = {
			{ "<Leader>ft", h.cmd("NvimTreeToggle"), mode = { "n" }, desc = "[T]oggle [F]ile explorer" },
			{ "<Leader>fo", h.cmd("NvimTreeFocus"), mode = { "n" }, desc = "[O]pen [F]ile explorer" },
			{ "<Leader>fc", h.cmd("NvimTreeClose"), mode = { "n" }, desc = "[C]lose [F]ile explorer" },
			{ "<Leader>ff", h.cmd("NvimTreeFindFile"), mode = { "n" }, desc = "[F]ind [F]ile in explorer" },
		},
		enabled = true
	},
}

return M