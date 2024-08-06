local DIAGNOSTICS_SIGNS = {
	ERROR = '💩',
	WARN = '❕',
	INFO = 'ℹ',
	HINT = '❔',
}

-- simple alias
local setKey = vim.keymap.set

local function configNative()
	-- Set the updatetime for `CursorHold` (also affects the swap file) but we've
	-- disabled that in our main config
	vim.opt.updatetime = 500

	-- Always show the signcolumn, otherwise it would shift the text each time
	-- diagnostics appeared/became resolved
	vim.opt.signcolumn = "yes"

	-- ALE overrides this. Hacky workaround below
	vim.diagnostic.config({
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = DIAGNOSTICS_SIGNS.ERROR,
				[vim.diagnostic.severity.WARN] = DIAGNOSTICS_SIGNS.WARN,
				[vim.diagnostic.severity.INFO] = DIAGNOSTICS_SIGNS.INFO,
				[vim.diagnostic.severity.HINT] = DIAGNOSTICS_SIGNS.HINT,
			}
		}
	})
end

local function configALE()
	vim.g.ale_sign_error = DIAGNOSTICS_SIGNS.ERROR
	vim.g.ale_sign_warning = DIAGNOSTICS_SIGNS.WARN
	vim.g.ale_set_highlights = 0            -- Disable ALE highlights
	vim.g.ale_use_neovim_diagnostics_api = 1 -- Render using native diagnostics
	vim.g.ale_fix_on_save = 0               -- Disable fix on save. ftplugins will enable if needed
	vim.g.ale_pattern_options = {
		['\\.min\\.js$'] = { ale_linters = {}, ale_fixers = {} },
		['\\.min\\.css$'] = { ale_linters = {}, ale_fixers = {} },
	}
end

local function configCoc()
	local function check_back_space()
		local col = vim.fn.col('.') - 1
		if (col == 0) then
			return true
		end
		---@diagnostic disable-next-line param-type-mismatch
		local line = vim.fn.getline('.')

		if (type(line) ~= 'string') then
			return false
		end

		return line:sub(col, col):match('%s')
	end

	local function tabKey()
		if vim.fn['coc#pum#visible']() then
			return vim.fn['coc#_select_confirm']()
		elseif vim.fn['coc#expandableOrJumpable']() then
			return vim.fn['coc#rpc#request']('doKeymap', { 'snippets-expand-jump', '' })
		elseif check_back_space() then
			return "<TAB>"
		else
			return vim.fn['coc#refresh']()
		end
	end
	-- Define the show_documentation function
	local function help()
		if vim.api.nvim_eval('index(["vim", "help"], &filetype)') >= 0 then
			vim.api.nvim_command('h ' .. vim.fn.expand('<cword>'))
		else
			vim.fn.CocActionAsync('doHover')
		end
	end

	setKey('i', '<TAB>', tabKey, { expr = true, silent = true })

	setKey('i', '<Down>', 'coc#pum#visible() ? coc#pum#next(1) : "<Down>"', { expr = true })
	setKey('i', '<Up>', 'coc#pum#visible() ? coc#pum#prev(1) : "<Up>"', { expr = true })

	--  Use <c-space> to trigger completion.
	setKey('i', '<C-Space>', 'coc#start()', { expr = true, silent = true })

	-- Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
	-- Coc only does snippet and additional edit on confirm.
	setKey('i', '<CR>', 'coc#pum#visible() ? coc#_select_confirm() : "\\<C-g>u\\<CR>"', { expr = true })
	setKey('i', '<C-r>', 'coc#pum#visible() ? coc#refresh() : "\\<C-r>"', { expr = true })

	--  Rename symbol
	setKey('n', '<Leader>rn', '<Plug>(coc-rename)')
	setKey('n', '<Leader>rf', function() vim.fn.CocAction('refactor') end)

	setKey('n', '<C-h>', help)
	setKey('n', '<Leader>cr', function() vim.cmd('CocRestart') end)
end

local function setupAutoCommands()
	local function showHover()
		local diagnosticsWin = vim.diagnostic.open_float({
			scope = 'cursor',
			focusable = false,
		})

		-- Only show hover information if there's no diagnostic message
		if (diagnosticsWin ~= nil) then
			return
		end

		-- This gets old reaaall fast
		-- if (vim.fn.exists('*CocAction') and vim.fn.CocAction('hasProvider', 'hover')) then
		-- 	-- If we have CocAction then we have CocActionAsync
		-- 	vim.fn.CocActionAsync('doHover')
		-- end
	end

	vim.api.nvim_create_augroup('Diagnostics', {})
	vim.api.nvim_create_autocmd('CursorHold', {
		group = 'Diagnostics',
		callback = showHover,
	})

	-- Hacky solution to add my symbols to ALE generated diagnostics
	vim.api.nvim_create_autocmd('User', {
		pattern = 'ALELintPost',
		group = 'Diagnostics',
		callback = function()
			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = DIAGNOSTICS_SIGNS.ERROR,
						[vim.diagnostic.severity.WARN] = DIAGNOSTICS_SIGNS.WARN,
						[vim.diagnostic.severity.INFO] = DIAGNOSTICS_SIGNS.INFO,
						[vim.diagnostic.severity.HINT] = DIAGNOSTICS_SIGNS.HINT,
					}
				}
			})
		end,
	})
end


return {
	setup = function()
		configNative()
		configALE()
		configCoc()
		setupAutoCommands()
	end
}
