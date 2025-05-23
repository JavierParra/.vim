-- Helper functions for concise keymap definitions
local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

local function is_array(var)
	-- First check if it's a table
	if type(var) ~= "table" then
		return false
	end

	-- Check if it has sequential numeric keys
	local count = 0
	for _ in pairs(var) do
		count = count + 1
	end

	-- If #var (length operator) equals the number of keys,
	-- then it's an array with sequential keys
	return count == #var
end

-- Command helpers
local cmd = function(command)
	return function()
		if is_array(command) then
			for _, _cmd in pairs(command) do
				vim.cmd(_cmd)
			end
		else
			vim.cmd(command)
		end
	end
end
local fn = vim.fn
local opt = vim.opt
local opt_local = vim.opt_local

-- More specific helpers
local function toggle(option)
	return function()
		opt[option] = not opt[option]:get()
	end
end

local function set_fold(level)
	return function()
		opt_local.foldlevel = level
	end
end

-- Define all keymaps in a structured table
local remaps = {
	-- Normal mode mappings
	n = {
		-- Split panel bindings
		{ "<Leader><C-l>", cmd("belowright vsplit") },
		{ "<Leader><C-h>", cmd("aboveleft vsplit") },
		{ "<Leader><C-j>", cmd("belowright split") },
		{ "<Leader><C-k>", cmd("aboveleft split") },

		-- Create 'hard splits' with Alt + movement
		{ "<Leader><M-l>", cmd("topright vsplit") },
		{ "<Leader>™", cmd("topleft vsplit") },
		{ "<Leader>¶", cmd("botright split") },
		{ "<Leader>§", cmd("topleft split") },

		-- Close split with leader and shift movement key
		{ "<Leader><S-l>", cmd({ "wincmd l", "q" }) },
		{ "<Leader><S-h>", cmd({ "wincmd h", "q" }) },
		{ "<Leader><S-j>", cmd({ "wincmd j", "q" }) },
		{ "<Leader><S-k>", cmd({ "wincmd k", "q" }) },

		-- Toggle spellcheck
		{ "<Leader>s", toggle("spell") },

		-- Move between split panels with leader + movement
		{ "<Leader>h", "<C-w>h" },
		{ "<Leader>j", "<C-w>j" },
		{ "<Leader>k", "<C-w>k" },
		{ "<Leader>l", "<C-w>l" },

		-- Move between buffers with arrows
		{ "<Left>", cmd("bprevious") },
		{ "<Right>", cmd("bnext") },

		-- Move between tabs with control and arrows
		{ "<C-Left>", cmd("tabprevious") },
		{ "<C-Right>", cmd("tabnext") },

		-- NERDTree mappings
		{ "<Leader>fb", cmd("NERDTreeToggle") },
		{ "<Leader>ft", cmd("NERDTreeToggle") },
		{ "<Leader>fo", cmd("NERDTreeFocus") },
		{ "<Leader>fc", cmd("NERDTreeClose") },
		{ "<Leader>ff", cmd("NERDTreeFind") },

		-- Edit new file in the current directory
		{
			"<Leader>fN",
			function()
				cmd("edit " .. fn.expand("%:h") .. "/")()
			end,
		},

		-- Copy the current file's name/path
		{
			"<Leader>fn",
			function()
				fn.system("echo -n " .. fn.expand("%:t:r") .. " | pbcopy")
			end,
		},
		{
			"<Leader>fp",
			function()
				fn.system("echo " .. fn.expand("%") .. " | pbcopy")
			end,
		},

		-- Toggle wordwrap on word boundary
		{
			"<Leader>tw",
			function()
				toggle("wrap")
				toggle("linebreak")
			end,
		},

		-- Use j and k to move by visual lines only if there's no count modifier
		{ "j", "v:count ? 'j' : 'gj'", { expr = true } },
		{ "k", "v:count ? 'k' : 'gk'", { expr = true } },

		-- Clear search
		{ "<Leader><Esc>", cmd("nohlsearch") },

		-- Tab operations
		{
			"<Leader>te",
			function()
				cmd("tabedit " .. fn.expand("%"))()
			end,
		},
		{ "<Leader>tc", cmd("tabclose") },

		-- Saving operations
		{ "<Leader>w", cmd("w") },
		{ "<Leader>ww", cmd("w") },
		{ "<Leader>wq", cmd({ "w", "Bdelete" }) },

		-- Buffer operations
		{ "<Leader>q", cmd("Bdelete") },
		{ "<Leader>Q", cmd("bdelete") },
		{ "<Leader>bw", cmd("%bwipe") },

		-- * stays in the same place
		{ "*", "*``" },

		-- Scroll by 2 lines using shift + movement
		{ "J", "2<C-e>" },
		{ "K", "2<C-y>" },

		-- Scroll horizontally
		{ "L", "2z<Right>" },
		{ "H", "2z<Left>" },

		-- VimWiki
		{ "<Leader>vww", "<Plug>VimwikiIndex" },
		{ "<Leader>vws", "<Plug>VimwikiUISelect" },

		-- Common foldlevels
		{ "<Leader>zl0", set_fold(0) },
		{ "<Leader>zl1", set_fold(1) },
		{ "<Leader>zl2", set_fold(2) },
		{ "<Leader>zl3", set_fold(3) },
		{ "<Leader>zl4", set_fold(4) },
		{ "<Leader>zl", ":setlocal foldlevel=" }, -- Expects input

		-- Fugitive
		{ "<Leader>gs", cmd("Git") },
		{ "<Leader>gb", cmd("Git blame") },
		{ "<Leader>gp", cmd("Git pull") },
		{ "<Leader>gd", cmd("Git diff") },
		{ "<Leader>gc", ":Git checkout" }, -- Expects input

		-- Join the current line with the previous one
		{ "<BS>", "kJ" },

		-- Disable ZZ
		{ "ZZ", "<Nop>" },

		-- ALE navigation
		{ "<Leader>en", function () vim.diagnostic.jump({ count = 1, wrap = false }) end },
		{ "<Leader>ep", function () vim.diagnostic.jump({ count = -1, wrap = false }) end },
		{ "<Leader>ed", cmd("ALEDetail") },

		-- Make marks more usable
		{ "M", "m" },
		{ "m", "'" },

		-- Telescope and ALE fix
		{ "<C-]>", cmd("Telescope coc definitions") },
		{ "<Leader>pw", cmd("ALEFix") },

		-- Open terminal
		{ "<Leader><", cmd({ "botright split", "resize 20", "terminal zsh" }) },
	},

	-- Insert mode mappings
	i = {
		{ "jk", "<Esc>" },
	},

	-- Visual mode mappings
	x = {
		-- Scroll by 2 lines using shift + movement
		{ "J", "2<C-e>" },
		{ "K", "2<C-y>" },

		-- Scroll horizontally
		{ "L", "2z<Right>" },
		{ "H", "2z<Left>" },

		-- Format selection as json
		{ "<Leader>jf", cmd("'<,'>!jq '.'") },

		-- Use j and k to move by visual lines only if there's no count modifier
		{ "j", "v:count ? 'j' : 'gj'", { expr = true } },
		{ "k", "v:count ? 'k' : 'gk'", { expr = true } },

		-- View lines git history
		{ "<Leader>gb", cmd("'<,'>Flogsplit") },
	},

	-- Visual mode (only) mappings
	v = {
		-- Search for selected text
		{ "*", "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>" },

		-- Paste without yanking the deleted text (commented out as buggy)
		-- { "p", "\"_dP" },
	},
	--
	-- Terminal mode
	t = {
		{ "<Esc>", "<C-\\><C-n>" }
	}
}

-- Apply all the mappings
for mode, mappings in pairs(remaps) do
	for _, mapping in ipairs(mappings) do
		local lhs, rhs, opts = mapping[1], mapping[2], mapping[3]
		map(mode, lhs, rhs, opts)
	end
end
