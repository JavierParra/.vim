return {
	{
		"vim-airline/vim-airline-themes",
		dependencies = "vim-airline/vim-airline",
		init = function ()
			vim.g.airline_powerline_fonts = 1  -- Use powerline fonts
			-- " let g:airline_theme='monokai_tasty'
			vim.g.airline_theme='badwolf'
			vim.g['airline#extensions#tabline#enabled'] = 1
			vim.g['airline#extensions#tabline#show_buffers'] = 1
			vim.g['airline#extensions#tabline#buffer_nr_show'] = 1

			-- "spaces are allowed after tabs, but not in between
			vim.g['airline#extensions#whitespace#mixed_indent_algo'] = 2
			-- "If fileformat is utf-8[unix] do not display it
			vim.g['airline#parts#ffenc#skip_expected_string'] = 'utf-8[unix]'
			-- "Enable ale integration
			vim.g['airline#extensions#ale#enabled'] = 1

			-- " let g:airline#extensions#ale#error_symbol = get(g:, 'ale_sign_error')
			-- " let g:airline#extensions#ale#warning_symbol = get(g:, 'ale_sign_warning')
		end,
	},
}
