" Pathogen {{{
	execute pathogen#infect()
"}}}

" General Settings {{{
	set modelines=1     "The final line of a file can contain file specific settings
	filetype on         "Enable filetype detection
	filetype plugin on  "Enable loading plugins based on file type
	filetype indent on  "Enable filetype specific indentation
" }}}

" Colors {{{
	" set t_Co=256
	" let g:molokai_original=0
	" " let g:rehash256 = 1
	colorscheme jpmolokai " the color scheme
	syntax enable         " enable syntax highlighting
" }}}

" Tabstops {{{
	set tabstop=2       " visual spaces per tab
	set softtabstop=2   " number of spaces per tab when expanding tabs
	set shiftwidth=2    " for autoindent or indent shifting
	set noexpandtab     " tab inserts tabs
	set autoindent      " autoindent because obviously
" }}}

" UI {{{
	"set showcmd                    " shows the last entered command
	set number                     " show line numbers
	set relativenumber             " show line numbers relative to current line
	set cursorline                 " highlights the current line
	set wildmenu                   " enables command autocompletion
	set showmatch                  " highlights the matching parens et all
	set backspace=indent,eol,start " backspaces everything
	set mouse=a                    " enables mouse
"}}}

" Searching {{{
	set incsearch      " immediate search
	set hlsearch       " highlight search matches
	set ignorecase     " case insensitive search
	set smartcase      " ifi the search string has mixed case, search becomes case sensitive
" }}}

" Invisible characters {{{
	set list                                         " Show invisible charactes.
	set listchars=tab:￫―,nbsp:·,extends:⇀,precedes:↼ " The characters that the invisible will show as.
" }}}

" ctrlp {{{
	" Files to exclude
	let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
"}}}

" Fix VIM {{{
	set nobackup          " Don't create backup
	set noswapfile        " Disable swap files
	set hidden            " Enables switching buffers without saving
	set clipboard=unnamed " Syncs VIMs clipboard with OSX's
	set shortmess+=c      " Hide 'user defined completion pattern not found'
"}}}

" Remaps {{{
	let mapleader=" "
	" Normal mode {{{
		" Move between split panels ctrl + movement
		nnoremap <C-h> <C-w>h
		nnoremap <C-j> <C-w>j
		nnoremap <C-k> <C-w>k
		nnoremap <C-l> <C-w>l

		" Edit vimrc in a split panel
		"nnoremap <Leader>ev :vsplit <CR> :wincmd l <CR> :e $MYVIMRC <CR>
		nnoremap <Leader>ev :botright vnew $MYVIMRC<CR>

		" Toggle NerdTree
		nnoremap <Leader>b :NERDTreeToggle <CR>
		" Toggle NerdTree
		nnoremap <Leader>f :NERDTreeFind <CR>

		" Re-syntax highlight
		nnoremap <Leader>s :syntax on <CR>

		" Clear search
		nnoremap <Leader><Esc> :nohlsearch<CR>
	" }}}

	" Insert mode {{{
		" Emacs movements
		" Superseeded by the vim-rsi plugin
		"inoremap <C-p> <Esc> ki
		"inoremap <C-n> <Esc> ji
		"inoremap <C-a> <Esc> 0i
		"inoremap <C-e> <Esc> $i
		"inoremap <C-b> <Esc> hi
		"inoremap <C-f> <Esc> li
	"}}}

	" Everywhere {{{
		" Split sublime bindings.
		noremap <C-k><Right> <C-w>l <CR>
		noremap <C-k><C-Right> :botright vsplit<CR>
		noremap <C-k><C-S-Right> <C-w>l :q<CR>
	" }}}
"}}}

" Linting {{{
	set statusline +=%#warningmsg#
	set statusline +=%{SyntasticStatuslineFlag()}
	set statusline +=%*
	let g:syntastic_always_populate_loc_list = 1
	let g:syntastic_auto_loc_list = 1
	let g:syntastic_loc_list_height = 3
	let g:syntastic_check_on_open = 1
	let g:syntastic_check_on_wq = 0
	let g:syntastic_javascript_checkers = ['jshint']
"}}}

" AutoCMD {{{
	" Live reload vimrc
	 augroup vimrc
		autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
	augroup END
"}}}

" Airline {{{
	let g:airline_powerline_fonts = 1 "Use powerline fonts
	let g:airline_theme='badwolf'
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#show_buffers = 1
	let g:airline#extensions#tabline#buffer_nr_show = 1
" }}}
" vim vim:foldmethod=marker:foldlevel=0
