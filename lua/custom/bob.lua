local M = {}

local TTL = 3600 -- 1 hour

--- @class Version
--- @field major integer
--- @field minor integer
--- @field patch integer
--- @field prerelease 'dev'|false
--- @field build string | false
local Version = {}

--- @class State
--- @field has_bob boolean|nil If the value is `nil` it means we haven't checked.
--- @field managed_by_bob boolean|nil
--- @field bob_version Version | nil
--- @field running_version Version | nil
--- @field last_checked number | nil Timestamp of the last time we checked the version
--- @field running boolean Whether version check is in progress
local bob_state = {
	has_bob = nil,
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
		local match = string.match(result.stdout, "/bob/", 0)
		if result.code > 0 or match == nil then
			callback(false)
			return
		end
		callback(true)
	end)
end

---- @returns Version
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

	-- Try release version
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

	error("Unable to parse version " .. versionString)
end

local function get_nvim_executable_version(executable, callback)
	local cb = nil
	if callback then
		cb = function(result)
			callback(result)
		end
	end
	return vim.system({ executable, "--version" }, {}, cb)
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
			get_nvim_executable_version("nvim", function(res)
				local version = parse_nvim_version(res.stdout)
				bob_state.running = false
				bob_state.bob_version = version
				bob_state.last_checked = os.time()
			end)
		end)
	end)
end

local function tagged_version_file_path()
	return vim.fn.stdpath("data") .. "/bob-stable-version.txt"
end

local function find_bob_directory_blocking()
	local path = vim.system({ "which", "nvim" }, { text = true }):wait()
	if path.code > 0 then
		error("Cannot which nvim")
	end
	local dir = path.stdout:match("([a-zA-Z0-9%.%/%-%_]-)/nvim%-bin/nvim")
	if dir == nil then
		-- We throw here because `check_nightly` already checks that nvim is
		-- managed by bob. If we cannot parse the path, it is an exceptional case.
		error("Cannot determine bob path")
	end

	return dir
end

-- Takes a `version` object and returns a bob compatible format
--- @param version Version
--- @returns string
local function format_bob_version(version)
	local version_string

	if version.prerelease then
		-- I'm not sure why but nvim prepends `g` to the commit hash in the build
		-- field.
		local commit = version.build:match("g?(" .. ("%w"):rep(7) .. ")")
		version_string = "nightly-" .. commit
	else
		version_string = string.format("v%d.%d.%d", version.major, version.minor, version.patch)
	end

	return version_string
end

-- Rolls back to latest version tagged as `stable`.
-- There's a bug in `bob` that ignores `bob use` with nightly versions so we
-- work around that if that's the case.
M.rollback_to_stable = function()
	if bob_state.managed_by_bob == nil then
		vim.notify("Version not yet available")
		check_nightly()
		return
	end

	if bob_state.managed_by_bob == false then
		vim.notify("nvim version is not managed by bob", vim.log.levels.ERROR)
		return
	end

	local path = tagged_version_file_path()

	if vim.fn.filereadable(path) == 0 then
		vim.notify("No version tagged as stable", vim.log.levels.ERROR)
		return
	end

	---@type string[]
	local lines = vim.fn.readfile(path)
	local stable_version = lines[1]

	if not stable_version then
		vim.notify("Tagged version file is empty", vim.log.levels.ERROR)
		return
	end

	local installed_version = format_bob_version(bob_state.bob_version)
	if installed_version == stable_version then
		---@type string
		local hint = ""
		local running_version = format_bob_version(bob_state.running_version)
		if running_version ~= installed_version then
			hint = string.format("\nCurrent running version=%s differs. Restart needed.", running_version)
		end

		vim.notify(string.format("Bob version=%s matches tagged version.%s", installed_version, hint), vim.log.levels.WARN)
		return
	end

	-- All these operations are blocking because this is only meant to be an user
	-- initiated operation.
	vim.notify("Rolling back to " .. stable_version .. "...", vim.log.levels.INFO)
	local bob_path = find_bob_directory_blocking()
	local bin_subpath = "bin/nvim"

	local version_path = function(version)
		return bob_path .. "/" .. version
	end

	-- Fork for nightly and release versions
	if stable_version:match("^nightly-") then
		-- If the tagged version is not already installed by bob, give up.
		-- TODO Install by commit instead of giving up
		if vim.fn.getftype(version_path(stable_version)) ~= "dir" then
			vim.notify(string.format("Version %s not found in bob", stable_version), vim.log.levels.ERROR)
			return
		end

		-- If there's already a nightly version installed (99% of the time), copy
		-- it to make it available for future rollback.
		if vim.fn.getftype(version_path("nightly")) == "dir" then
			local res = get_nvim_executable_version(version_path("/nightly") .. "/" .. bin_subpath):wait()
			local nightly_version = format_bob_version(parse_nvim_version(res.stdout))

			-- If we don't already have a rollback version, create it
			if vim.fn.getftype(bob_path .. "/" .. nightly_version) ~= "dir" then
				vim.system({ "cp", "-r", version_path("nightly"), version_path(nightly_version) }):wait()
			end
			-- Remove the nightly version so we can replace it with the stable one
			vim.system({ "rm", "-rf", version_path("nightly") }):wait()
		end

		vim.system({ "cp", "-r", version_path(stable_version), version_path("nightly") }):wait()
		vim.system({ "bob", "use", stable_version }):wait()
	else
		-- Requested version is from nvim release. This is the easy part
		vim.system({ "bob", "use", stable_version }, { text = true }):wait()
	end

	-- Sanity check
	local new_version = format_bob_version(parse_nvim_version(get_nvim_executable_version("nvim"):wait().stdout))

	vim.notify(string.format("Version %s is ready.\nRestart nvim to use", stable_version), vim.log.INFO)
end

M.tag_stable = function()
	local version = bob_state.running_version
	if version == nil then
		vim.notify("Version not yet available")
		check_nightly()
		return
	end

	local version_string = format_bob_version(version)

	vim.fn.writefile({ version_string }, tagged_version_file_path())
	return version_string
end

--- Check if nvim needs restart due to version mismatch
---- @return boolean|nil true if restart needed, false if not, nil if unknown
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