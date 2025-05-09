local M = {
	"smoka7/hop.nvim",
	config = function()
		local hop = require'hop'
		local hint = require'hop.hint'
		hop.setup()

		local addCmd = vim.api.nvim_create_user_command

		addCmd('HopBeforeChar2CurrentLineAC', function()
			hop.hint_char2({
				hint.HintDirection.AFTER_CURSOR,
				current_line_only = true,
				hint_offset = -1,
			})
		end, {})

		addCmd('HopBeforeChar2CurrentLineBC', function()
			hop.hint_char2({
				hint.HintDirection.BEFORE_CURSOR,
				current_line_only = true,
				hint_offset = 2,
			})
		end, {})

		addCmd('HopCamelCurrentLineAC', function()
			hop.hint_camel_case({
				hint.HintDirection.AFTER_CURSOR,
				current_line_only = true,
			})
		end, {})

		addCmd('HopCamelCurrentLineBC', function()
			hop.hint_camel_case({
				hint.HintDirection.BEFORE_CURSOR,
				current_line_only = true,
			})
		end, {})

	end,
	keys = {
		{ '<Leader><Leader>f', '<cmd>HopChar2CurrentLineAC<CR>', mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>F', '<cmd>HopChar2CurrentLineBC<CR>', mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>/', '<cmd>HopPatternMW<CR>', mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>w', '<cmd>HopWordMW<CR>', mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>J', '<cmd>HopVerticalAC<CR>', mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>K', '<cmd>HopVerticalBC<CR>', mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>j', '<cmd>HopWordAC<CR>', mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>k', '<cmd>HopWordBC<CR>', mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>h', '<cmd>HopWordCurrentLineBC<CR>', mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>t', '<cmd>HopBeforeChar2CurrentLineAC<CR>', mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>T', '<cmd>HopBeforeChar2CurrentLineBC<CR>', mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>l', '<cmd>HopCamelCurrentLineAC<CR>', mode = { 'n', 'v', 'o' } },
		{ '<Leader><Leader>h', '<cmd>HopCamelCurrentLineBC<CR>', mode = { 'n', 'v', 'o' } },
	}
}

return M
