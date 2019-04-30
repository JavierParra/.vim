" Remaps {{{
	nnoremap <buffer> <C-]> :ALEGoToDefinition<CR>
" }}}

" Linting {{{
	let b:ale_linters = {
		\'typescript': ['tsserver'],
		\'typescript.jsx': ['tsserver'],
	\}
" }}}
