" Pathogen {{{
	execute pathogen#infect()
"}}}

" General Settings {{{
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
	set title              " Set the terminal's title to the current file
	set shell=/bin/bash    " My zsh is too slow at the moment.
" }}}

" Colors {{{
	syntax enable         " enable syntax highlighting
	" Set transparent background
	" hi Normal guibg=NONE ctermbg=NONE

	" vertical separator for panels
	set fillchars+=vert:│

	" Helper function to set highlight. Stolen directly from monokai_tasty
	" https://github.com/patstockwell/vim-monokai-tasty/blob/master/colors/vim-monokai-tasty.vim
	function! Highlight(group, fg, bg, style)
		exec "hi " . a:group
					\ . " ctermfg=" . a:fg["cterm"]
					\ . " ctermbg=" . a:bg["cterm"]
					\ . " cterm=" . a:style["cterm"]
					\ . " guifg=" . a:fg["gui"]
					\ . " guibg=" . a:bg["gui"]
					\ . " gui=" . a:style["gui"]
	endfunction

	function! OverrideMonokai() abort
		" Variables from monokai_tasty
		if g:vim_monokai_tasty_italic
			let s:italic = { "cterm": "italic", "gui": "italic" }
		else
			let s:italic = { "cterm": "NONE", "gui": "NONE" }
		endif

		let s:yellow = { "cterm": 228, "gui": "#ffff87" }
		let s:purple = { "cterm": 141, "gui": "#af87ff" }
		let s:light_green = { "cterm": 148, "gui": "#A4E400" }
		let s:light_blue = { "cterm": 81, "gui": "#62D8F1" }
		let s:magenta = { "cterm": 197, "gui": "#FC1A70" }
		let s:orange = { "cterm": 208, "gui": "#FF9700" }

		" Search colours. Specifically not in the monokai palette so that they will
		" stand out.
		let s:black = { "cterm": 232, "gui": "#000000" }
		let s:bright_yellow = { "cterm": 220, "gui": "yellow" }

		" Monochrome in order light -> dark
		let s:white = { "cterm": 231, "gui": "#ffffff" }
		let s:light_grey = { "cterm": 250, "gui": "#bcbcbc" }
		let s:grey = { "cterm": 245, "gui": "#8a8a8a" }
		let s:dark_grey = { "cterm": 59, "gui": "#5f5f5f" }
		let s:darker_grey = { "cterm": 238, "gui": "#444444" }
		let s:light_charcoal = { "cterm": 238, "gui": "#2b2b2b" }
		let s:charcoal = { "cterm": 235, "gui": "#262626" }

		" Git diff colours.
		let s:danger = { "cterm": 197, "gui": "#ff005f" }
		let s:olive = { "cterm": 64, "gui": "#5f8700" }
		let s:dark_red = { "cterm": 88, "gui": "#870000" }
		let s:blood_red = { "cterm": 52, "gui": "#5f0000" }
		let s:dark_green = { "cterm": 22, "gui": "#005f00" }
		let s:bright_blue = { "cterm": 33, "gui": "#0087ff" }
		let s:purple_slate = { "cterm": 60, "gui": "#5f5f87" }

		let s:none = { "cterm": "NONE", "gui": "NONE" }
		let s:bold = { "cterm": "bold", "gui": "bold" }
		let s:underline = { "cterm": "underline", "gui": "underline" }
		let s:bold_underline = { "cterm": "bold,underline", "gui": "bold,underline" }"

		" make visual selection more readable
		hi Visual ctermbg=240 ctermfg=NONE
		hi Search ctermbg=228 ctermfg=232 cterm=bold,italic

		" I like this colors
		hi ColorColumn     ctermbg=238
		hi SignColumn      ctermbg=235
		" The line number where the cursor is
		hi CursorLineNr    ctermfg=208 ctermbg=236
		hi LineNr          ctermfg=242
		hi CursorLine      ctermbg=236

		call Highlight("typescriptBraces", s:light_green, s:none, s:none)
		call Highlight("tsxAttributeBraces", s:magenta, s:none, s:none)
		call Highlight("tsxTag", s:light_grey, s:none, s:none)
		call Highlight("tsxCloseTag", s:grey, s:none, s:none)

		call Highlight("gitcommitSummary", s:magenta, s:none, s:none)
		call Highlight("gitcommitOverflow", s:white, s:none, s:none)

		call Highlight("gitcommitSelectedFile", s:light_green, s:none, s:none)
		call Highlight("gitcommitDiscardedFile", s:magenta, s:none, s:none)

		hi def link tsxAttrib jsxAttrib
		hi def link tsxEqual jsxEqual
	endfunction

	" Override colorscheme on an augroup: https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f
	augroup ColorOverride
		autocmd!
		autocmd! ColorScheme vim-monokai-tasty call OverrideMonokai()
	augroup END

	" Define the colorscheme after the autocmd
	let g:vim_monokai_tasty_italic = 1
	colorscheme vim-monokai-tasty " the color scheme
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
	set cursorline                 " highlights the current line. Disabled because it's set in an autocmd
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
	set incsearch          " immediate search
	set hlsearch           " highlight search matches
	set ignorecase         " case insensitive search
	set smartcase          " if the search string has mixed case, search becomes case sensitive
	set inccommand=nosplit " preview replace inline
" }}}

" Invisible characters {{{
	set list                                         " Show invisible charactes.
	set listchars=tab:￫―,nbsp:·,extends:⇀,precedes:↼ " The characters that the invisible will show as.
" }}}

" Fix VIM {{{
	set backupdir=~/.local/share/nvim/backup
	set backup                " Create backups in the above dir
	set noswapfile            " Disable swap files
	set hidden                " Enables switching buffers without saving
	set clipboard=unnamedplus " Syncs VIMs clipboard with the OS's
	set shortmess+=c          " Hide 'user defined completion pattern not found'

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

		" Toggle spellcheck
		nnoremap <silent><Leader>s :set spell!<CR>
		" Move between split panels with leader + movement
		nnoremap <Leader>h <C-w>h
		nnoremap <Leader>j <C-w>j
		nnoremap <Leader>k <C-w>k
		nnoremap <Leader>l <C-w>l

		"Move between buffers with arrows
		nnoremap <Left> :bprevious <CR>
		nnoremap <Right> :bnext <CR>

		"Move between tabs with control and arrows
		nnoremap <C-Left> :tabprevious <CR>
		nnoremap <C-Right> :tabnext <CR>
		" Edit vimrc in a split panel
		"nnoremap <Leader>ev :vsplit <CR> :wincmd l <CR> :e $MYVIMRC <CR>
		" nnoremap <Leader>ev :botright vnew $MYVIMRC<CR>

		" Hardcode the path to vimrc because we use nvim interchangeably.
		nnoremap <Leader>ev :botright vnew ~/.vim/vimrc<CR>

		" Toggle NerdTree
		nnoremap <Leader>fb :NERDTreeToggle <CR>
		nnoremap <Leader>ft :NERDTreeToggle <CR>

		" Open NerdTree
		nnoremap <Leader>fo :NERDTreeFocus <CR>

		" Open NerdTree
		nnoremap <Leader>fc :NERDTreeClose <CR>

		" Focus file in NerdTree
		nnoremap <Leader>ff :NERDTreeFind <CR>

		" Edit new file in the current directory
		nnoremap <Leader>fN :edit %:h/

		" Copy the current file's name
		nnoremap <Leader>fn :!echo -n %:t:r \| pbcopy <CR>
		" Copy the current file's path
		nnoremap <Leader>fp :!echo % \| pbcopy <CR>
		" Re-syntax highlight
		" nnoremap <Leader>s :syntax on <CR>

		" Toggle wordwrap on word boundary
		nnoremap <Leader>tw :set wrap! lbr <CR>
		" Use j and k to move by visual lines only if there's no count modifier.
		nnoremap <expr> j v:count ? 'j' : 'gj'
		nnoremap <expr> k v:count ? 'k' : 'gk'

		" Clear search
		nnoremap <Leader><Esc> :nohlsearch<CR>

		" Open buffer in new tab
		nnoremap <Leader>te :tabedit %<CR>

		"Easier saving.
		nnoremap <Leader>ww :w<CR>
		nnoremap <Leader>w :w<CR>
		nnoremap <Leader>wq :w<CR> :Bdelete<CR>

		"Power navigation, by Andrew Radev
		nnoremap <C-h> 5h
		nnoremap <C-j> 5j
		nnoremap <C-k> 5k
		nnoremap <C-l> 5l

		" Close the buffer keeping the window.
		nnoremap <Leader>q :Bdelete<CR>
		" Close the buffer and the window.
		nnoremap <Leader>Q :bdelete<CR>
		" Wipe all buffers
		nnoremap <Leader>bw :%bwipe<CR>

		" * stays in the same place
		nnoremap * *``

		" Scroll by 2 lines using shift + movement
		nnoremap J 2<C-e>
		nnoremap K 2<C-y>

		" Scroll horizontally
		nnoremap L 2z<Right>
		nnoremap H 2z<Left>

		" Bind Denite
		nnoremap <silent> <C-p> :Denite buffer file/rec<CR>
		nnoremap <silent> <Leader>d  :Denite source<CR>
		nnoremap <silent> <Leader>dc :Denite colorscheme -auto-action=preview <CR>
		nnoremap <silent> <Leader>df :Denite file/rec<CR>
		nnoremap <silent> <Leader>db :Denite buffer<CR>
		nnoremap <silent> <Leader>dt :Denite outline<CR>
		nnoremap <silent> <Leader>dh :Denite command_history<CR>
		nnoremap <silent> <Leader>ds :Denite prosession<CR>
		nnoremap <silent> <Leader>d/ :Denite grep -buffer-name=grep<CR>
		nnoremap <silent> <Leader>dn :Denite grep -buffer-name=grep -resume -cursor-pos=+1 -mode=normal -post-action=suspend<CR>
		nnoremap <silent> <Leader>dN :Denite grep -buffer-name=grep -resume -cursor-pos=-1 -mode=normal -post-action=suspend<CR>
		nnoremap <silent> <Leader>dr :Denite register<CR>

		" Not actually Denite but kinkd of the same.
		nnoremap <silent> <Leader>do :CocList outline<CR>
		" Rename symbol
		nmap <leader>rn <Plug>(coc-rename)
		"
		" Find references
		nmap <leader>fr <Plug>(coc-references)

		" VimWiki
		nmap <Leader>vww <Plug>VimwikiIndex
		nmap <Leader>vws <Plug>VimwikiUISelect

		" Open terminal
		if has('nvim')
			nnoremap <Leader>< :botright split\|resize 20\|terminal zsh<CR>
		else
			set termwinsize=20x0
			nnoremap <Leader>< :botright terminal zsh<CR>
		endif

		" Common foldlevels
		nnoremap <Leader>zl0 :set foldlevel=0<CR>
		nnoremap <Leader>zl1 :set foldlevel=1<CR>
		nnoremap <Leader>zl2 :set foldlevel=2<CR>
		nnoremap <Leader>zl3 :set foldlevel=3<CR>
		nnoremap <Leader>zl4 :set foldlevel=4<CR>

		nnoremap <Leader>zl :set foldlevel=

		" Fugitive
		nnoremap <Leader>gs :Gstatus<CR>
		nnoremap <Leader>gb :Gblame<CR>
		nnoremap <Leader>gp :Git pull<CR>
		nnoremap <Leader>gd :Gdiff<CR>
		nnoremap <Leader>gc :Git checkout

		" Join the current line with the previous one.
		nnoremap <BS> kJ

		" Vista outline
		nnoremap <Leader>vo :Vista!!<CR>

		" It's way too easy to hit this instead of >> and we have <Leader>q
		nnoremap ZZ <Nop>
	" }}}

	" Insert mode {{{
		inoremap jk <Esc>

		" inoremap <silent> <C-r> <Esc>:Denite register -mode=normal<CR>

		" COC
		" Use tab for trigger completion with characters ahead and navigate.
		" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
		inoremap <silent><expr> <TAB>
					\ pumvisible() ? "\<C-n>" :
					\ <SID>check_back_space() ? "\<TAB>" :
					\ coc#refresh()
		inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

		" Use <c-space> to trigger completion.
		inoremap <silent><expr> <c-space> coc#refresh()

		" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
		" Coc only does snippet and additional edit on confirm.
		inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
	"}}}

	" Visual mode {{{
		"Power navigation, by Andrew Radev
		xnoremap <C-h> 5h
		xnoremap <C-j> 5j
		xnoremap <C-k> 5k
		xnoremap <C-l> 5l

		" Scroll by 2 lines using shift + movement
		xnoremap J 2<C-e>
		xnoremap K 2<C-y>

		" Scroll horizontally
		xnoremap L 2z<Right>
		xnoremap H 2z<Left>

		" Format selection as json.
		xnoremap <Leader>jf :'<,'>!jq '.'<CR>

		" Use j and k to move by visual lines only if there's no count modifier.
		xnoremap <expr> j v:count ? 'j' : 'gj'
		xnoremap <expr> k v:count ? 'k' : 'gk'

		" Search for selected text
		vnoremap * y/\V<C-R>=escape(@",'/\')<CR><CR>

		" Paste without yanking the deleted text. This is buggy
		" vnoremap p "_dP
	"}}}

	" Everywhere {{{
		" Nothing to see here. Hint: noremap
	" }}}

	" Command Line remaps {{{
		" Hint: cnoremap
		cnoremap alv qa!
	" }}}
"}}}

" Linting {{{
	" ALE configuration
	highlight clear ALEErrorSign   " Do not draw background color in gutter error
	highlight clear ALEWarningSign " Do not draw background color in gutter waring
	let g:ale_sign_error = '💩'    " Change error sign
	" let g:ale_sign_error = '❗️'    " Change error sign
	let g:ale_sign_warning = '❕'  " Change warning sign
	let g:ale_set_highlights = 0   " Disable highlight

	" Disable ALE for minified files
	let g:ale_pattern_options = {
	\ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
	\ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
	\}
"}}}

" AutoCMD {{{
	" Live reload vimrc
	augroup vimrc
		autocmd! BufWritePost $MYVIMRC,~/.vim/vimrc nested source $MYVIMRC | echom "Reloaded " . $MYVIMRC | redraw
	augroup END

	" Always show the gutter to prevent shifting
	augroup addsign
		function! DummySign()
			" define dummy sign with non breaking space
			sign define dummy text= 
			execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
		endfunction

		autocmd! BufEnter * call DummySign()
	augroup END

	" Only show cursorline on the active buffer
	function! WinEnter() abort
		let nocursor = ['denite-filter']

		if index(nocursor, &ft) >= 0
			set nocursorline
		else
			set cursorline
		endif
	endfunction

	function! WinLeave() abort
		let keepcursor = ['denite', 'fugitiveblame']

		if index(keepcursor, &ft) >= 0
			set cursorline
		else
			set nocursorline
		endif
	endfunction


	augroup curline
		autocmd! WinEnter * call WinEnter()
		autocmd! WinLeave * call WinLeave()
	augroup END

	augroup diffsearch
		function! SetFoldSearch()
			if &diff
				set fdo-=search
			endif
		endfunction

		autocmd! BufEnter * call SetFoldSearch()
	augroup END

	" Set .json to JSON5
	autocmd BufRead,BufNewFile *.json set filetype=json5

"}}}


" Fugitive {{{
	set diffopt+=vertical  " Force Gdiff to split vertically
"}}}

" Airline {{{
	let g:airline_powerline_fonts = 1 "Use powerline fonts
	" let g:airline_theme='monokai_tasty'
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
		autocmd FileType html,php,tsx,jsx EmmetInstall
		" autocmd FileType html imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
	augroup END
"}}}

" Editorconfig {{{
	let g:EditorConfig_exclude_patterns = ['fugitive://.*']
	let g:EditorConfig_disable_rules = ['tab_width']
"}}}

" {{{ You Complete Me
	" " Use whichever python3 is found in the path
	" let g:ycm_python_binary_path = 'python3'

	" " Use ctags file to autocomplete.
	" let g:ycm_collect_identifiers_from_tags_files=1

	" " Leave preview window open after select but close it after leaving
	" " insert mode
	" let g:ycm_autoclose_preview_window_after_completion=0
	" let g:ycm_autoclose_preview_window_after_insertion=1

	" let g:ycm_enable_diagnostic_signs=0 " Do not try to lint, we have ale for that

	" " Try to always load semantic completion
	" let g:ycm_semantic_triggers =  {
	" 	\	'python': ['re!\w{2}']
	" \}
"}}}

" {{{ COC

		function! s:check_back_space() abort
			let col = col('.') - 1
			return !col || getline('.')[col - 1]  =~# '\s'
		endfunction

		function! s:show_documentation()
			if (index(['vim','help'], &filetype) >= 0)
				execute 'h '.expand('<cword>')
			else
				call CocAction('doHover')
			endif
		endfunction
" }}}

" Denite {{{

	" Mappings in options window
	autocmd FileType denite call s:denite_my_settings()
	function! s:denite_my_settings() abort
		" Perform the default action on enter
		nnoremap <silent><buffer><expr> <CR>
		\ denite#do_map('do_action')
		" Choose action
		nnoremap <silent><buffer><expr> <tab>
		\ denite#do_map('choose_action')
		" Preview option
		nnoremap <silent><buffer><expr> p
		\ denite#do_map('do_action', 'preview')
		" Close denite with
		nnoremap <silent><buffer><expr> <Esc>
		\ denite#do_map('quit')
		" Go to filter
		nnoremap <silent><buffer><expr> i
		\ denite#do_map('open_filter_buffer')
	endfunction

	" Mappings in filter window
	autocmd FileType denite-filter call s:denite_filter_my_settings()
	function! s:denite_filter_my_settings() abort
		imap <silent><buffer> <tab> <Plug>(denite_filter_update)
		inoremap <silent><buffer><expr> <CR>
		\ denite#do_map('do_action')
		" inoremap <silent><buffer><expr> <Esc>
		" \ denite#do_map('quit')
		nnoremap <silent><buffer><expr> <Esc>
		\ denite#do_map('quit')

		" Move options window cursor in filter window.
		inoremap <silent><buffer> <C-j>
		\ <Esc><C-w>p:call cursor(line('.')+1,0)<CR><C-w>pA
		inoremap <silent><buffer> <C-k>
		\ <Esc><C-w>p:call cursor(line('.')-1,0)<CR><C-w>pA
	endfunction


	call denite#custom#source(
		\ 'file_mru', 'matchers', ['matcher/substring', 'matcher/ignore_globs'])

	call denite#custom#source(
		\ 'file/rec', 'matchers', ['matcher/substring', 'matcher/ignore_globs'])

	call denite#custom#source(
		\ 'file/rec', 'sorters', ['sorters/sublime'])

	call denite#custom#var('file/rec', 'command',
		\ ['find', '-L', ':directory',
		\ '-path', '*/.git/*', '-prune', '-o',
		\ '-path', '*/node_modules/*', '-prune', '-o',
		\ '-path', '*/vendor/*', '-prune', '-o',
		\ '-path', '*/build/*', '-prune', '-o',
		\ '-path', '*/.next/*', '-prune', '-o',
		\ '-path', '*/database/data/*', '-prune', '-o',
		\ '-path', '*/venv/*', '-prune', '-o',
		\ '-path', '*/__pycache__/*', '-prune', '-o',
		\ '-type', 'l', '-print', '-o',
		\ '-type', 'f', '-print'])

	call denite#custom#var('prosession', 'format', 'split')

	" Use ripgrep instead of grep for searching
	call denite#custom#var('grep', 'command', ['rg'])

	" Custom options for ripgrep
	"   --vimgrep:  Show results with every match on it's own line
	"   --hidden:   Search hidden directories and files
	"   --heading:  Show the file name above clusters of matches from each file
	"   --S:        Search case insensitively if the pattern is all lowercase
	call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

	" Recommended defaults for ripgrep via Denite docs
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
	call denite#custom#var('grep', 'separator', ['--'])
	call denite#custom#var('grep', 'final_opts', [])

	" _ applies the options to all buffer names.
	call denite#custom#option('_', {
		\ 'auto_accel': v:true,
		\ 'reversed': v:true,
		\ 'auto_resize': v:true,
		\ 'cursor_wrap': v:true,
		\ 'start_filter': v:true,
		\ 'floating_preview': v:true,
		\ 'highlight_matched_char': 'Keyword',
		\ 'highlight_matched_range': 'Comment',
		\ })

	call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
		\ [
		\ '*~', '*.o', '*.exe', '*.bak',
		\ '.DS_Store', '*.pyc', '*.sw[po]', '*.class',
		\ '.hg/', '.git/', '.bzr/', '.svn/',
		\ 'node_modules/', 'venv/', '__pycache__/', 'dist/', 'build/', 'vendor/',
		\ 'tags', 'tags-*'
		\])
" }}}

" {{{ LanguageClient
		let g:LanguageClient_serverCommands = {
			\ 'javascript': ['tsserver'],
			\ 'typescript': ['tsserver'],
			\ 'typescript.jsx': ['tsserver'],
			\}

" }}}

" {{{ Vista
	let g:vista_default_executive='coc'
" }}}

" VimWiki {{{
	let g:vimwiki_hl_headers=1       " Highlight headers
	let g:vimwiki_hl_cb_checked=1    " Highlight completed items
	let g:vimwiki_folding='expr'     " Fold sections and code
	let g:vimwiki_table_mappings = 0 " Disable table maps which remap <tab>

	let g:vimwiki_list = [
			\{
				\'path': '~/Dropbox/vimwiki',
				\'syntax': 'markdown',
				\ 'ext': '.md'
			\},
		\]

	augroup wiki_toc
		autocmd! BufWritePre *.wiki :VimwikiTOC
	augroup END

" }}}

" Terminal {{{
	" Remaps {{{
		tnoremap <Esc> <C-\><C-n>
		" tnoremap jk <C-\><C-n>
	" }}}

	" AutoCMD {{{
		augroup insertonenter
			function! InsertOnTerminal()
				if &buftype ==# "terminal"
					normal i
				endif
			endfunction

			autocmd! BufEnter * call InsertOnTerminal()
			if has('nvim')
				autocmd! TermOpen * call InsertOnTerminal()
			endif
		augroup END
	" }}}
" }}}

" Firenvim {{{
if exists('g:started_by_firenvim')
	" let w:test=1
	set showtabline=0
	let g:airline#extensions#tabline#enabled = 0
	" let g:airline_symbols_ascii = 1
	let g:airline_powerline_fonts = 0 "Use powerline fonts
	let g:airline_section_b=''
	let g:airline_section_c=''
	" let g:airline_section_x=''
	let g:airline_section_y=''
	let g:airline_section_z=''
	" set guifont=monospace:h14

	nnoremap <Esc><Esc> :w<CR> :call firenvim#focus_page()<CR>
endif
" }}}

" LaTex {{{
" }}}

" {{{ Markdown Composer
	let g:markdown_composer_autostart=0
" }}}

" {{{ Ultisnips
	let g:UltiSnipsExpandTrigger='<NULL>'
	" let g:UltiSnipsJumpForwardTrigger='<tab>'
	" let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
" }}}

" {{{ Utils
 " Show the syntax group under the cursor
	function! g:SyntaxGroup() abort
		let l:s = synID(line('.'), col('.'), 1)
		echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
	endfunction
" }}}
" vim vim:foldmethod=marker:foldlevel=0
