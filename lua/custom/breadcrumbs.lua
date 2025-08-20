local M = {}

--- @param captures { capture: string, lang: string }[]
--- @return string[]
local function captures_to_hl_groups(captures)
	local groups = {}

	for _, cap in pairs(captures) do
		local group = '@'.. cap.capture .. (cap.lang and '.' .. cap.lang or '')
		table.insert(groups, group)
	end

	return groups
end

--- @returns { [1]: string, captures: table, hl_groups: string[]}[]
M.build_crumbs = function(debug)
	local node = vim.treesitter.get_node()
	local last_node = nil
	local all = {}
	local crumbs = {}
	local i = 0
	local stuff = {
		method_definition = true,
		class_declaration = true,
		function_declaration = true,
	}

	--- @param node TSNode
	--- @param bfr integer
	--- @param res { [1]: string, captures: table, hl_groups: string[]}[] | nil
	local function descend(node, bfr, res)
		local result = res or {}

		if node:child_count() == 0 then
			local row, col = node:start()
			local captures = vim.treesitter.get_captures_at_pos(bfr, row, col)

			table.insert(result, {
				vim.treesitter.get_node_text(node, bfr),
				captures = captures,
				hl_groups = captures_to_hl_groups(captures),
			})
			return result
		end

		for child, field in node:iter_children() do
			descend(child, bfr, result)
		end

		return result
	end

	--- @param node TSNode
	--- @returns { [1]: string, captures: table, hl_groups: string[]}[]
	local push_crumb = function(node, prefix, suffix)
		local bfr = 0
		local res = descend(node, bfr)

		if prefix then
			table.insert(res, 1, {
				prefix,
				captures = {},
				hl_groups = {},
			})
		end

		if suffix then
			table.insert(res, {
				suffix,
				captures = {},
				hl_groups = {},
			})
		end

		table.insert(crumbs, 1, res)
	end

	while node do
		local type = node:type()
		local crumb = type

		if debug then
			table.insert(all, crumb)
		end

		if stuff[type] then
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

--- @param crumbs { [1]: string, captures: table, hl_groups: string[]}[] | nil
--- @param win integer
local function print_crumbs(crumbs, buf, win)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

	if not crumbs then
		return
	end

	local col = 0
	local ns = vim.api.nvim_create_namespace('breadcrumbs')
	local crumbs_length = #crumbs


	for i, crumb in pairs(crumbs) do
		for _, part in pairs(crumb) do
			local txt = part[1]
			local len = vim.fn.strlen(txt)

			vim.api.nvim_buf_set_text(
				buf,
				0,
				col,
				0,
				col,
				{ txt }
			)

			-- vim.api.nvim_buf_set_extmark(buf, ns, 0, col, {
			vim.api.nvim_buf_set_extmark(buf, ns, 0, col, {
				end_row = 0,
				end_col = col + len,
				hl_group = part.hl_groups,
			})
			col = col + len
		end

		local sep = '  '
		if i < crumbs_length then
			vim.api.nvim_buf_set_text(
				buf,
				0,
				col,
				0,
				col,
				{ sep }
			)

			col = col + vim.fn.strlen(sep)
		end
	end
end

M.win = nil
M.augr = nil

M.open_crumbs = function (win)
	if M.augr then
		vim.api.nvim_clear_autocmds({
			group = M.augr
		})
	end
	if M.win then
		vim.api.nvim_win_close(M.win, true)
		M.win = nil
		return
	end
	local crumbs = M.build_crumbs()
	if not crumbs then
		return
	end
	local buf = vim.api.nvim_create_buf(false, true)
	local win_width = vim.api.nvim_win_get_width(win or 0)
	local float_height = 1
	local float_width = win_width - 1

	local opts = {
		relative = 'laststatus',
		width = vim.o.columns,
		height = float_height,
		row = 0,
		anchor = 'SW',
		col = 1,
		style = 'minimal',
	}
	local float = vim.api.nvim_open_win(buf, false, opts)

	M.win = float

	M.augr = vim.api.nvim_create_augroup('breadcrumbs', { clear = true })
	vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
			group = M.augr, callback = function()
			print_crumbs(M.build_crumbs(false), buf, float)
		end,
		-- buffer = 0,
	})

	print_crumbs(crumbs, buf, float)
end

return M