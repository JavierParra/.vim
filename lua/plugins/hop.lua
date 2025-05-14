local M = {
	"smoka7/hop.nvim",
	config = function()
		require'hop'.setup()
	end,

	keys = {
		{ '<Leader><Leader>f',
			function()
				local hop = require('hop')
				local hint = require('hop.hint')

				-- '<cmd>HopChar2CurrentLineAC<CR>'
				hop.hint_char2({
					direction = hint.HintDirection.AFTER_CURSOR,
					current_line_only = true,
				})
			end,
		 	mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>F',
			function()
				local hop = require('hop')
				local hint = require('hop.hint')

				-- '<cmd>HopChar2CurrentLineBC<CR>'
				hop.hint_char2({
					direction = hint.HintDirection.BEFORE_CURSOR,
					current_line_only = true,
				})
			end,
			mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>/',
			function()
				local hop = require('hop')
				local hint = require('hop.hint')

				-- '<cmd>HopPatternMW<CR>'
				hop.hint_patterns({
					multi_windows = true,
				})
			end,
			mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>w',
			function()
				local hop = require('hop')
				local hint = require('hop.hint')

				-- '<cmd>HopWord<CR>'
				hop.hint_words({ })
			end,
			mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>W',
			function()
				local hop = require('hop')
				local hint = require('hop.hint')

				-- '<cmd>HopWordMW<CR>'
				hop.hint_words({
					multi_windows = true,
				})
			end,
			mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>J',
			function()
				local hop = require('hop')
				local hint = require('hop.hint')

				-- '<cmd>HopVerticalAC<CR>'
				hop.hint_vertical({
					direction = hint.HintDirection.AFTER_CURSOR,
				})
			end,
			mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>K',
			function()
				local hop = require('hop')
				local hint = require('hop.hint')

				-- '<cmd>HopVerticalBC<CR>'
				hop.hint_vertical({
					direction = hint.HintDirection.BEFORE_CURSOR,
				})
			end,
			mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>j',
			function()
				local hop = require('hop')
				local hint = require('hop.hint')

				-- '<cmd>HopWordAC<CR>'
				hop.hint_words({
					direction = hint.HintDirection.AFTER_CURSOR,
				})
			end,
			mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>k',
			function()
				local hop = require('hop')
				local hint = require('hop.hint')
				--
				-- '<cmd>HopWordBC<CR>'
				hop.hint_words({
					direction = hint.HintDirection.BEFORE_CURSOR,
				})
			end,
			mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>h',
			function()
				local hop = require('hop')
				local hint = require('hop.hint')

				-- '<cmd>HopWordCurrentLineBC<CR>'
				hop.hint_words({
					direction = hint.HintDirection.BEFORE_CURSOR,
					current_line_only = true,
				})
			end,
			mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>t',
			function()
				local hop = require('hop')
				local hint = require('hop.hint')
				-- 'custom cmd'

				hop.hint_char2({
					hint.HintDirection.AFTER_CURSOR,
					current_line_only = true,
					hint_offset = -1,
				})
			end,
			mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>T',
			function()
				local hop = require('hop')
				local hint = require('hop.hint')
				-- 'custom cmd'
				hop.hint_char2({
					hint.HintDirection.BEFORE_CURSOR,
					current_line_only = true,
					hint_offset = 2,
				})
			end,
			mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>l',
			function()
				local hop = require('hop')
				local hint = require('hop.hint')
				-- 'custom cmd'
				hop.hint_camel_case({
					hint.HintDirection.AFTER_CURSOR,
					current_line_only = true,
				})
			end,
			mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>h',
			function()
				local hop = require('hop')
				local hint = require('hop.hint')
				-- 'custom cmd'
				hop.hint_camel_case({
					hint.HintDirection.BEFORE_CURSOR,
					current_line_only = true,
				})
			end,
			mode = { 'n', 'v', 'o' } },
	}
}

return M
