local M = {}
local notify = require("notify")

local function find_last_notification()
	local history = notify.history({ include_hidden = true })

	return history[#history]
end

M.create_notification = function(opts)
	local notification = nil
	local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
	local frame = 1
	local done = false
	local queue = {}
	local opening = false
	local spinning = false

	local function spin()
		if done == true or not spinning then
			spinning = false
			return
		end

		frame = (frame % #spinner_frames) + 1

		notification = notify(nil, nil, {
			icon = spinner_frames[frame],
			replace = notification,
		})

		if notification == nil then
			error("notification is nil")
		end

		vim.defer_fn(function()
			spin()
		end, 100)
	end

	function doNotify(msg, level, meta)
		if done then
			error("Notification is done")
		end

		if opening then
			-- queue is an array in case I want to not only display the last one in
			-- the future.
			queue = { { msg = msg, level = level, meta = meta } }
			return
		end

		meta = meta or {}
		frame = (frame + 1) % #spinner_frames

		if meta.done then
			done = true
		end

		opening = opening == false and notification == nil
		local notify_opts = vim.tbl_extend(
			"keep",
			{
				icon = meta.done == false and spinner_frames[frame] or "",
			},
			opts or {},
			{
				replace = notification,
				-- Do a long timeout while we're not done
				timeout = meta.done and 1500 or 30000,
				-- If the notification was replaced it will not call `on_open`
				on_open = function()
					notification = find_last_notification()
					opening = false
					if not done and not spinning then
						spinning = true
						spin()
					end
					if #queue > 0 then
						local next = queue[#queue]
						queue = {}
						vim.defer_fn(function()
							doNotify(next.msg, next.level, next.meta)
						end, 10)
					end
				end,
			}
		)

		local res = notify(msg, level, notify_opts)

		-- If the notification was replaced, it will return the id.
		if res then
			notification = res
			-- This should not happen
			if opening == true then
				opening = false
			end
		end
	end

	return doNotify
end

-- elsewhere

return M
