" Pathogen {{{
	execute pathogen#infect()
"}}}

" General Settings {{{
	set modelines=1       "The final line of a file can contain file specific settings
	filetype on           "Enable filetype detection
	filetype plugin on    "Enable loading plugins based on file type
	filetype indent on    "Enable filetype specific indentation
	set lazyredraw        "Do not redraw during macros
	set foldmethod=indent "Fold based on indentation
	set foldlevel=99     "Open all folds
	if $TERM_PROGRAM =~ "iTerm"
		let &t_SI = "\<Esc>]1337;CursorShape=1\x7" " Vertical bar in insert mode
		let &t_EI = "\<Esc>]1337;CursorShape=0\x7" " Block in normal mode
	endif
" }}}

" Colors {{{
	" set t_Co=256
	" let g:molokai_original=0
	" " let g:rehash256 = 1
	colorscheme jpmolokai " the color scheme
	syntax enable         " enable syntax highlighting
	" Set transparent background
	" hi Normal guibg=NONE ctermbg=NONE

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
	set splitright                 " create new vertical splits to the right
	set splitbelow                 " create new horizontal splits below
	set scrolloff=6                " lines of margin between the cursor and top-bottom of document
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
		" Split panel bindings.
		" Create splits with leader and movement key
		noremap <Leader><C-l> :belowright vsplit<CR>
		noremap <Leader><C-h> :aboveleft vsplit<CR>
		noremap <Leader><C-j> :belowright split<CR>
		noremap <Leader><C-k> :aboveleft split<CR>

		"Close split with leader and shift movement key
		noremap <Leader><S-l> <C-w><C-l> :q <CR>
		noremap <Leader><S-h> <C-w><C-h> :q<CR>
		noremap <Leader><S-j> <C-w><C-j> :q<CR>
		noremap <Leader><S-k> <C-w><C-k> :q<CR>

		" Move between split panels with leader + movement
		nnoremap <Leader>h <C-w>h
		nnoremap <Leader>j <C-w>j
		nnoremap <Leader>k <C-w>k
		nnoremap <Leader>l <C-w>l

		"Move between buffers with leader and arrows
		nnoremap <C-Left> :bprevious <CR>
		nnoremap <C-Right> :bnext <CR>
		" Edit vimrc in a split panel
		"nnoremap <Leader>ev :vsplit <CR> :wincmd l <CR> :e $MYVIMRC <CR>
		nnoremap <Leader>ev :botright vnew $MYVIMRC<CR>

		" Toggle NerdTree
		nnoremap <Leader>b :NERDTreeToggle <CR>
		" Toggle NerdTree
		nnoremap <Leader>f :NERDTreeFind <CR>

		" Re-syntax highlight
		nnoremap <Leader>s :syntax on <CR>
		" Toggle wordwrap
		nnoremap <Leader>tw :set wrap! <CR>
		" Clear search
		nnoremap <Leader><Esc> :nohlsearch<CR>

		" Open buffer in new tab
		nnoremap <Leader>t :tabedit %<CR>

		"Easier saving.
		nnoremap <Leader>ww :w<CR>
		nnoremap <Leader>w :w<CR>
		nnoremap <Leader>wq :w<CR> :Bdelete<CR>

		"Power navigation, by Andrew Radev
		nnoremap H 5h
		nnoremap J 5j
		nnoremap K 5k
		nnoremap L 5l

		" Bdelete
		nnoremap <Leader>q :Bdelete<CR>
	" }}}

	" Insert mode {{{
		" Nothing to see here. Hint: inoremap
		inoremap jj <Esc>
	"}}}

	" Visual mode {{{
		"Power navigation, by Andrew Radev
		xnoremap H 5h
		xnoremap J 5j
		xnoremap K 5k
		xnoremap L 5l
	"}}}


	" Everywhere {{{
		" Nothing to see here. Hint: noremap
	" }}}
"}}}

" Linting {{{
	"set statusline +=%#warningmsg#
	"set statusline +=%{SyntasticStatuslineFlag()}
	"set statusline +=%*
	let g:syntastic_always_populate_loc_list = 1
	let g:syntastic_auto_loc_list = 0
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

" ProSession {{{
		let g:prosession_tmux_title = 1      "Report title to tmux
		let g:prosession_on_startup = 1 "Recover last session
		let g:prosession_last_session_dir = '~'
" }}}
" vim vim:foldmethod=marker:foldlevel=0
