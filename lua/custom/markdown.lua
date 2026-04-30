local M = {}

local tokens = {
	whitespace = { [' '] = true, ['\t'] = true },
	list_marker = { ['-'] = true, ['*'] = true, ['+'] = true },
	numeric = {
		['0'] = true,
		['1'] = true,
		['2'] = true,
		['3'] = true,
		['4'] = true,
		['5'] = true,
		['6'] = true,
		['7'] = true,
		['8'] = true,
		['9'] = true,
	},
	open_bracket = { ['['] = true },
	close_bracket = { [']'] = true },
}
--- @param char string
--- @return boolean
local is_whitespace = function(char)
	return tokens.whitespace[char] or false
end

--- @param char string
--- @return boolean
local is_unordered_list_character = function(char)
	return tokens.list_marker[char] or false
end

--- @param char string
--- @return boolean
local is_numeric_character = function(char)
	return tokens.numeric[char] or false
end

--- @param char string
--- @return boolean
local is_open_bracket = function(char)
	return tokens.open_bracket[char] or false
end

--- @param char string
--- @return boolean
local is_close_bracket = function(char)
	return tokens.close_bracket[char] or false
end

---@param reader LineReader
---@return string
local function consume_whitespace(reader)
	return reader:consume(is_whitespace)
end

---@param reader LineReader
---@return string
local function consume_numeric(reader)
	return reader:consume(is_numeric_character)
end

--- @class LineReader
--- @field line string
--- @field ix integer
--- @field len integer
local LineReader = {
	line = '',
	ix = 1,
	len = 0,
}

--- @class ReaderSnapshot
--- @field ix integer

LineReader.__index = LineReader

--- @param line string
--- @return LineReader
function LineReader:new(line)
	--- @type LineReader
	local o = setmetatable({}, self)
	o.line = line
	o.len = string.len(line)
	o.ix = 0
	return o
end

---@return boolean
function LineReader:done()
	return self.ix >= self.len
end

--- @return string
function LineReader:next()
	if self:done() then
		return ''
	end

	self.ix = self.ix + 1
	return string.sub(self.line, self.ix, self.ix)
end

--- @return string
function LineReader:peek()
	return string.sub(self.line, self.ix + 1, self.ix + 1)
end

--- @alias CharacterMatcher fun(char: string): boolean

---Consumes _something_ from the reader that's matched by `matcher`.
---@param matcher CharacterMatcher
---@return string
function LineReader:consume(matcher)
	local chunk = ''
	while not self:done() and matcher(self:peek()) do
		chunk = chunk .. self:next()
	end
	return chunk
end

--- Saves a snapshot of the reader's state
--- @return ReaderSnapshot
function LineReader:save()
	--- @type ReaderSnapshot
	return {
		ix = self.ix,
	}
end

--- Restores a snapshot
--- @param snapshot ReaderSnapshot
function LineReader:restore(snapshot)
	self.ix = snapshot.ix
end

--- @class Context
--- @field line_map table<integer, (MarkdownLine | MarkdownListItem)>
--- @field line_count integer
--- @field shiftwidth integer
--- @field cursor {row: integer, col: integer }
local Context = {}

Context.__index = Context

--- @return Context
function Context:new()
	--- @type Context
	local o = setmetatable({}, self)

	o.line_map = {}
	o.line_count = vim.api.nvim_buf_line_count(0)
	o.shiftwidth = vim.opt.shiftwidth:get()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	o.cursor = { row = row, col = col }

	return o
end

--- @class MarkdownLine
--- @field row integer
--- @field indent_level integer
--- @field type 'plain'
--- @field empty boolean
local MarkdownLine = {
	row = 0,
	indent_level = 0,
	type = 'plain',
	empty = false
}

MarkdownLine.__index = MarkdownLine

--- @param row integer
--- @return MarkdownLine
function MarkdownLine:new(row)
	--- @type MarkdownLine
	local o = setmetatable({}, self)

	o.row = row
	return o
end

--- @class MarkdownListItem
--- @field row integer
--- @field indent_level integer
--- @field type 'list_item'
--- @field empty false
--- @field marker string
--- @field is_ordered boolean
--- @field has_checkbox boolean
--- @field checkbox_status nil | number - 0: unchecked, 0.5: partial, 1: checked
--- @field content string
--- @field marker_index number
--- @field checkbox_index number | nil
--- @field content_index number
local MarkdownListItem = {
	row = 0,
	indent_level = 0,
	type = 'list_item',
	empty = false,
	marker = '-',
	is_ordered = false,
	has_checkbox = false,
	checkbox_status = nil,
	content = '',

	marker_index = 0,
	content_index = 0,
	checkbox_index = nil,
}

MarkdownListItem.__index = MarkdownListItem

--- @param row integer
--- @return MarkdownListItem
function MarkdownListItem:new(row)
	--- @type MarkdownListItem
	local o = setmetatable({}, self)
	o.row = row
	return o
end

local mark_to_status = {
	['x'] = 1,
	['-'] = 0.5,
	[' '] = 0,
}

local status_to_mark = {
	[0] = ' ',
	[0.5] = '-',
	[1] = 'x',
}

---@param reader LineReader
---@param list_item MarkdownListItem
local function parse_checkbox(reader, list_item)
	local snapshot = reader:save()
	local checkbox_index = reader.ix

	if not is_open_bracket(reader:next()) then
		reader:restore(snapshot)
		return
	end

	local status = mark_to_status[reader:next()]

	if status == nil or not is_close_bracket(reader:next()) then
		reader:restore(snapshot)
		return
	end

	list_item.checkbox_index = checkbox_index
	list_item.checkbox_status = status
	list_item.has_checkbox = true

	consume_whitespace(reader)
end

--- Assumes that tabs and spaces are not mixed
--- @param whitespace string
--- @param ctx Context
--- @return integer
local function get_indent_level_from_whitespace(whitespace, ctx)
	local first = string.sub(whitespace, 1, 1)
	local whitespace_count = string.len(whitespace)
	local level = 0

	if first == '\t' then
		level = whitespace_count
	else
		level = math.floor(whitespace_count / ctx.shiftwidth)
	end

	return level
end

--- @param row integer
--- @param line string
--- @param ctx Context
--- @return MarkdownListItem | false
local function parse_list_item(row, line, ctx)
	local reader = LineReader:new(line)
	local leading_whitespace = reader:consume(is_whitespace)
	local list_item = MarkdownListItem:new(row)
	list_item.indent_level = get_indent_level_from_whitespace(leading_whitespace, ctx)


	if is_unordered_list_character(reader:peek()) then
		list_item.is_ordered = false
		list_item.marker_index = reader.ix
		list_item.marker = reader:next()
	elseif is_numeric_character(reader:peek()) then
		list_item.marker_index = reader.ix
		list_item.is_ordered = true
		list_item.marker = consume_numeric(reader)

		if reader:peek() ~= '.' then
			return false
		end

		list_item.marker = list_item.marker .. reader:next()
	else
		return false
	end

	if not is_whitespace(reader:next()) then
		return false
	end

	consume_whitespace(reader)

	parse_checkbox(reader, list_item)

	list_item.content_index = reader.ix
	list_item.content = reader:consume(function() return true end)
	return list_item
end

--- @param row integer
--- @param line string
--- @param ctx Context
--- @return MarkdownLine
local function parse_line(row, line, ctx)
	local reader = LineReader:new(line)
	local md_line = MarkdownLine:new(row)
	md_line.indent_level = get_indent_level_from_whitespace(reader:consume(is_whitespace), ctx)

	if reader:done() then
		md_line.empty = true
	end

	return md_line
end

--- @param row integer | nil
--- @param ctx Context
--- @return MarkdownListItem | MarkdownLine | nil
local function get_markdown_line(row, ctx)
	if not row then
		row = ctx.cursor.row
	end

	if ctx.line_map[row] then
		return ctx.line_map[row]
	end
	local line = unpack(vim.api.nvim_buf_get_lines(0, row - 1, row, false))

	if not line then
		return nil
	end

	local item = parse_list_item(row, line, ctx)
	if item then
		ctx.line_map[row] = item
		return item
	end

	local md_line = parse_line(row, line, ctx)
	ctx.line_map[row] = md_line
	return md_line
end

--- @param item MarkdownListItem
--- @param ctx Context
--- @return MarkdownListItem | nil
local function find_parent_list_item(item, ctx)
	local prev_row = item.row - 1

	if item.indent_level <= 0 then
		return nil
	end

	while prev_row >= 1 do
		local prev_line = get_markdown_line(prev_row, ctx)
		prev_row = prev_row - 1

		if not prev_line then
			return nil
		end

		if prev_line.type == 'list_item' and prev_line.has_checkbox and prev_line.indent_level == item.indent_level - 1 then
			return prev_line
		end

		-- If we encounter anything with an indentation level less than the
		-- expected parent, don't keep traversing because we might hit other
		-- hierarchies.
		if not prev_line.empty and prev_line.indent_level < item.indent_level - 1 then
			return nil
		end
	end

	return nil
end

--- @param parent_item MarkdownListItem
--- @param ctx Context
--- @return MarkdownListItem[]
local function find_sub_issues(parent_item, ctx)
	local issues = {}
	local next_row = parent_item.row + 1

	while next_row <= ctx.line_count do
		local next_line = get_markdown_line(next_row, ctx)
		next_row = next_row + 1

		if not next_line then
			return issues
		end

		if
				next_line.type == 'list_item'
				and next_line.indent_level == parent_item.indent_level + 1
				and next_line.has_checkbox
		then
			table.insert(issues, next_line)
		end

		-- Empty lines should not break the loop
		if next_line.empty then
			goto continue
		end

		if next_line.indent_level <= parent_item.indent_level then
			break
		end
		::continue::
	end

	return issues
end

--- @param parent MarkdownListItem
--- @param ctx Context
--- @return integer
local function derive_parent_status(parent, ctx)
	local status_collection = {
		[0]   = 0,
		[0.5] = 0,
		[1]   = 0,
	}

	local sub_issues = find_sub_issues(parent, ctx)
	local issue_count = #sub_issues

	for _, sub_issue in pairs(sub_issues) do
		status_collection[sub_issue.checkbox_status] = status_collection[sub_issue.checkbox_status] + 1
	end

	if status_collection[1] == issue_count then
		return 1
	end

	if status_collection[0] == issue_count then
		return 0
	end

	-- If not all child issues are completed or pending, mark as in progress
	return 0.5
end

--- Renders the new issue status to the buffer and propagates to parents.
---
--- @param item MarkdownListItem
--- @param new_status number
--- @param ctx Context
--- @return nil
local function handle_checkbox_status(item, new_status, ctx)
	assert(item.has_checkbox, 'Cannot update item without checkbox')

	local checkmark_index = item.checkbox_index + 1
	local row = item.row

	-- Bypass buffer write but still check parent
	if item.checkbox_status ~= new_status then
		item.checkbox_status = new_status

		vim.api.nvim_buf_set_text(
			0,
			row - 1,
			checkmark_index,
			row - 1,
			checkmark_index + 1,
			{ status_to_mark[new_status] }
		)
	end

	-- Try to update parent status according to sub-item status
	local parent = find_parent_list_item(item, ctx)

	if not parent then
		return nil
	end

	handle_checkbox_status(parent, derive_parent_status(parent, ctx), ctx)
end

--- @param item MarkdownListItem
--- @param new_status number | nil - If not provided, will toggle the current status.
--- @param ctx Context
local function set_item_status(item, new_status, ctx)
	local status_pairs = {
		[0]   = 1,
		[0.5] = 1,
		[1]   = 0,
	}

	if not item.has_checkbox then
		if new_status == nil then
			new_status = 0
		end

		local ix_start = item.marker_index + string.len(item.marker) + 1
		local ix_end = ix_start
		local tpl = '[' .. status_to_mark[new_status] .. '] '
		local len = string.len(tpl)

		-- table.unpack complains at runtime
		local target_text = unpack(vim.api.nvim_buf_get_text(
			0,
			item.row - 1,
			ix_start,
			item.row - 1,
			ix_start + len,
			{}
		))

		local reader = LineReader:new(target_text)
		local whitespace_count = string.len(consume_whitespace(reader))
		ix_end = ix_start + whitespace_count

		item.checkbox_index = ix_start
		item.has_checkbox = true
		item.content_index = item.content_index + ix_end - ix_start
		item.checkbox_status = new_status

		vim.api.nvim_buf_set_text(
			0,
			item.row - 1,
			ix_start,
			item.row - 1,
			ix_end,
			{ tpl }
		)
	elseif new_status == nil then
		new_status = status_pairs[item.checkbox_status]
	end

	handle_checkbox_status(item, new_status, ctx)
end

--- @param status number | nil
M.toggle_checkbox = function(status)
	local ctx = Context:new()
	local _, row_start = unpack(vim.fn.getpos('.'))
	local _, row_end = unpack(vim.fn.getpos('v'))

	if row_start > row_end then
		local old_start = row_start
		row_start = row_end
		row_end = old_start
	end

	for i = row_start, row_end, 1 do
		local item = get_markdown_line(i, ctx)

		if not item then
			return
		end

		if item.type == 'list_item' then
			set_item_status(item, status, ctx)
		end
	end
end

return M