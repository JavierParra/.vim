local function map(tbl, fn)
	local result = {}
	for i, v in ipairs(tbl) do
		result[i] = fn(v, i)
	end
	return result
end

local function sync_mason_packages(ensure_installed)
	local mr = require("mason-registry")

	local notification
	local notify = require"custom.live_notify".create_notification({
		title = "Mason live?"
	})

	local function do_sync_packages()
		-- Get list of installed packages
		local installed_packages = {}
		local to_remove = {}
		for _, pkg in ipairs(mr.get_installed_packages()) do
			table.insert(installed_packages, pkg.name)
			local shouldRemove = true
			for _, tool in ipairs(ensure_installed) do
				if pkg.name == tool then
					shouldRemove = false
					break
				end
			end
			if shouldRemove == true then
				table.insert(to_remove, pkg.name)
			end
		end

		-- Find packages to install
		local to_install = {}
		for _, tool in ipairs(ensure_installed) do
			local is_installed = false
			for _, pkg_name in ipairs(installed_packages) do
				if pkg_name == tool then
					is_installed = true
					break
				end
			end

			if not is_installed then
				table.insert(to_install, tool)
			end
		end

		local total_operations = #to_remove + #to_install
		local remaining_operations = total_operations

		local get_header = function ()
			return total_operations - remaining_operations .. "/" .. total_operations .. ": "
				.. table.concat(map(to_install, function(p) return "+"..p end), " ")
				.. " " .. table.concat(map(to_remove, function(p) return "-"..p end), " ")
		end

		local nt = function(msg)
			local done = remaining_operations == 0
			notify(get_header() .. "\n" .. msg, vim.log.levels.INFO, { done = done })
		end

		if total_operations > 0 then
			nt("Syncing packages")
		end

		-- Install missing packages
		if #to_install > 0 then
			for _, pkg_name in ipairs(to_install) do
				local pkg = mr.get_package(pkg_name)
				pkg:install({}, function()
					remaining_operations = remaining_operations - 1
					nt("Installed: " .. pkg_name)
				end)
			end
		end

		-- Remove unwanted packages
		if #to_remove > 0 then
			for _, pkg_name in ipairs(to_remove) do
				local pkg = mr.get_package(pkg_name)
				pkg:uninstall({}, function()
					remaining_operations = remaining_operations - 1
					nt("Removed: " .. pkg_name)
				end)
			end
		end
	end

	-- vim.notify("Will schedule install", vim.log.levels.DEBUG)
	mr.refresh(do_sync_packages)
end

local M = {
	"williamboman/mason.nvim",
	lazy = false,
	dependencies = {
		"rcarriga/nvim-notify",
	},
	cmd = { "Mason", "MasonInstall", "MasonUpdate" },
	opts = {
		ensure_installed = {
			"stylua",
			"prettier",
		},
	},

	config = function(_, opts)
		require("mason").setup(opts)
		vim.g.mason_binaries_list = opts.ensure_installed

		-- Install new packages when config changes
		sync_mason_packages(opts.ensure_installed)
	end,
}

return M
