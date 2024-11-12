local function setup ()
	local setKey = vim.keymap.set

	local function setupDiffMode()
		print('setting up diff mode')
		setKey('n', '<leader>dn', ']c')
		setKey('n', '<leader>dp', '[c')
	end

	local function tearDiffMode()
		print('tearing down diff mode')
	end

	local function toggleDiffMode()
		if (vim.opt.diff:get() == false) then
			return tearDiffMode()
		else
			return setupDiffMode()
		end
	end

	vim.api.nvim_create_augroup('Diff', {})

	-- vim.api.nvim_create_autocmd('OptionSet', {
	-- 	pattern = 'diff',
	-- 	group = 'Diff',
	-- 	callback = toggleDiffMode
	-- })
end

return {
	setup = setup
}


	-- if &diff
	--    setup for diff mode
	-- else
	--    setup for non-diff mode
	-- endif
