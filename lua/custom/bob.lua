local M = {}

local TTL = 3600 -- 1 hour

local bob_state = {
	has_bob = nil, -- boolean. `nil` means we haven't checked
	managed_by_bob = nil,
	bob_version = nil,
	running_version = nil,
	last_checked = nil,
	running = false,
}

local function is_stale()
	if bob_state.last_checked == nil then
		return true
	end

	local now = os.time()
	if (now - bob_state.last_checked) > TTL then
		return true
	end

	return false
end

local function has_bob(callback)
	vim.system({ "which", "bob" }, {}, function(result)
		if result.code > 0 then
			callback(false)
			return
		end
		callback(true)
	end)
end

local function nvim_is_bob(callback)
	vim.system({ "which", "nvim" }, {}, function(result)
		local match = string.match(result.stdout, "/bob/", 0, true)
		if result.code > 0 or match == nil then
			callback(false)
			return
		end
		callback(true)
	end)
end

local function parse_nvim_version(versionString)
	-- Try development version first
	local major, minor, patch, dev_num, build = versionString:match("NVIM v(%d+)%.(%d+)%.(%d+)%-dev%-(%d+)%+(%w+)")

	if major then
		return {
			major = tonumber(major),
			minor = tonumber(minor),
			patch = tonumber(patch),
			prerelease = "dev",
			dev_number = tonumber(dev_num),
			build = build,
			full_version = string.format("v%s.%s.%s-dev-%s+%s", major, minor, patch, dev_num, build),
		}
	end

	-- Try stable version
	major, minor, patch = versionString:match("NVIM v(%d+)%.(%d+)%.(%d+)")

	if major then
		return {
			major = tonumber(major),
			minor = tonumber(minor),
			patch = tonumber(patch),
			prerelease = false,
			dev_number = false,
			build = false,
			full_version = string.format("v%s.%s.%s", major, minor, patch),
		}
	end

	return nil
end

local function get_env_nvim_version(callback)
	vim.system({ "nvim", "--version" }, {}, function(result)
		callback(parse_nvim_version(result.stdout))
	end)
end

local function check_nightly()
	if bob_state.running or bob_state.has_bob == false or is_stale() == false then
		return
	end

	bob_state.running = true
	local v = vim.version()

	bob_state.running_version = {
		major = v.major,
		minor = v.minor,
		patch = v.patch,
		prerelease = v.prerelease,
		build = v.build,
	}

	has_bob(function(res)
		if res == false then
			bob_state.has_bob = false
			bob_state.running = false
			bob_state.last_checked = os.time()
			return
		end

		bob_state.has_bob = true
		nvim_is_bob(function(res)
			if res == false then
				bob_state.running = false
				bob_state.managed_by_bob = false
				bob_state.last_checked = os.time()
				return
			end

			bob_state.managed_by_bob = true
			get_env_nvim_version(function(version)
				bob_state.running = false
				bob_state.bob_version = version
				bob_state.last_checked = os.time()
			end)
		end)
	end)
end

--- Check if nvim needs restart due to version mismatch
--- @return boolean|nil true if restart needed, false if not, nil if unknown
M.needs_restart = function()
	check_nightly()
	local bob_version = bob_state.bob_version
	local running_version = bob_state.running_version

	-- vim.notify(vim.inspect(bob_state))

	if bob_version == nil or running_version == nil then
		return nil
	end

	if bob_state.has_bob == false or bob_state.managed_by_bob == false then
		return false
	end

	return bob_version.build ~= running_version.build
		or bob_version.major ~= running_version.major
		or bob_version.minor ~= running_version.minor
		or bob_version.patch ~= running_version.patch
end

return M