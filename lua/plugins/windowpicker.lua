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

					local picked_buf = v.nvim_win_get_buf(picked_window_id)
					local picked_cursor = v.nvim_win_get_cursor(picked_window_id)

					v.nvim_win_set_buf(picked_window_id, cur_buf)
					v.nvim_win_set_cursor(picked_window_id, cur_cursor)

					v.nvim_win_set_buf(0, picked_buf)
					v.nvim_win_set_cursor(0, picked_cursor)
				end,
				mode = { "n" },
				desc = "[B]uffer [S]wap",
			},
			{
				"<Leader>bS",
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

					local picked_buf = v.nvim_win_get_buf(picked_window_id)
					local picked_cursor = v.nvim_win_get_cursor(picked_window_id)

					v.nvim_win_set_buf(picked_window_id, cur_buf)
					v.nvim_win_set_cursor(picked_window_id, cur_cursor)

					v.nvim_win_set_buf(0, picked_buf)
					v.nvim_win_set_cursor(0, picked_cursor)
					v.nvim_set_current_win(picked_window_id)
				end,
				mode = { "n" },
				desc = "[B]uffer [S]wap and follow",
			},
			{
				"<Leader>bd",
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

					v.nvim_win_set_buf(picked_window_id, cur_buf)
					v.nvim_win_set_cursor(picked_window_id, cur_cursor)
					v.nvim_set_current_win(picked_window_id)
				end,
				mode = { "n" },
				desc = "[B]uffer [D]uplicate",
			},
			{
				"<Leader>bD",
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

					local picked_buf = v.nvim_win_get_buf(picked_window_id)
					local picked_cursor = v.nvim_win_get_cursor(picked_window_id)

					v.nvim_win_set_buf(0, picked_buf)
					v.nvim_win_set_cursor(0, picked_cursor)
				end,
				mode = { "n" },
				desc = "[B]uffer [D]uplicate to this window",
			},
			{
				"<Leader>wj",
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

					v.nvim_set_current_win(picked_window_id)
				end,
				mode = { "n" },
				desc = "[W]indow [J]ump",
			},
			{
				"<Leader>wc",
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

					v.nvim_win_close(picked_window_id, false)
				end,
				mode = { "n" },
				desc = "[W]indow [C]lose",
			},
			{
				"<Leader>gf",
				function()
					local v = vim.api

					local cur_filetype = vim.bo.filetype
					if vim.tbl_contains(ignoredFileTypes, cur_filetype) then
						return
					end

					local src_win = v.nvim_get_current_win()
					local src_buf = v.nvim_win_get_buf(src_win)
					local src_cursor = v.nvim_win_get_cursor(src_win)

					local ok = pcall(vim.cmd, "keepjumps normal! gf")
					if not ok then
						return
					end

					local target_buf = v.nvim_win_get_buf(src_win)
					if target_buf == src_buf then
						return
					end
					local target_cursor = v.nvim_win_get_cursor(src_win)

					v.nvim_win_set_buf(src_win, src_buf)
					v.nvim_win_set_cursor(src_win, src_cursor)

					local picked_window_id = require("window-picker").pick_window()
					if picked_window_id == nil then
						return
					end

					v.nvim_win_set_buf(picked_window_id, target_buf)
					v.nvim_win_set_cursor(picked_window_id, target_cursor)
					v.nvim_set_current_win(picked_window_id)
				end,
				mode = { "n" },
				desc = "[G]oto [F]ile in picked window",
			},
		},
	},
}

return M
