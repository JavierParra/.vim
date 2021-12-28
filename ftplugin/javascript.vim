" Remaps {{{
	nnoremap <buffer> <C-]> :Telescope coc implementations<CR>
	" Format selected LINES as JSON.
	xnoremap <buffer> <Leader>fj :'<,'>!jq '.'<CR>
" }}}

" Linting {{{
	let b:ale_fixers = ['eslint']
" }}}
