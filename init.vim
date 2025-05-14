lua <<EOF
	local winbar = require("winbar")
	winbar.setSeparators("", "")
	winbar.set({"%2(%M%)%t "}, { "[%n]: %Y "})
EOF

" Package manager {{{
	lua require('config.options')
	lua require('config.keymaps')
	lua require('config.lazy')
	lua require('config.commands')
"}}}

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


" Terminal {{{

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

" {{{ Ultisnips
	" let g:UltiSnipsExpandTrigger='<NULL>'
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
" vim vim:foldmethod=marker:foldlevel=0:noexpandtab
