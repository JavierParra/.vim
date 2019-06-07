" Remaps {{{
	nnoremap <buffer> <C-]> :call CocActionAsync('jumpDefinition')<CR>
	" Format selected LINES as JSON.
	xnoremap <buffer> <Leader>fj :'<,'>!jq '.'<CR>
" }}}
