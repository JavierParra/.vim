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
	set foldlevel=99      "Open all folds
	set nowrap            "Don't wrap by default
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
	set scrolloff=4                " lines of margin between the cursor and top-bottom of document
	set colorcolumn=79             " vertical ruler
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

" ctrlp (DISABLED) {{{
	" Files to exclude
	" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
	" let g:ctrlp_custom_ignore = '\/?node_modules$'
"}}}

" Fix VIM {{{
	set nobackup          " Don't create backup
	set noswapfile        " Disable swap files
	set hidden            " Enables switching buffers without saving
	set clipboard=unnamed " Syncs VIMs clipboard with OSX's
	set shortmess+=c      " Hide 'user defined completion pattern not found'

	" Ignore patterns in listings.
	set wildignore+=node_modules
	set wildignore+=*.pyc
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

		" Create 'hard splits' (I just made that up) with Alt + movement
		" noremap <Leader><A-l> :topright vsplit<CR>
		noremap <Leader>™ :topleft vsplit<CR>
		noremap <Leader>¶ :botright split<CR>
		noremap <Leader>§ :topleft split<CR>

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

		" * stays in the same place
		nnoremap * *``

		" Scroll by 2 lines using ctl + movement
		nnoremap <C-j> 2<C-e>
		nnoremap <C-k> 2<C-y>

		" Bind Denite
		nnoremap <silent> <C-p> :Denite file/rec<CR>
		nnoremap <silent> <Leader>d  :Denite <C-d>
		nnoremap <silent> <Leader>dc :Denite colorscheme -auto-preview  <CR>
		nnoremap <silent> <Leader>dd :Denite <C-d>
		nnoremap <silent> <Leader>df :Denite file/rec<CR>
		nnoremap <silent> <Leader>db :Denite buffer<CR>
		nnoremap <silent> <Leader>dt :Denite outline<CR>
		nnoremap <silent> <Leader>dh :Denite command_history<CR>
		nnoremap <silent> <Leader>ds :Denite prosession<CR>
		nnoremap <silent> <Leader>d/ :Denite grep -resume -post-action=suspend<CR>
		nnoremap <silent> <Leader>dr :Denite register -mode=normal<CR>
	" }}}

	" Insert mode {{{
		inoremap jj <Esc>
		inoremap JJ <Esc>

		inoremap <silent> <C-r> <Esc>:Denite register -mode=normal<CR>
	"}}}

	" Visual mode {{{
		"Power navigation, by Andrew Radev
		xnoremap H 5h
		xnoremap J 5j
		xnoremap K 5k
		xnoremap L 5l
		"
		" Scroll by 2 lines using ctl + movement
		xnoremap <C-j> 1<C-e>
		xnoremap <C-k> 2<C-y>

	"}}}


	" Everywhere {{{
		" Nothing to see here. Hint: noremap
	" }}}
"}}}

" Linting {{{
	" ALE configuration
	highlight clear ALEErrorSign   " Do not draw background color in gutter error
	highlight clear ALEWarningSign " Do not draw background color in gutter waring
	let g:ale_sign_error = '💩'    " Change error sign
	" let g:ale_sign_error = '❗️'    " Change error sign
	let g:ale_sign_warning = '❕'  " Change warning sign
"}}}

" AutoCMD {{{
	" Live reload vimrc
	augroup vimrc
		autocmd! BufWritePost $MYVIMRC,~/.vim/vimrc source $MYVIMRC | echom "Reloaded " . $MYVIMRC | redraw
	augroup END

	" Always show the gutter to prevent shifting
	augroup addsign
		function! DummySign()
			sign define dummy
			execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
		endfunction

		autocmd! BufEnter * call DummySign()
	augroup END
"}}}

" Fugitive {{{
	set diffopt+=vertical  " Force Gdiff to split vertically
"}}}

" Airline {{{
	let g:airline_powerline_fonts = 1 "Use powerline fonts
	let g:airline_theme='badwolf'
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#show_buffers = 1
	let g:airline#extensions#tabline#buffer_nr_show = 1

	"spaces are allowed after tabs, but not in between
	let g:airline#extensions#whitespace#mixed_indent_algo=2
	"If fileformat is utf-8[unix] do not display it
	let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
	"Disable YCM error reporting
	let g:airline#extensions#ycm#enabled = 0
	"Enable ale integration
	let g:airline#extensions#ale#enabled = 1

	" let g:airline#extensions#ale#error_symbol = get(g:, 'ale_sign_error')
	" let g:airline#extensions#ale#warning_symbol = get(g:, 'ale_sign_warning')
"}}}

" ProSession {{{
	let g:prosession_tmux_title = 0 "Report title to tmux
	let g:prosession_on_startup = 1 "Recover last session
	let g:prosession_last_session_dir = '~'
"}}}

" Emmet {{{
	let g:user_emmet_install_global = 0 " Disable globally
	augroup emmet
		" Clear the current group so it doesn't pile up
		autocmd!
		autocmd FileType html,php EmmetInstall
		" autocmd FileType html imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
	augroup END
"}}}

" Editorconfig {{{
	let g:EditorConfig_exclude_patterns = ['fugitive://.*']
	let g:EditorConfig_disable_rules = ['tab_width']
"}}}

" {{{ You Complete Me
	" Use whichever python3 is found in the path
	let g:ycm_python_binary_path = 'python3'

	" Use ctags file to autocomplete.
	let g:ycm_collect_identifiers_from_tags_files=1

	" Leave preview window open after select but close it after leaving
	" insert mode
	let g:ycm_autoclose_preview_window_after_completion=0
	let g:ycm_autoclose_preview_window_after_insertion=1

	let g:ycm_enable_diagnostic_signs=0 " Do not try to lint, we have ale for that

	" Try to always load semantic completion
	let g:ycm_semantic_triggers =  {
		\	'python': ['re!\w{2}']
	\}
"}}}

" Denite {{{
	call denite#custom#source(
		\ 'file/rec', 'matchers', ['matcher/fuzzy', 'matcher/ignore_globs'])

	call denite#custom#source(
		\ 'file/rec', 'sorters', ['sorter/rank'])

	call denite#custom#var('file/rec', 'command',
		\ ['find', '-L', ':directory',
		\ '-path', '*/.git/*', '-prune', '-o',
		\ '-path', '*/node_modules/*', '-prune', '-o',
		\ '-path', '*/venv/*', '-prune', '-o',
		\ '-path', '*/__pycache__/*', '-prune', '-o',
		\ '-type', 'l', '-print', '-o',
		\ '-type', 'f', '-print'])

	call denite#custom#var('prosession', 'format', 'split')

	call denite#custom#map(
		\ 'insert',
		\ '<Down>',
		\ '<denite:move_to_next_line>',
		\ 'noremap'
		\)

	call denite#custom#map(
		\ 'insert',
		\ '<Up>',
		\ '<denite:move_to_previous_line>',
		\ 'noremap'
		\)

	call denite#custom#map(
		\ 'insert',
		\ '<C-j>',
		\ '<denite:move_to_next_line>',
		\ 'noremap'
		\)
	call denite#custom#map(
		\ 'insert',
		\ '<C-k>',
		\ '<denite:move_to_previous_line>',
		\ 'noremap'
		\)

	call denite#custom#option('default', {
		\ 'auto_accel': v:true,
		\ 'reversed': v:true,
		\ 'auto_resize': v:true,
		\ 'cursor_wrap': v:true,
		\ 'highlight_matched_char': 'Keyword',
		\ 'highlight_matched_range': 'Comment',
		\ })

	call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
		\ [
		\ '*~', '*.o', '*.exe', '*.bak',
		\ '.DS_Store', '*.pyc', '*.sw[po]', '*.class',
		\ '.hg/', '.git/', '.bzr/', '.svn/',
		\ 'node_modules/', 'venv/', '__pycache__/',
		\ 'tags', 'tags-*'
		\])
" }}}
" vim vim:foldmethod=marker:foldlevel=0
