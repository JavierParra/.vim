return {
	{
		'kristijanhusak/vim-dadbod-ui',
		event = "VeryLazy",
		dependencies = {
			{ 'tpope/vim-dadbod', lazy = true },
			{ 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
		},
		cmd = {
			'DBUI',
			'DBUIToggle',
			'DBUIAddConnection',
			'DBUIFindBuffer',
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_auto_execute_table_helpers = 1
			vim.g.db_ui_use_nvim_notify = 0
			vim.g.db_ui_disable_info_notifications = 1
			vim.g.db_ui_force_echo_notifications = 1
		end,
	}
}