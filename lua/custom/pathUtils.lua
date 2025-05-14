local Path = require "plenary.path"
local os_home = vim.uv.os_homedir()

local M = {}

M.normalize_to_home = function(dir)
	local p = Path:new(dir)

	if vim.startswith(dir, os_home) then
		return "~/" .. p:make_relative(os_home)
	else
		return dir
	end
end

M.normalize_to_cwd = function(dir)
	local p = Path:new(dir)
	local cwd = vim.fn.getcwd()

	if vim.startswith(dir, os_home) then
		return p:make_relative(cwd)
	else
		return dir
	end
end

return M
