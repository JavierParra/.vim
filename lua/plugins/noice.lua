local M = {
	"folke/noice.nvim",
	enabled = true,
	opts = {
		-- Suggested options
		lsp = {
			-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
			},
		},
		-- you can enable a preset for easier configuration
		presets = {
			bottom_search = false,
			command_palette = true, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = false, -- add a border to hover docs and signature help
		},
		views = {
			cmdline_popup = {
				position = {
					row = "50%",
					col = "50%",
				},
			},
			split = {
				enter = true,
			},
		},
		routes = {
			{
				filter = {
					event = "msg_show",
					kind = "",
					any = {
						{ find = "%d+ lines? yanked" },
						{ find = "%d+ more lines?" },
						{ find = "%d+ fewer lines?" },
						{ find = "%d+ lines? [<>]ed" },
					},
				},
				opts = { skip = true },
			},
			{
				filter = {
					event = "notify",
					find = "Config Change",
				},
				view = "mini",
			},
		},
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		{
			"rcarriga/nvim-notify",
			opts = {
				background_colour = "#000000",
				stages = "slide",
				timeout = 1500,
				top_down = false,
				render = "compact"
			}
		}
	}
}

return M