local function init()
	-- package.loaded['custom.markdown'] = nil -- DEV ONLY
	vim.keymap.set('n', '<C-Space>', function()
		require('custom.markdown').toggle_checkbox()
	end, { buffer = true })
end

init()