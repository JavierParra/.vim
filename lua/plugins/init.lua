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
			},
			{
				"<Leader>bp",
				function()
					require('nvim-breadcrumbs').parent()
				end
			}
		},
		opts = {
			debug = true,
			processors = {
				prisma = function()
					return function (push_crumb)
						--- @param node TSNode
						return function (node)
							local type = node:type()
							if type == 'model_declaration' then
								local first_child = node:child(0)
								local name_node = node:named_child(0)
								local nodes = {}

								if first_child and first_child:type() == 'model' then
									table.insert(nodes, first_child)
									table.insert(nodes, ' ')
								end
								if name_node and name_node:type() == 'identifier' then
									table.insert(nodes, name_node)
									push_crumb(nodes)
								end
							end

							if type == 'column_declaration' then
								local name_node = node:named_child(0)
								if name_node and name_node:type() == 'identifier' then
									push_crumb({ name_node })
								end
							end
						end
					end
				end
			}
		},
		dev = true,
	},
}