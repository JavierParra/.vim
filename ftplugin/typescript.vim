" Remaps {{{
	" nnoremap <buffer> <C-]> :Telescope coc definitions<CR>
	" Format selected LINES as JSON.
	xnoremap <buffer> <Leader>fj :'<,'>!jq '.'<CR>

	" nnoremap <buffer> <Leader>pw :!npx prettier --write % && npx eslint --fix %<CR>
	" nnoremap <buffer> <Leader>pw :ALEFix<CR>
" }}}
" Linting {{{
"	let b:ale_fixers = ['eslint', 'prettier']
"	let b:ale_linters = ['eslint']
"	let b:ale_fix_on_save = 0 " fix on save is really annoying
" }}}
