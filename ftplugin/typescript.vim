" Remaps {{{
	nnoremap <buffer> <C-]> :Telescope coc definitions<CR>
	" Format selected LINES as JSON.
	xnoremap <buffer> <Leader>fj :'<,'>!jq '.'<CR>

	nnoremap <buffer> <Leader>pw :!npx prettier --write % && npx eslint --fix %<CR>
" }}}
" Linting {{{
	" let b:ale_fixers = {
	" 	\ 'typescript': ['eslint'],
	" 	\ 'typescript.jsx': ['eslint'],
	" \}

	let b:ale_fixers = ['eslint']
	" let b:ale_linters = {
	" 	\'typescript': ['tsserver'],
	" 	\'typescript.jsx': ['tsserver'],
	" \}
" }}}
