local M = {
	monokaiClassic = {
		name = 'monokai',
		base1 = '#272a30', -- black
		base2 = '#26292C', -- bg
		base3 = '#2E323C',
		base4 = '#333842',
		base5 = '#4d5154',
		base6 = '#9ca0a4',
		base7 = '#b1b1b1',
		border = '#a1b5b1',
		--
		brown = "#504945", -- no match
		white = '#f8f8f0', -- white, fg
		grey = '#8F908A', -- comment
		black = '#000000', -- no match (using base1)
		pink = '#f92672', -- pink
		green = '#a6e22e', -- green
		aqua = '#66d9ef', -- cyan
		yellow = '#e6db74', -- yellow
		orange = '#fd971f', -- orange
		purple = '#ae81ff', -- magenta
		red = '#f70c27', -- red
		blue = '#00C9EF', -- blue
		diff_add_fg = '#6a8f1f', -- add
		diff_add_bg = '#3d5213',
		diff_remove_fg = '#4a0f23', -- delete
		diff_remove_bg = '#a3214c', -- conflict
		diff_change_fg = '#7AA6DA', -- change
		diff_change_bg = '#537196',

		bg_search = "#FFFC7F",

		none = 'NONE'
	}
}

return M
