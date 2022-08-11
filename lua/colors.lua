local catppuccino = require("catppuccino")
local monokaiClassic = {
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
	red = '#e95678', -- red
	diff_add_fg = '#6a8f1f', -- add
	diff_add_bg = '#3d5213',
	diff_remove_fg = '#4a0f23', -- delete
	diff_remove_bg = '#a3214c', -- conflict
	diff_change_fg = '#7AA6DA', -- change
	diff_change_bg = '#537196',

	bg_search = "#FFFC7F",

	none = 'NONE'
}

local monokai = {
	none = "NONE",
	bg = monokaiClassic.base2, -- nvim bg
	fg = monokaiClassic.white, -- fg color (text)
	bg_inactive = monokaiClassic.base3, -- nvim bg
	bg_visual = monokaiClassic.base5,
	bg_highlight = monokaiClassic.base3,
	bg_search = monokaiClassic.bg_search,
	bg_popup = monokaiClassic.base3,
	bg_float = monokaiClassic.base3,
	-- fg_gutter = "#3b4261",
	true_black = monokaiClassic.black,
	black = monokaiClassic.base2,
	gray = monokaiClassic.grey,
	red = monokaiClassic.red,
	green = monokaiClassic.green,
	yellow = monokaiClassic.yellow,
	-- blue = "#62D8F1",
	magenta = monokaiClassic.purple,
	cyan = monokaiClassic.aqua,
	white = monokaiClassic.white,
	orange = monokaiClassic.orange,
	pink = monokaiClassic.pink,
	-- black_br = "#7f8c98",
	-- red_br = "#e06c75",
	-- green_br = "#58cd8b",
	-- yellow_br = "#FFE37E",
	-- blue_br = "#84CEE4",
	-- magenta_br = "#B8A1E3",
	-- cyan_br = "#59F0FF",
	-- white_br = "#FDEBC3",
	-- orange_br = "#F6A878",
	-- pink_br = "#DF97DB",
	comment = monokaiClassic.grey,
	error = monokaiClassic.grey,
	warning = monokaiClassic.orange,
	git = {
		add = monokaiClassic.diff_add_fg,
		add_bg = monokaiClassic.diff_add_bg,
		change = monokaiClassic.diff_change_fg,
		change_bg = monokaiClassic.diff_change_bg,
		delete = monokaiClassic.diff_remove_fg,
		delete_bg = monokaiClassic.diff_remove_bg,
		conflict = "#a3214c",
	},
}

catppuccino.setup(
	{
		colorscheme = "catppuccino",
		transparency = true,
	},
	monokai
)

vim.cmd('colorscheme catppuccino')
