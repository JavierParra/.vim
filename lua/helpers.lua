local M = {}

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

M.throttle = function(fn, wait_time, opts)
	wait_time = wait_time or 200
	opts = opts or {}
	local leading = opts.leading ~= false -- default to true
	local trailing = opts.trailing
	local max_wait = opts.max_wait

	local timer = nil
	local last_ran = -math.huge
	local last_invoked = -math.huge
	local last_return = nil

	if max_wait == nil then
		max_wait = wait_time
	end

	local function clear_timer()
		if timer then
			timer:stop()
			timer:close()
		end
		timer = nil
	end

	local function invoke_fn(args)
		last_ran = vim.loop.now()
		last_return = fn(unpack(args))
		clear_timer()
		return last_return
	end

	local function schedule_trailing_call(args)
		if not trailing then
			return
		end

		clear_timer()
		timer = vim.defer_fn(function()
			timer = nil
			invoke_fn(args)
		end, wait_time)
	end

	if not leading and not trailing then
		vim.notify("Throttled function without leading or trailing will never be called", vim.log.levels.WARN)
	end

	local function throttled(...)
		local args = { ... }
		local now = vim.loop.now()

		-- We haven't invoked the function in at least `wait_time`. It's a new "block"
		local is_leading_invocation
		if max_wait <= 0 then
			is_leading_invocation = math.max(last_invoked, last_ran) + wait_time < now
		else
			is_leading_invocation = last_invoked + max_wait < now
		end
		last_invoked = now

		if is_leading_invocation then
			if leading then
				invoke_fn(args)
			else
				-- Update last_ran so we don't invoke the fn within max_wait of the leading edge
				last_ran = now
			end
		end

		if max_wait > 0 and not is_leading_invocation and last_ran + max_wait < now then
			invoke_fn(args)
		end

		schedule_trailing_call(args)
		return last_return
	end

	return throttled, clear_timer
end

M.debounce = function(fn, wait_time, opts)
	opts = opts or {}

	if opts.leading == nil and opts.trailing == nil then
		opts.trailing = true
	end
	opts.max_wait = -1
	return M.throttle(fn, wait_time, opts)
end


return M