" Remaps {{{
	nnoremap <buffer> <C-]> :Telescope coc definitions<CR>

	nnoremap <buffer> <Leader>pw :!npx prettier --write % && npx eslint --fix %<CR>

	" Format selected LINES as JSON.
	xnoremap <buffer> <Leader>fj :'<,'>!jq '.'<CR>
" }}}

" Linting {{{
	let b:ale_fixers = ['eslint']
" }}}
