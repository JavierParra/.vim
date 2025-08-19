local M = {}

M.build_crumbs = function(debug)
	local node = vim.treesitter.get_node()
	local last_node = nil
	local all = {}
	local crumbs = {}
	local i = 0
	local stuff = {
		method_definition = true,
		class_declaraton = true,
		function_declaration = true,
	}

	--- @param node TSNode
	local push_crumb = function(node, prefix, suffix)
		local bfr = 0
		local text =  (prefix or '') .. vim.treesitter.get_node_text(node, bfr) .. (suffix or '')
		local row, col = node:start()
		local captures = vim.treesitter.get_captures_at_pos(bfr, row, col)

		table.insert(crumbs, 1, {
			text,
			pos = { row, col },
			captures = captures,
		})
	end

	while node do
		local type = node:type()
		local crumb = type

		if debug then
			table.insert(all, crumb)
		end

		if stuff[type] then
			-- vim.treesitter.get_node_text(node, 0)
			local name_node = node:field('name')[1]

			if name_node then
				local prev_sibling = name_node:prev_sibling()
				if prev_sibling and (prev_sibling:type() == 'get' or prev_sibling:type() == 'set')  then
					-- table.insert(crumbs, 1, '['.. prev_sibling:type() ..']')
					push_crumb(prev_sibling, '[', ']')
				end
				-- table.insert(crumbs, 1, vim.treesitter.get_node_text(name_node, 0))
				push_crumb(name_node)
			end
		end

		if type == 'variable_declarator' then
			local value_node = node:field('value')[1]
			local name_node = node:field('name')[1]

			if value_node and value_node:type() == 'arrow_function' then
				if name_node then
					-- table.insert(crumbs, 1, vim.treesitter.get_node_text(name_node, 0))
					push_crumb(name_node)
				end
			end
		end

		if type == 'arguments' then
			if
				last_node
				and last_node:type() == 'arrow_function'
				and node:parent()
				and node:parent():type() == 'call_expression'
			then
				local function_node = node:parent():field('function')[1]
				if function_node then
					-- table.insert(crumbs, 1, vim.treesitter.get_node_text(function_node, 0) ..'()')
					push_crumb(function_node, nil, '()')
				end
			end
		end

		if type == 'jsx_self_closing_element' then
			local name_node = node:field('name')[1]

			if name_node then
				-- table.insert(crumbs, 1, '<'..vim.treesitter.get_node_text(name_node, 0)..' />')
				push_crumb(name_node, '<', ' />')
			end
		end

		if type == 'jsx_element' or type == 'jsx_self_closing_element' then
			local open_node = node:field('open_tag')[1]
			local name_node = open_node and open_node:field('name')[1]

			if name_node then
				-- table.insert(crumbs, 1, '<'..vim.treesitter.get_node_text(name_node, 0)..'>')
				push_crumb(name_node, '<', '>')
			end
		end

		last_node = node
		node = node:parent()
		i = i + 1
		if i == 500 then
			vim.notify('Infinite loop')
			return
		end
	end

	if debug then
		print(vim.inspect(all))
	end

	return crumbs
end

M.open_crumbs = function (win)
	local crumbs = M.build_crumbs()
-- end
-- local function s()
	local buf = vim.api.nvim_create_buf(false, true)
	local win_height = vim.api.nvim_win_get_width(win or 0)
	local win_width = vim.api.nvim_win_get_width(win or 0)
	local float_height = 1
	local float_width = win_width - 1

	local opts = {
		relative = 'win',
		win = win or 0,
		width = float_width,
		height = float_height,
		-- row = win_height - float_height - 2,
		row = 1,
		col = 1,
		style = 'minimal',
	}
	local float = vim.api.nvim_open_win(buf, false, opts)

	local col = 0
	local ns = vim.api.nvim_create_namespace('breadcrumbs')

	-- vim.api.nvim_buf_set_option(buf, 'filetype', lang)
	for _, crumb in pairs(crumbs) do
		local txt = crumb[1]
		local len = #txt

		vim.api.nvim_buf_set_text(
			buf,
			0,
			col,
			0,
			col,
			{ txt .. ' ' }
		)

		local groups = {}

		for _, cap in pairs(crumb.captures) do
			local group = '@'.. cap.capture .. (cap.lang and '.' .. cap.lang or '')
			table.insert(groups, group)
		end

		-- vim.api.nvim_buf_set_extmark(buf, ns, 0, col, {
		vim.api.nvim_buf_set_extmark(buf, ns, 0, col, {
			end_row = 0,
			end_col = col + len,
			hl_group = groups,
		})
		col = col + len + 1

	end

end

return M