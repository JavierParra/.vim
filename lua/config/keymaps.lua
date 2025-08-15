local h = require("helpers")

local cmd = h.cmd

-- Helper functions for concise keymap definitions
local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
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
		{ "<Leader><C-l>", "Split right", cmd("belowright vsplit") },
		{ "<Leader><C-h>", "Split left", cmd("aboveleft vsplit") },
		{ "<Leader><C-j>", "Split down", cmd("belowright split") },
		{ "<Leader><C-k>", "Split up", cmd("aboveleft split") },

		-- Create 'hard splits' with Alt + movement
		{ "<Leader><M-l>", "", cmd("topright vsplit") },
		{ "<Leader>™", "", cmd("topleft vsplit") },
		{ "<Leader>¶", "", cmd("botright split") },
		{ "<Leader>§", "", cmd("topleft split") },

		-- Close split with leader and shift movement key
		{ "<Leader><S-l>", "Close panel to the right", cmd({ "wincmd l", "q" }) },
		{ "<Leader><S-h>", "Close panel to the left", cmd({ "wincmd h", "q" }) },
		{ "<Leader><S-j>", "Close panel below", cmd({ "wincmd j", "q" }) },
		{ "<Leader><S-k>", "Close panel above", cmd({ "wincmd k", "q" }) },

		-- Toggle spellcheck
		{ "<Leader>s", "Toggle [S]pellcheck", toggle("spell") },

		-- Move between split panels with leader + movement
		{ "<Leader>l", "Move cursor to panel to the right", "<C-w>l" },
		{ "<Leader>h", "Move cursor to panel to the left", "<C-w>h" },
		{ "<Leader>j", "Move cursor to panel below", "<C-w>j" },
		{ "<Leader>k", "Move cursor to panel above", "<C-w>k" },

		-- Move between buffers with arrows
		{ "<Left>", "Previous buffer", cmd("bprevious") },
		{ "<Right>", "Next buffer", cmd("bnext") },

		-- Move between tabs with control and arrows
		{ "<C-Left>", "Previous tab", cmd("tabprevious") },
		{ "<C-Right>", "Next tab", cmd("tabnext") },

		-- NERDTree mappings
		{ "<Leader>ft", "[T]oggle [F]ile explorer", cmd("NERDTreeToggle") },
		{ "<Leader>fo", "[O]pen [F]ile explorer", cmd("NERDTreeFocus") },
		{ "<Leader>fc", "[C]lose [F]ile explorer", cmd("NERDTreeClose") },
		{ "<Leader>ff", "[F]ind [F]ile in explorer", cmd("NERDTreeFind") },

		-- Edit new file in the current directory
		{
			"<Leader>fN",
			"Edit ([N]ew) [F]ile in current directory",
			":edit " .. fn.expand("%:h") .. "/", -- expects input
		},

		-- Copy the current file's name/path
		{
			"<Leader>fn",
			"Copy current [F]ile's [N]ame",
			function()
				fn.system("echo -n " .. fn.expand("%:t:r") .. " | pbcopy")
			end,
		},
		{
			"<Leader>fp",
			"Copy current [F]ile's [P]ath",
			function()
				fn.system("echo " .. fn.expand("%") .. " | pbcopy")
			end,
		},

		-- Toggle wordwrap on word boundary
		{
			"<Leader>tw",
			"[T]oggle [W]ordwrap",
			function()
				toggle("wrap")()
				toggle("linebreak")()
			end,
		},

		-- Use j and k to move by visual lines only if there's no count modifier
		{ "j", "", "v:count ? 'j' : 'gj'", { expr = true } },
		{ "k", "", "v:count ? 'k' : 'gk'", { expr = true } },

		-- Clear search
		{ "<Leader><Esc>", "Clear search", cmd("nohlsearch") },

		-- Tab operations
		{
			"<Leader>te",
			"[E]dit current file in new [T]ab",
			function()
				cmd("tabedit " .. fn.expand("%"))()
			end,
		},
		{ "<Leader>tc", "[C]lose current [T]ab", cmd("tabclose") },

		-- Saving operations
		{ "<Leader>w", "[W]rite file", cmd("w") },
		{ "<Leader>ww", "[W]rite file", cmd("w") },
		{ "<Leader>wq", "Write file and close buffer", cmd({ "w", "Bdelete" }) },

		-- Buffer operations
		{ "<Leader>q", "Close buffer", cmd("Bdelete") },
		{ "<Leader>Q", "Close buffer even with unsaved changes", cmd("bdelete") },
		{ "<Leader>bw", "Close all ([W]ipe) [B]uffers", cmd("%bwipe") },

		-- * stays in the same place
		{ "*", "", "*``" },

		-- Scroll by 2 lines using shift + movement
		{ "J", "Scroll down", "2<C-e>" },
		{ "K", "Scroll up", "2<C-y>" },

		-- Scroll horizontally
		{ "L", "Scroll right", "2z<Right>" },
		{ "H", "Scroll left", "2z<Left>" },

		-- Common foldlevels
		{ "<Leader>zl0", "Close all folds", set_fold(0) },
		{ "<Leader>zl1", "Fold level 1", set_fold(1) },
		{ "<Leader>zl2", "Fold level 2", set_fold(2) },
		{ "<Leader>zl3", "Fold level 3", set_fold(3) },
		{ "<Leader>zl4", "Fold level 4", set_fold(4) },
		{ "<Leader>zl", "Specify fold level", ":setlocal foldlevel=" }, -- Expects input

		-- Fugitive
		{ "<Leader>gs", "[G]it [S]tatus", cmd("Git") },
		{ "<Leader>gb", "[G]it [B]lame", cmd("Git blame") },
		{ "<Leader>gp", "[G]it [P]ull", cmd("Git pull") },
		{ "<Leader>gd", "[G]it [D]iff", cmd("Git diff") },
		{ "<Leader>gc", "[G]it [C]heckout", ":Git checkout" }, -- Expects input

		-- Join the current line with the previous one
		{ "<BS>", "Join lines", "kJ" },

		-- Disable ZZ
		{ "ZZ", "", "<Nop>" },

		-- ALE navigation
		{
			"<Leader>en",
			"Go to [N]ext diagnostic [E]ror",
			function()
				vim.diagnostic.jump({ count = 1, wrap = false })
			end,
		},
		{
			"<Leader>ep",
			"Go to [P]revious diagnostic [E]ror",
			function()
				vim.diagnostic.jump({ count = -1, wrap = false })
			end,
		},
		{ "<Leader>ed", "Show [E]rror [D]etail", cmd("ALEDetail") },

		-- Make marks more usable
		{ "M", "Add mark", "m" },
		{ "m", "Goto mark", "'" },

		-- Telescope and ALE fix
		{ "<C-]>", "Go to definition", cmd("Telescope coc definitions") },
		{ "<Leader>pw", "Fix linting ([P]rettier [W]rite)", cmd("ALEFix") },

		-- Open terminal
		{ "<Leader><", "Open terminal", cmd({ "botright split", "resize 20", "terminal zsh" }) },
	},

	-- Insert mode mappings
	i = {
		{ "jk", "Leave insert mode", "<Esc>" },
	},

	-- Visual mode mappings
	x = {
		-- Scroll by 2 lines using shift + movement
		{ "J", "Scroll down", "2<C-e>" },
		{ "K", "Scroll up", "2<C-y>" },

		-- Scroll horizontally
		{ "L", "Scroll right", "2z<Right>" },
		{ "H", "Scroll left", "2z<Left>" },

		-- Format selection as json
		{ "<Leader>fj", "[F]ormat selection as [J]SON", cmd("'<,'>!jq '.'") },

		-- Use j and k to move by visual lines only if there's no count modifier
		{ "j", "", "v:count ? 'j' : 'gj'", { expr = true } },
		{ "k", "", "v:count ? 'k' : 'gk'", { expr = true } },

		-- View lines git history
		-- { "<Leader>gb", "Blame selected lines", cmd("'<,'>Flogsplit") },
	},

	-- Visual mode (only) mappings
	v = {
		-- Search for selected text
		{ "*", "Search for selection", "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>" },

		-- Paste without yanking the deleted text (commented out as buggy)
		-- { "p", "", "\"_dP" },
	},
	--
	-- Terminal mode
	t = {
		{ "<Esc>", "Normal mode", "<C-\\><C-n>" },
	},
}

-- Apply all the mappings
for mode, mappings in pairs(remaps) do
	for _, mapping in ipairs(mappings) do
		local lhs, desc, rhs = mapping[1], mapping[2], mapping[3]
		local opts = { desc = desc }
		-- Handle additional options if they exist in a 4th element
		if mapping[4] then
			opts = vim.tbl_extend("force", opts, mapping[4])
		end
		map(mode, lhs, rhs, opts)
	end
end