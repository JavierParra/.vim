local M = {}

--- @alias crumbs { [1]: string, captures: table, hl_groups: string[]}[]
--- @alias push_crumb fun(nodes: (TSNode | string)[])
--- @alias processor fun(push_crumb: push_crumb, bfr: number): fun(node: TSNode)
--- @alias crumb { [1]: string, captures: table, hl_groups: string[]}[]

--- @param captures { capture: string, lang: string }[]
--- @return string[]
local function captures_to_hl_groups(captures)
	local groups = {}

	for _, cap in pairs(captures) do
		local group = "@" .. cap.capture .. (cap.lang and "." .. cap.lang or "")
		table.insert(groups, group)
	end

	return groups
end

--- @type processor
local function json_processor(push_crumb)
	--- @type TSNode | nil
	local last_node = nil

	--- @param node TSNode
	return function(node)
		local type = node:type()

		if type == "array" then
			local found = nil
			if last_node then
				for index, value in ipairs(node:named_children()) do
					if value:equal(last_node) then
						push_crumb({ "[" .. (index - 1) .. "]" })
						break
					end
				end
			end
		end

		if type == "pair" then
			local key_node = node:field("key")[1]
			local value_node = node:field("value")[1]
			local suffix = nil

			if key_node then
				push_crumb({ key_node })
			end
		end
		last_node = node
	end
end

--- @type processor
local function lua_processor(push_crumb)
	local context = nil

	--- @param node TSNode
	return function(node)
		local type = node:type()

		if context ~= nil then
			local last = context
			context = nil

			if type == "expression_list" and last == "function_definition" then
				context = type
			end

			if type == "return_statement" and last == "expression_list" then
				local child = node:child(0)
				if child and child:type() == "return" then
					push_crumb({ child })
				end
			end

			if type == "assignment_statement" and last == "expression_list" then
				local child = node:named_child(0)
				if child and child:type() == "variable_list" then
					local name_node = child:field("name")[1]

					if name_node then
						push_crumb({ name_node })
					end
				end
			end
		end

		if type == "function_declaration" then
			local name_node = node:field("name")[1]

			if name_node then
				push_crumb({ name_node })
			end
		end

		if type == "function_definition" then
			context = type
		end
	end
end

--- @type processor
local function typescript_processor(push_crumb, bfr)
	--- @type TSNode | nil
	local last_node = nil
	local stuff = {
		method_definition = true,
		class_declaration = true,
		function_declaration = true,
	}
	local test_functions = {
		it = true,
		describe = true,
	}

	return function(node)
		local type = node:type()
		local crumb = type
		if stuff[type] then
			local name_node = node:field("name")[1]

			if name_node then
				local prev_sibling = name_node:prev_sibling()
				local to_push = {}
				if prev_sibling and (prev_sibling:type() == "get" or prev_sibling:type() == "set") then
					-- table.insert(crumbs, 1, '['.. prev_sibling:type() ..']')
					to_push = { prev_sibling, " " }
				end

				table.insert(to_push, name_node)
				push_crumb(to_push)
			end
		end

		if type == "variable_declarator" then
			local value_node = node:field("value")[1]
			local name_node = node:field("name")[1]

			if value_node and value_node:type() == "arrow_function" then
				if name_node then
					-- table.insert(crumbs, 1, vim.treesitter.get_node_text(name_node, 0))
					push_crumb({ name_node })
				end
			end
		end

		if type == "arguments" then
			if
				last_node
				and last_node:type() == "arrow_function"
				and node:parent()
				and node:parent():type() == "call_expression"
			then
				local function_node = node:parent():field("function")[1]
				if function_node then
					local func_name = vim.treesitter.get_node_text(function_node, bfr)
					local to_push = nil

					-- Special case to print the description of the test case in jest tests
					if test_functions[func_name] then
						local args_node = node:parent():field("arguments")[1]
						local first_arg = args_node and args_node:named_child(0)

						if first_arg and first_arg:type() == "string" then
							to_push = { function_node, "(", first_arg, ")" }
						end
					end

					push_crumb(to_push or { function_node, "()" })
				end
			end
		end

		if type == "jsx_self_closing_element" then
			local name_node = node:field("name")[1]

			if name_node then
				-- table.insert(crumbs, 1, '<'..vim.treesitter.get_node_text(name_node, 0)..' />')
				push_crumb({ "<", name_node, " />" })
			end
		end

		if type == "jsx_element" or type == "jsx_self_closing_element" then
			local open_node = node:field("open_tag")[1]
			local name_node = open_node and open_node:field("name")[1]

			if name_node then
				-- table.insert(crumbs, 1, '<'..vim.treesitter.get_node_text(name_node, 0)..'>')
				push_crumb({ "<", name_node, ">" })
			end
		end

		last_node = node
	end
end

--- @return processor | nil
local function get_processor(lang)
	-- TODO have a map or something
	if
		lang == "typescript"
		or lang == "javascript"
		or lang == "typescriptreact"
		or lang == "javascriptreact"
		or lang == "tsx"
		or lang == "jsx"
	then
		return typescript_processor
	end

	if lang == "json" or lang == "jsonc" or lang == "json5" then
		return json_processor
	end

	if lang == "lua" then
		return lua_processor
	end

	return nil
end

--- @returns crumb
M.build_crumbs = function(debug)
	local node = vim.treesitter.get_node()
	local last_node = nil
	local all = {}
	local crumbs = {}
	local i = 0
	local lang = vim.api.nvim_get_option_value("filetype", { buf = 0 })
	local bfr = 0

	--- @type push_crumb
	local push_crumb = function(nodes)
		--- @param node TSNode
		--- @param bfr integer
		--- @param res crumb | nil
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

		--- @type crumb
		local res = {}

		for _, node in pairs(nodes) do
			if type(node) == "string" then
				table.insert(res, {
					node,
					captures = {},
					hl_groups = {},
				})
			else
				local crbs = descend(node, bfr)
				if crbs then
					for _, crb in pairs(crbs) do
						table.insert(res, crb)
					end
				end
			end
		end

		table.insert(crumbs, 1, res)
	end

	local processor = get_processor(lang)

	if not processor then
		return
	end

	local process_node = processor(push_crumb, bfr)

	while node do
		if debug then
			table.insert(all, node:type())
		end

		process_node(node)

		node = node:parent()
		i = i + 1
		if i == 500 then
			vim.notify("Infinite loop")
			return
		end
	end

	if debug then
		print(vim.inspect(all))
	end

	return crumbs
end

M.win = nil
M.augr = nil

local is_loaded = function()
	return M.win ~= nil or M.augr ~= nil
end

--- @param crumbs { [1]: string, captures: table, hl_groups: string[]}[] | nil
--- @param win integer
local function print_crumbs(crumbs, buf, win)
	if not is_loaded() then
		return
	end
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

	if not crumbs then
		return
	end

	local col = 0
	local ns = vim.api.nvim_create_namespace("breadcrumbs")
	local crumbs_length = #crumbs

	for i, crumb in pairs(crumbs) do
		for _, part in pairs(crumb) do
			local txt = part[1]
			local len = vim.fn.strlen(txt)

			vim.api.nvim_buf_set_text(buf, 0, col, 0, col, { txt })

			vim.api.nvim_buf_set_extmark(buf, ns, 0, col, {
				end_row = 0,
				end_col = col + len,
				hl_group = part.hl_groups,
			})
			col = col + len
		end

		local sep = "  "
		if i < crumbs_length then
			vim.api.nvim_buf_set_text(buf, 0, col, 0, col, { sep })

			col = col + vim.fn.strlen(sep)
		end
	end
end

M.unload = function()
	if M.augr then
		vim.api.nvim_clear_autocmds({
			group = M.augr,
		})
	end
	if M.win and vim.api.nvim_win_is_valid(M.win) then
		vim.api.nvim_win_close(M.win, true)
	end
	M.augr = nil
	M.win = nil
end

M.open_crumbs = function(win)
	if M.augr then
		vim.api.nvim_clear_autocmds({
			group = M.augr,
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
		relative = "laststatus",
		width = vim.o.columns,
		height = float_height,
		row = 0,
		anchor = "SW",
		col = 1,
		style = "minimal",
	}
	local float = vim.api.nvim_open_win(buf, false, opts)

	M.win = float

	M.augr = vim.api.nvim_create_augroup("breadcrumbs", { clear = true })
	vim.api.nvim_create_autocmd({ "CursorMoved" }, {
		group = M.augr,
		callback = function()
			print_crumbs(M.build_crumbs(false), buf, float)
		end,
	})

	vim.api.nvim_create_autocmd({ "BufUnload" }, {
		group = M.augr,
		callback = function()
			print("will unload")
			M.unload()
		end,
		buffer = buf,
	})

	print_crumbs(crumbs, buf, float)
end

return M