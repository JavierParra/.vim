-- Deletes the current buffer without closing the window
vim.api.nvim_create_user_command('Bdelete', 'bp | bd #', {})
