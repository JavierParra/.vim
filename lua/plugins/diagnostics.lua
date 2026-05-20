local DIAGNOSTICS_SIGNS = {
	ERROR = "💩",
	WARN = "❕",
	INFO = "ℹ",
	HINT = "❔",
}

local function configNative()
	vim.opt.updatetime = 1000
	vim.opt.signcolumn = "yes"

	vim.diagnostic.config({
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = DIAGNOSTICS_SIGNS.ERROR,
				[vim.diagnostic.severity.WARN] = DIAGNOSTICS_SIGNS.WARN,
				[vim.diagnostic.severity.INFO] = DIAGNOSTICS_SIGNS.INFO,
				[vim.diagnostic.severity.HINT] = DIAGNOSTICS_SIGNS.HINT,
			},
		},
	})
end

local function setupAutoCommands()
	local function showHover()
		local diagnosticsWin = vim.diagnostic.open_float({
			scope = "cursor",
			focusable = false,
		})

		if diagnosticsWin ~= nil then
			return
		end
	end

	---@diagnostic disable-next-line undefined-field
	local show_virtual_text_timer = vim.uv.new_timer()
	local o = {
		show_virtual_text = true,
	}

	local function showDiagnosticVirtualText()
		assert(show_virtual_text_timer):start(20000, 0, function()
			vim.schedule(function()
				o.show_virtual_text = true
				vim.diagnostic.config({
					virtual_text = o.show_virtual_text,
				})
			end)
		end)
	end

	local function hideDiagnosticVirtualText()
		assert(show_virtual_text_timer):stop()
		o.show_virtual_text = false

		vim.diagnostic.config({
			virtual_text = o.show_virtual_text,
		})
	end

	vim.api.nvim_create_augroup("Diagnostics", {})
	vim.api.nvim_create_autocmd("CursorHold", {
		group = "Diagnostics",
		callback = showHover,
	})

	vim.api.nvim_create_autocmd("InsertEnter", {
		group = "Diagnostics",
		callback = hideDiagnosticVirtualText,
	})

	vim.api.nvim_create_autocmd("CursorHold", {
		group = "Diagnostics",
		callback = showDiagnosticVirtualText,
	})
end

local setup = function()
	configNative()
	setupAutoCommands()
end

setup()

return {}
