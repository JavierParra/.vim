local schemes = require("colorSchemes")
local monokaiClassic = schemes.monokaiClassic

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
	border_highlight = monokaiClassic.pink,
	-- fg_gutter = "#3b4261",
	true_black = monokaiClassic.black,
	black = monokaiClassic.base2,
	gray = monokaiClassic.grey,
	red = monokaiClassic.red,
	green = monokaiClassic.green,
	yellow = monokaiClassic.yellow,
	blue = monokaiClassic.blue,
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
	error = monokaiClassic.red,
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

return {

	{
		"JavierParra/Catppuccino.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			local catppuccino = require("catppuccino")
			catppuccino.setup({
				colorscheme = "catppuccino",
				transparency = true,
				integrations = {
					coc = true,
					nvimtree = {
						enabled = true,
						show_root = true,
					}
				},
			}, monokai)
			vim.cmd("colorscheme catppuccino")
		end,
		dev = true,
	},
}