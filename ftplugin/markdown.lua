local function init()
	-- package.loaded['custom.markdown'] = nil -- DEV ONLY
	vim.keymap.set({ "n", "x" }, "<C-Space>", function()
		require("custom.markdown").toggle_checkbox()
	end, { buffer = true })

	vim.keymap.set({ "n", "x" }, "<CS-Space>", function()
		require("custom.markdown").toggle_checkbox(0.5)
	end, { buffer = true })

	vim.opt_local.foldmethod = "manual"
end

init()
