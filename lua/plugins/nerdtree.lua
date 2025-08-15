local h = require("helpers")

local M = {
	{
		"scrooloose/nerdtree",
		keys = {
			{ "<Leader>ft", h.cmd("NERDTreeToggle"), mode= { 'n' }, desc = "[T]oggle [F]ile explorer" },
			{ "<Leader>fo", h.cmd("NERDTreeFocus"), mode= { 'n' }, desc = "[O]pen [F]ile explorer" },
			{ "<Leader>fc", h.cmd("NERDTreeClose"), mode= { 'n' }, desc = "[C]lose [F]ile explorer" },
			{ "<Leader>ff", h.cmd("NERDTreeFind"), mode= { 'n' }, desc = "[F]ind [F]ile in explorer" },
		},
		enabled = false
	}
}

return M