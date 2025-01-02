lua <<EOF
	local winbar = require("winbar")
	winbar.setSeparators("", "")
	winbar.set({" %t "}, { "[%n]: %Y "})
EOF

" Package manager {{{
	lua require('config.options')
	lua require('config.lazy')
	lua require('config.commands')
"}}}


" Remaps {{{
	" Normal mode {{{
		" Split panel bindings.
		" Create splits with leader and movement key
		noremap <Leader><C-l> :belowright vsplit<CR>
		noremap <Leader><C-h> :aboveleft vsplit<CR>
		noremap <Leader><C-j> :belowright split<CR>
		noremap <Leader><C-k> :aboveleft split<CR>

		" Create 'hard splits' (I just made that up) with Alt + movement
		noremap <Leader><M-l> :topright vsplit<CR>
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

		" Toggle NerdTree
		nnoremap <Leader>fb :silent NERDTreeToggle <CR>
		nnoremap <Leader>ft :silent NERDTreeToggle <CR>

		" Open NerdTree
		nnoremap <Leader>fo :silent NERDTreeFocus <CR>

		" Open NerdTree
		nnoremap <Leader>fc :silent NERDTreeClose <CR>

		" Focus file in NerdTree
		nnoremap <Leader>ff :silent NERDTreeFind <CR>

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

		" Close the current tab
		nnoremap <Leader>tc :tabclose<CR>

		"Easier saving.
		nnoremap <Leader>ww :w<CR>
		nnoremap <Leader>w :w<CR>
		nnoremap <Leader>wq :w<CR> :Bdelete<CR>

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
		nnoremap <Leader>zl0 :setlocal foldlevel=0<CR>
		nnoremap <Leader>zl1 :setlocal foldlevel=1<CR>
		nnoremap <Leader>zl2 :setlocal foldlevel=2<CR>
		nnoremap <Leader>zl3 :setlocal foldlevel=3<CR>
		nnoremap <Leader>zl4 :setlocal foldlevel=4<CR>

		nnoremap <Leader>zl :setlocal foldlevel=

		" Fugitive
		nnoremap <Leader>gs :Git<CR>
		nnoremap <Leader>gb :Git blame<CR>
		nnoremap <Leader>gp :Git pull<CR>
		nnoremap <Leader>gd :Git diff<CR>
		nnoremap <Leader>gc :Git checkout

		" Join the current line with the previous one.
		nnoremap <BS> kJ

		" It's way too easy to hit this instead of >> and we have <Leader>q
		nnoremap ZZ <Nop>

		nnoremap <Leader>en :ALENext<CR>
		nnoremap <Leader>ep :ALEPrevious<CR>
		nnoremap <Leader>ed :ALEDetail<CR>

		" Try to make marks a bit more usable
		noremap M m
		noremap m '


		" }}}

		" Insert mode {{{
		inoremap jk <Esc>

		" inoremap <silent> <C-r> <Esc>:Denite register -mode=normal<CR>

		" Visual mode {{{
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

		" View lines git history
		xnoremap <Leader>gb :'<,'>Flogsplit<CR>

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

		" Diagnostics {{{
		" lua require('diagnostics').setup()
		"}}}
		" Diff {{{
		" lua require('diff').setup()
		" }}}

		" AutoCMD {{{

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

		" Set .json to JSONC
		autocmd BufRead,BufNewFile *.json set filetype=jsonc

		"}}}

		" Fugitive {{{
		set diffopt+=vertical  " Force Gdiff to split vertically
		"}}}

		" ProSession {{{
		let g:prosession_tmux_title = 0 "Report title to tmux
		let g:prosession_on_startup = 1 "Recover last session
		let g:prosession_last_session_dir = '~'
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
						\ '-path', '*/coverage/*', '-prune', '-o',
						\ '-path', '*/*.map', '-prune', '-o',
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
			" if exists('g:started_by_firenvim')

				" Open the command line with the command to set the font and size. Missing
				" <CR> on purpose so you can edit the size.
				" nnoremap <leader>fs :set guifont=Hack\ Nerd\ Font:h14

				" augroup firenvimShopifyConf
				" 	autocmd! BufEnter *.myshopify.com_admin-themes-*-code-asset-*.txt set filetype=liquid.html
				" augroup END
			" endif
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
" }}}
" vim vim:foldmethod=marker:foldlevel=0:noexpandtab
