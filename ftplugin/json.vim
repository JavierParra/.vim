" Remaps {{{
	" We use jq (https://stedolan.github.io/jq/) to format json.
	" Format json buffer
	nnoremap <buffer> <Leader>fj :1,$!jq '.'<CR>
" }}}
