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

" Denite {{{

	" Mappings in options window
	autocmd FileType denite call s:denite_my_settings()
	function! s:denite_my_settings() abort
		" Perform the default action on enter
		nnoremap <silent><buffer><expr> <CR>
					\ denite#do_map('do_action')
		" Choose action
		nnoremap <silent><buffer><expr> <tab>
					\ denite#do_map('choose_action')
		" Preview option
		nnoremap <silent><buffer><expr> p
					\ denite#do_map('do_action', 'preview')
		" Close denite with
		nnoremap <silent><buffer><expr> <Esc>
					\ denite#do_map('quit')
		" Go to filter
		nnoremap <silent><buffer><expr> i
					\ denite#do_map('open_filter_buffer')
	endfunction

	" Mappings in filter window
	autocmd FileType denite-filter call s:denite_filter_my_settings()
	function! s:denite_filter_my_settings() abort
		imap <silent><buffer> <tab> <Plug>(denite_filter_update)
		inoremap <silent><buffer><expr> <CR>
					\ denite#do_map('do_action')
		" inoremap <silent><buffer><expr> <Esc>
		" \ denite#do_map('quit')
		nnoremap <silent><buffer><expr> <Esc>
					\ denite#do_map('quit')

		" Move options window cursor in filter window.
		inoremap <silent><buffer> <C-j>
					\ <Esc><C-w>p:call cursor(line('.')+1,0)<CR><C-w>pA
		inoremap <silent><buffer> <C-k>
					\ <Esc><C-w>p:call cursor(line('.')-1,0)<CR><C-w>pA
	endfunction


	call denite#custom#source(
				\ 'file_mru', 'matchers', ['matcher/substring', 'matcher/ignore_globs'])

	call denite#custom#source(
				\ 'file/rec', 'matchers', ['matcher/substring', 'matcher/ignore_globs'])

	call denite#custom#source(
				\ 'file/rec', 'sorters', ['sorters/sublime'])

	call denite#custom#var('file/rec', 'command',
				\ ['find', '-L', ':directory',
				\ '-path', '*/.git/*', '-prune', '-o',
				\ '-path', '*/node_modules/*', '-prune', '-o',
				\ '-path', '*/vendor/*', '-prune', '-o',
				\ '-path', '*/build/*', '-prune', '-o',
				\ '-path', '*/.next/*', '-prune', '-o',
				\ '-path', '*/database/data/*', '-prune', '-o',
				\ '-path', '*/venv/*', '-prune', '-o',
				\ '-path', '*/__pycache__/*', '-prune', '-o',
				\ '-path', '*/coverage/*', '-prune', '-o',
				\ '-path', '*/*.map', '-prune', '-o',
				\ '-type', 'l', '-print', '-o',
				\ '-type', 'f', '-print'])

	call denite#custom#var('prosession', 'format', 'split')

	" Use ripgrep instead of grep for searching
	call denite#custom#var('grep', 'command', ['rg'])

	" Custom options for ripgrep
	"   --vimgrep:  Show results with every match on it's own line
	"   --hidden:   Search hidden directories and files
	"   --heading:  Show the file name above clusters of matches from each file
	"   --S:        Search case insensitively if the pattern is all lowercase
	call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

	" Recommended defaults for ripgrep via Denite docs
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
	call denite#custom#var('grep', 'separator', ['--'])
	call denite#custom#var('grep', 'final_opts', [])

	" _ applies the options to all buffer names.
	call denite#custom#option('_', {
				\ 'auto_accel': v:true,
				\ 'reversed': v:true,
				\ 'auto_resize': v:true,
				\ 'cursor_wrap': v:true,
				\ 'start_filter': v:true,
				\ 'floating_preview': v:true,
				\ 'highlight_matched_char': 'Keyword',
				\ 'highlight_matched_range': 'Comment',
				\ })

	call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
				\ [
				\ '*~', '*.o', '*.exe', '*.bak',
				\ '.DS_Store', '*.pyc', '*.sw[po]', '*.class',
				\ '.hg/', '.git/', '.bzr/', '.svn/',
				\ 'node_modules/', 'venv/', '__pycache__/', 'dist/', 'build/', 'vendor/',
				\ 'tags', 'tags-*'
				\])
" }}}

" {{{ LanguageClient
	let g:LanguageClient_serverCommands = {
				\ 'javascript': ['tsserver'],
				\ 'typescript': ['tsserver'],
				\ 'typescript.jsx': ['tsserver'],
				\}
" }}}

" VimWiki {{{
	let g:vimwiki_hl_headers=1       " Highlight headers
	let g:vimwiki_hl_cb_checked=1    " Highlight completed items
	let g:vimwiki_folding='expr'     " Fold sections and code
	let g:vimwiki_table_mappings = 0 " Disable table maps which remap <tab>

	let g:vimwiki_list = [
				\{
				\'path': '~/Dropbox/vimwiki',
				\'syntax': 'markdown',
				\ 'ext': '.md'
				\},
				\]

	augroup wiki_toc
		autocmd! BufWritePre *.wiki :VimwikiTOC
	augroup END

" }}}

" Terminal {{{
	" tnoremap <Esc> <C-\><C-n>
	" tnoremap jk <C-\><C-n>

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

" Firenvim {{{
	" if exists('g:started_by_firenvim')

		" Open the command line with the command to set the font and size. Missing
		" <CR> on purpose so you can edit the size.
		" nnoremap <leader>fs :set guifont=Hack\ Nerd\ Font:h14

		" augroup firenvimShopifyConf
		" 	autocmd! BufEnter *.myshopify.com_admin-themes-*-code-asset-*.txt set filetype=liquid.html
		" augroup END
	" endif
" }}}

" LaTex {{{
" }}}

" {{{ Markdown Composer
	let g:markdown_composer_autostart=0
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
