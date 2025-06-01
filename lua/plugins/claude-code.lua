local M = {
	"greggh/claude-code.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required for git operations
	},
	build = "npm install -g @anthropic-ai/claude-code",
	config = function()
		require("claude-code").setup()
	end
}

return M