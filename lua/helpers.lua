local M = { }

M.is_array = function(var)
	-- First check if it's a table
	if type(var) ~= "table" then
		return false
	end

	-- Check if it has sequential numeric keys
	local count = 0
	for _ in pairs(var) do
		count = count + 1
	end

	-- If #var (length operator) equals the number of keys,
	-- then it's an array with sequential keys
	return count == #var
end

-- Command helpers
M.cmd = function(command)
	return function()
		if M.is_array(command) then
			for _, _cmd in pairs(command) do
				vim.cmd(_cmd)
			end
		else
			vim.cmd(command)
		end
	end
end

return M