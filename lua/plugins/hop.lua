local M = {
	"smoka7/hop.nvim",
	config = function()
		local hop = require'hop'
		local hint = require'hop.hint'
		hop.setup()

		vim.keymap.set('', '<Leader><Leader>t', function()
			hop.hint_char2({
				hint.HintDirection.AFTER_CURSOR,
				current_line_only = true,
				hint_offset = -1,
			})
		end)

		vim.keymap.set('', '<Leader><Leader>T', function()
			hop.hint_char2({
				hint.HintDirection.BEFORE_CURSOR,
				current_line_only = true,
				hint_offset = 1,
			})
		end)

		vim.keymap.set('', '<Leader><Leader>l', function()
			hop.hint_camel_case({
				hint.HintDirection.AFTER_CURSOR,
				current_line_only = true,
			})
		end)

		vim.keymap.set('', '<Leader><Leader>h', function()
			hop.hint_camel_case({
				hint.HintDirection.BEFORE_CURSOR,
				current_line_only = true,
			})
		end)

	end
}

return M
