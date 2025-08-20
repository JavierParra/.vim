local h = require("helpers")
local path_utils = require("custom.path_utils")

local function on_attach(bufnr)
	local api = require("nvim-tree.api")
	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- see: help nvim-tree-mappings-default
	-- api.config.mappings.default_on_attach(bufnr)
	vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
	vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("Set root"))
	vim.keymap.set("n", "ma", api.fs.create, opts("Add"))
	vim.keymap.set("n", "mc", api.fs.copy.node, opts("Copy"))
	vim.keymap.set("n", "mx", api.fs.cut, opts("Cut"))
	vim.keymap.set("n", "mp", api.fs.paste, opts("Paste"))
	vim.keymap.set("n", "md", api.fs.remove, opts("Delete"))
	vim.keymap.set("n", "mm", api.fs.rename_full, opts("Move"))
	vim.keymap.set("n", "mr", api.fs.rename_basename, opts("Rename"))
	vim.keymap.set("n", "m/", function(filename)
		local node = api.tree.get_node_under_cursor()

		if node.type == "file" and node.parent then
			node = node.parent
		end

		local path = node.absolute_path

		if node.type ~= "directory" or not path then
			vim.notify('Cannot search ' .. node.type .. ' ' .. path)
			return
		end

		local ppath = path_utils.normalize_to_cwd(path)
		require("telescope.builtin").live_grep({
			prompt_title = "Live Grep in " .. ppath,
			cwd = path,
		})
	end, opts "Grep here")
	vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
	vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))
	vim.keymap.set("n", "p", api.node.navigate.parent, opts("Parent Directory"))
	vim.keymap.set("n", "b", api.tree.toggle_no_buffer_filter, opts("Toggle Filter: No Buffer"))
	vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open in horisontal split"))
	vim.keymap.set("n", "o", function()
		api.node.open.no_window_picker(nil, { quit_on_open = true })
	end, opts("Open: No Window Picker"))
	vim.keymap.set("n", "I", function()
		api.tree.toggle_gitignore_filter()
	end, opts("Toggle filters"))
	vim.keymap.set("n", "<CR>", function()
		api.node.open.edit(nil, { quit_on_open = true })
	end, opts("Open"))
	vim.keymap.set("n", "<Tab>", function()
		api.node.open.preview_no_picker(nil, { focus = true })
	end, opts("Open Preview"))

	vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
	vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand Directory"))
	vim.keymap.set("n", "F", api.live_filter.clear, opts("Live Filter: Clear"))
	vim.keymap.set("n", "f", api.live_filter.start, opts("Live Filter: Start"))
	vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
	vim.keymap.set("n", "S", api.tree.search_node, opts("Search"))
	vim.keymap.set("n", "W", api.tree.collapse_all, opts("Collapse All"))
	vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
	vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
end

local M = {
	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			on_attach = on_attach,
			diagnostics = {
				enable = true,
				show_on_dirs = true,
				show_on_open_dirs = false,
			},
			modified = {
				enable = true,
				show_on_dirs = true,
				show_on_open_dirs = false,
			},
			view = {
				preserve_window_proportions = false,
				float = {
					enable = false,
				},
			},
			renderer = {
				add_trailing = true,
				full_name = true,
				icons = {
					glyphs = {
						folder = {
							arrow_closed = "▸",
							arrow_open = "▾",
						},
						git = {
							unstaged = "★",
							untracked = "✗",
						},
					},
				},
			},
		},
		keys = {
			{ "<Leader>ft", h.cmd("NvimTreeToggle"), mode = { "n" }, desc = "[T]oggle [F]ile explorer" },
			{ "<Leader>fo", h.cmd("NvimTreeFocus"), mode = { "n" }, desc = "[O]pen [F]ile explorer" },
			{ "<Leader>fc", h.cmd("NvimTreeClose"), mode = { "n" }, desc = "[C]lose [F]ile explorer" },
			{ "<Leader>ff", h.cmd("NvimTreeFindFile"), mode = { "n" }, desc = "[F]ind [F]ile in explorer" },
		},
		enabled = true,
	},
}

return M