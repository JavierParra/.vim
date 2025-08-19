local M = {}

M.build_crumbs = function()
	local node = vim.treesitter.get_node()
	local crumbs = {}
	local i = 0
	while node do
		local type = node:type()
		local crumb = type

		if type == 'method_definition' then
			crumb = crumb .. ' ('.. vim.treesitter.get_node_text(node, vim.api.nvim_get_current_buf()) ..')'
		end
		table.insert(crumbs, crumb)
		node = node:parent()
		i = i + 1
		if i == 500 then
			vim.notify('Infinite loop')
			return
		end
	end

	print(vim.inspect(crumbs))
end

return M