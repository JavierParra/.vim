return {
	"chrisbra/csv.vim",
	{ "Shougo/denite.nvim", enabled = false },
	"editorconfig/editorconfig-vim",
	"vito-c/jq.vim",
	"Shougo/neomru.vim",
	"norcalli/nvim-colorizer.lua",
	{ "mfussenegger/nvim-dap", enabled = false },
	"rcarriga/nvim-dap-ui",
	"nvim-tree/nvim-web-devicons",
	"puppetlabs/puppet-syntax-vim",
	"kkharji/sqlite.lua",
	"wellle/targets.vim",
	"tomtom/tcomment_vim",
	-- "SirVer/ultisnips",
	"ntpeters/vim-better-whitespace",
	"delphinus/vim-firestore",
	"tpope/vim-fugitive",
	{ "euclio/vim-markdown-composer", enabled = false },
	{ "patstockwell/vim-monokai-tasty", enabled = false },
	"pantharshit00/vim-prisma",
	{ "JavierParra/vim-prosession", dependencies = "tpope/vim-obsession" },
	"tpope/vim-repeat",
	"sirosen/vim-rockstar",
	-- "tpope/vim-rsi",
	"tpope/vim-sleuth",
	"tpope/vim-surround",
	"dhruvasagar/vim-table-mode",
	{
		"folke/which-key.nvim",
		enabled = false,
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	"nvim-lua/plenary.nvim",
	{
		"JavierParra/nvim-breadcrumbs",
		keys = {
			{
				"<Leader>bc",
				function()
					require('nvim-breadcrumbs').toggle()
				end
			}
		},
		dev = true,
	},
}