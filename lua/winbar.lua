local winbar = {}
local separators = {
	left = nil,
	right = nil,
}

local activeWindow = nil

local content = {
	left = nil,
	right = nil,
}

local function activeWindowHighlight (value, active, inactive)
	return "%{% (win_getid() == ".. activeWindow ..")"
		.. " ? '%#"..active.."#'"
		.. " : '%#"..inactive.."#'"
		.. "%}"
		.. value
			.. "%*"
end

local function getWinBarContent (sectionContents)
	local joined = ""

	if activeWindow == nil then
		return joined
	end

	for _key, value in ipairs(sectionContents) do
		if separators.left then
			joined = joined .. activeWindowHighlight(separators.left, 'WinBarSeparator', 'WinBarSeparatorNC')
		end
		joined = joined
			.. activeWindowHighlight(value, 'WinBarContent', 'WinBarContentNC')

		if separators.right then
			joined = joined .. activeWindowHighlight(separators.right, 'WinBarSeparator', 'WinBarSeparatorNC')
		end
	end

	 return joined
end

local function doSetWinBar()
	local barContent = ""

	if content.left then
		barContent = barContent .. getWinBarContent(content.left)
	end
	if content.right then
		barContent = barContent .. "%=" .. getWinBarContent(content.right)
	end

	vim.opt.winbar = barContent
end

function winbar.set(leftContent, rightContent)
	content.left = leftContent
	content.right = rightContent

	if activeWindow then doSetWinBar() end
end

function winbar.setSeparators(left, right)
	separators.left = left
	separators.right = right
	return winbar
end

vim.api.nvim_create_autocmd("WinEnter", {
	pattern = '*',
	callback = function()
		activeWindow = vim.api.nvim_get_current_win()
		doSetWinBar()
	end,
})

-- Win Enter does not fire when a file is open from nerdtree.
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = '*',
	callback = function()
		activeWindow = vim.api.nvim_get_current_win()
		doSetWinBar()
	end,
})

return winbar
