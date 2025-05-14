	-- filetype on           "Enable filetype detection
	-- filetype plugin on    "Enable loading plugins based on file type
	-- filetype indent on    "Enable filetype specific indentation

-- Leader keys
vim.g.mapleader = " "

local options_set = {
	-- General Settings
	-- Do not redraw during macros
	lazyredraw = false,
	-- Fold based on indentation
	foldmethod = "indent",
	-- Open all folds
	foldlevel = 99,
	-- Don't wrap by default
	wrap = false,
	-- Set the terminal's title to the current file
	title = true,
	--  My zsh is too slow at the moment.
	shell = "bash",
	--  Global status line
	laststatus = 3,

	-- Tabstops
	-- visual spaces per tab
	tabstop = 2,
	-- number of spaces per tab when expanding tabs
	softtabstop = 2,
	-- for autoindent or indent shifting
	shiftwidth = 2,
	-- tab inserts spaces... I give up
	expandtab = true,
	-- autoindent because obviously
	autoindent = true,

	-- UI
	-- line numbers
	number = true,
	-- show line numbers relative to current line
	relativenumber = true,
	-- highlights the current line. Disabled because it's set in an autocmd
	cursorline = true,
	-- enables command autocompletion
	wildmenu = true,
	-- highlights the matching parens et all
	showmatch = true,
	-- backspaces everything
	backspace = "indent,eol,start",
	-- enables mouse
	mouse = "a",
	-- create new vertical splits to the right
	splitright = true,
	-- create new horizontal splits below
	splitbelow = true,
	-- lines of margin between the cursor and top-bottom of document
	scrolloff = 4,
	-- vertical ruler
	colorcolumn = {79},
	-- prevents adding a new line to files
	fixeol = false,

	-- Searching
	-- immediate search
	incsearch = true,
	-- highlight search matches
	hlsearch = true,
	-- case insensitive search
	ignorecase = true,
	-- if the search string has mixed case, search becomes case sensitive
	smartcase = true,
	-- preview replace inline
	inccommand = "nosplit",

	-- Invisible characters
	-- Show invisible charactes.
	list = true,
	-- The characters that the invisible will show as.
	listchars = "tab:￫―,nbsp:·,extends:⇀,precedes:↼",

	-- Fix VIM
	backupdir = vim.fn.getenv("HOME") .. "/.local/share/nvim/backup",
	-- Create backups in the above dir
	backup = true,
	-- Disable swap files
	swapfile = false,
	-- Enables switching buffers without saving
	hidden = true,
	-- Syncs VIMs clipboard with the OS's
	clipboard = "unnamedplus",
}

local options_append = {
	-- Hide 'user defined completion pattern not found'
	shortmess = "c",
	-- Ignore patterns in listings.
	wildignore = "node_modules,*.pyc"
}

for k, v in pairs(options_set) do
	vim.opt[k] = v
end

for k, v in pairs(options_append) do
	vim.opt[k]:append(v)
end
