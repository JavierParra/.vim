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
		{ '<Leader><Leader>f', '<cmd>HopChar2CurrentLineAC<CR>' },
		{ '<Leader><Leader>F', '<cmd>HopChar2CurrentLineBC<CR>' },
		{ '<Leader><Leader>/', '<cmd>HopPatternMW<CR>' },
		{ '<Leader><Leader>w', '<cmd>HopWordMW<CR>' },
		{ '<Leader><Leader>J', '<cmd>HopVerticalAC<CR>' },
		{ '<Leader><Leader>K', '<cmd>HopVerticalBC<CR>' },
		{ '<Leader><Leader>j', '<cmd>HopWordAC<CR>' },
		{ '<Leader><Leader>k', '<cmd>HopWordBC<CR>' },
		{ '<Leader><Leader>h', '<cmd>HopWordCurrentLineBC<CR>' },
		{ '<Leader><Leader>t', '<cmd>HopBeforeChar2CurrentLineAC<CR>' },
		{ '<Leader><Leader>T', '<cmd>HopBeforeChar2CurrentLineBC<CR>' },
		{ '<Leader><Leader>l', '<cmd>HopCamelCurrentLineAC<CR>' },
		{ '<Leader><Leader>h', '<cmd>HopCamelCurrentLineBC<CR>' },
	}
}

return M
