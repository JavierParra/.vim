local schemes = require("colorSchemes")
local monokaiClassic = schemes.monokaiClassic
local path_utils = require("custom.path_utils")
local bob = require("custom.bob")

local function visual_multi()
	local result = vim.api.nvim_call_function("VMInfos", {})
	if result.current then
		return "VM: " .. vim.inspect(result.patterns[1]) .. " " .. result.current .. "/" .. result.total
	end
	return ""
end

local function cwd()
	if vim.g.started_by_firenvim == true then
		return ""
	end
	return path_utils.normalize_to_home(vim.fn.getcwd())
end

local function relativeFile()
	local path = path_utils.normalize_to_cwd(vim.fn.expand("%"))

	if vim.g.started_by_firenvim == true then
		local site = path:match("([^_]+)_")
		if site ~= nil then
			return site
		end
	end

	return path
end

local function needs_restart()
	local res = bob.needs_restart()
	if res == nil then
		-- return ""
		return ""
	end

	if res == true then
		return "󰚰"
	end

	return ""
end

local function recording()
	local recording_register = vim.fn.reg_recording()
	if recording_register == "" then
		return ""
	else
		return "Recording @" .. recording_register
	end
end

local function first(...)
	local args = { ... }
	return function()
		for _, v in ipairs(args) do
			local result = v()
			if result ~= "" then
				return result
			end
		end
	end
end

local function mode()
	return vim.api.nvim_get_mode().mode
end

local function inVisual()
	local m = mode()
	if m:lower() == 'v' then
		return true
	end

	if m == '' then
		return true
	end

	return false
end

local function selectioncount()
	local cursorPos = vim.fn.getpos(".")
	local visualPos = vim.fn.getpos("v")

	local selection = vim.fn.getregion(cursorPos, visualPos, {
		type = mode()
	})

	local chars = table.concat(selection, '\n')
	local charLen = vim.fn.strcharlen(chars)
	local byteLen = vim.fn.strlen(chars)
	local byteCount = ''

	if byteLen ~= charLen then
		byteCount = string.format(' (%d)', byteLen)
	end

	return string.format("%d:%d%s", #selection, charLen, byteCount)
end

-- them colors
local colors = {
	bg = monokaiClassic.base2,
	fg = monokaiClassic.grey,

	alt_bg = monokaiClassic.base4,
	alt_fg = monokaiClassic.base7,

	light_bg = monokaiClassic.base4,
	light_fg = monokaiClassic.base7,

	normal = monokaiClassic.base4,
	insert = monokaiClassic.aqua,
	visual = monokaiClassic.yellow,
	replace = monokaiClassic.purple,
}

function overrideRecording(table)
	return function()
		local recording_register = vim.fn.reg_recording()
		if recording_register == "" then
			return table
		end

		return { bg = monokaiClassic.pink, fg = monokaiClassic.white }
	end
end

local theme = {
	normal = {
		a = overrideRecording({ fg = colors.alt_fg, bg = colors.normal }),
		b = { fg = colors.alt_fg, bg = colors.alt_bg },
		c = { fg = colors.fg, bg = colors.bg },
		-- x = { fg = colors.fg, bg = monokaiClassic.aqua },
		y = { fg = colors.light_fg, bg = colors.light_bg },
		-- z = { fg = colors.fg, bg = monokaiClassic.purple },
	},
	insert = {
		a = overrideRecording({ fg = colors.insert, bg = colors.alt_bg }),
		b = { fg = colors.light_fg, bg = colors.alt_bg },
		c = { fg = colors.fg, bg = colors.bg },
		y = { fg = colors.insert, bg = colors.light_bg },
		z = { fg = colors.bg, bg = colors.insert },
	},
	visual = {
		a = overrideRecording({ fg = colors.visual, bg = colors.alt_bg }),
		b = { fg = colors.light_fg, bg = colors.alt_bg },
		c = { fg = colors.fg, bg = colors.bg },
		y = { fg = colors.visual, bg = colors.light_bg },
		z = { fg = colors.bg, bg = colors.visual },
	},
	replace = {
		a = overrideRecording({ fg = colors.light_bg, bg = colors.replace }),
		b = { fg = colors.light_fg, bg = colors.alt_bg },
		c = { fg = colors.fg, bg = colors.bg },
		y = { fg = colors.replace, bg = colors.light_bg },
	},
	inactive = {
		a = { fg = colors.fg, bg = colors.bg },
		b = { fg = colors.fg, bg = colors.bg },
		c = { fg = colors.fg, bg = colors.bg },
	},
}

theme.command = theme.normal
theme.terminal = theme.insert

---@type LazyPluginSpec
return {
	"nvim-lualine/lualine.nvim",
	lazy = false,
	-- event = "UIEnter",
	config = function()
		require("lualine").setup({
			options = {
				theme = theme,
			},
			sections = {
				lualine_a = {
					first(recording, relativeFile),
				},
				lualine_b = {
					-- "branch",
					{
						"diagnostics",
						sections = { "error", "warn" },
					},
				},
				lualine_c = { cwd },
				lualine_x = {
					{
						function()
							local coc_status = vim.g.coc_status

							if coc_status == nil then
								return ""
							end

							local char = vim.fn.strcharpart(vim.g.coc_status, 1, 1)

							if string.match(char, "%w") then
								return ""
							end

							return char
						end,
						separator = ""
					},
					{
						"filetype",
					},
				},
				lualine_y = { {'FugitiveHead', icon = ''} },
				lualine_z = {
					{ "location",
						separator = "",
						cond = function ()
							return inVisual() == false
						end
					},
					{
						selectioncount,
						separator = "",
						cond = inVisual
					},
					needs_restart,
					"searchcount"
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			always_show_tabline = true,
			extensions = { "fzf" },
		})
	end,
}