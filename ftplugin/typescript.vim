" Remaps {{{
	nnoremap <buffer> <C-]> :call CocActionAsync('jumpDefinition')<CR>
	" Format selected LINES as JSON.
	xnoremap <buffer> <Leader>fj :'<,'>!jq '.'<CR>
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
