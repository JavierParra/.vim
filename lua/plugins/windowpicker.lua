local ignoredFileTypes = {
	"NvimTree",
	"notify",
	"qf",
	"noice",
}

local M = {
	{
		"s1n7ax/nvim-window-picker",
		name = "windowpicker",
		config = {
			hint = "floating-big-letter",
			show_prompt = false,

			filter_rules = {
				bo = {
					filetype = ignoredFileTypes,
				},
			},
		},
		keys = {
			{
				"<Leader>bs",
				function()
					local v = vim.api

					local cur_filetype = v.nvim_buf_get_option(0, "filetype")
					if vim.tbl_contains(ignoredFileTypes, cur_filetype) then
						return
					end

					local picked_window_id = require("window-picker").pick_window()

					if picked_window_id == nil then
						return
					end

					local cur_buf = v.nvim_win_get_buf(0)
					local cur_cursor = v.nvim_win_get_cursor(0)

					local swapped_buf = v.nvim_win_get_buf(picked_window_id)
					local swapped_cursor = v.nvim_win_get_cursor(picked_window_id)

					v.nvim_win_set_buf(picked_window_id, cur_buf)
					v.nvim_win_set_cursor(picked_window_id, cur_cursor)

					v.nvim_win_set_buf(0, swapped_buf)
					v.nvim_win_set_cursor(0, swapped_cursor)
				end,
				mode = { "n" },
				desc = "[B]uffer [S]wap",
			},
		},
	},
}

return M