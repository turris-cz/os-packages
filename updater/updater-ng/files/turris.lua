--[[
This file is part of updater-ng. Don't edit it.
]]

local uci_cursor = nil
if uci then
	uci_cursor = uci.cursor(root_dir .. "/etc/config")
else
	ERROR("UCI library is not available. Configuration not used.")
end
local function uci_cnf(name, default)
	if uci_cursor then
		return uci_cursor:get("updater", "turris", name) or default
	else
		return default
	end
end

-- Configuration variables
local mode = uci_cnf("mode", "branch") -- should we follow branch or version?
local branch = uci_cnf("branch", "hbs") -- which branch to follow
local version = uci_cnf("version", nil) -- which version to follow

-- Verify that we have sensible configuration
if mode == "version" and not version then
	WARN("Mode configured to be 'version' but no version provided. Changing mode to 'branch' instead.")
	mode = "branch"
end

-- Detect host board
local product = os_release["OPENWRT_DEVICE_PRODUCT"] or os_release["LEDE_DEVICE_PRODUCT"]
if product:match("[Mm]ox") then
	board = "mox"
elseif product:match("[Oo]mnia NG") then
	board = "omnia-ng"
elseif product:match("[Oo]mnia") then
	board = "omnia"
elseif product:match("[Tt]urris 1.x") then
	board = "turris1x"
else
	DIE("Unsupported Turris board: " .. tostring(product))
end
Export('board')

-- Detect container
local env = io.open("/proc/1/environ", "rb")
for name, value in env:read("*a"):gmatch"([^=]+)=([^%z]+)%z?" do
	if name == "container" then
		container=value
		Export("container")
	end
end
env:close()


-- Common connection settings for Turris OS scripts
local script_options = {
	security = "Remote",
	pubkey = {
		"file:///etc/updater/keys/release.pub",
		"file:///etc/updater/keys/standby.pub",
		"file:///etc/updater/keys/test.pub" -- It is normal for this one to not be present in production systems
	}
}

-- Optional scripts
local opt_script_options = {
	security = "Remote",
	pubkey = script_options.pubkey,
	optional = true
}

-- Turris repository server URL (or override)
local repo_url = "https://repo.turris.cz"
local config, config_error = loadfile("/etc/updater/turris-repo.lua")
if config then
	config = config()
	if config.url ~= nil then
		repo_url = config.url
		for _, field in ipairs({"pubkey", "ca", "crl", "ocsp"}) do
			if config[field] ~= nil then
				script_options[field] = config[field]
			end
		end
	end
else
	WARN("Failed to load /etc/updater/turris-repo.lua: " .. tostring(config_error))
end

-- Common URI to Turris OS lists
local base_url
if mode == "branch" then
	base_url = repo_url .. "/" .. branch .. "/" .. board .. "/lists/"
	-- Staged updates (only for hbs)
	if branch == "hbs" then
		local release_data = Fetch(base_url .. "release_date", {
			pubkey = script_options.pubkey,
			optional = true
		}) or "0+17"
		local release_date, release_spread = release_data:match"^(%d+)\+(%d+)"
		if not release_spread then
			release_spread = 17
			release_date = release_data:match"^(%d+)"
		end
		if not release_date then
			release_date = 0
		end
		-- Use only last 8 digits and discard the first 8 as that is the batch number anyway
		local serial = tonumber(string.sub(get_turris_serial(),9,16), 16) or 0
		-- `update_go_time` is time when the release will happen
		-- It needs to be spread evenly and randomly between routers during `release_spread` days
		--
		-- `(release_date + serial) % release_spread` is a random number 0-16
		-- It is fixed per release and router, but can be different for every release
		--
		local update_go_time = release_date + (((release_date + serial) % release_spread) * 3600 * 24)
		-- Are we there yet?
		if update_go_time > os.time() then
			branch = "hbs-old"
			base_url = repo_url .. "/" .. branch .. "/" .. board .. "/lists/"
			WARN("There is a newer version available, but update is scheduled after another " .. string.format("%.1f", ((update_go_time - os.time()) / 3600)) .. " hours. If you want the latest and greatest all the time, switch to one of the development branches.")
		end
	end
elseif mode == "version" then
	base_url = repo_url .. "/archive/" .. version .. "/" .. board .. "/lists/"
else
	DIE("Invalid updater.turris.mode specified: " .. mode)
end

-- The distribution base script. It contains the repository and bunch of basic packages
Script(base_url .. "base.lua", script_options)

-- Additional enabled distribution lists forced by boot arguments
if root_dir == "/" then
	local cmdf = io.open("/proc/cmdline")
	if cmdf then
		for cmdarg in cmdf:read():gmatch('[^ ]+') do
			local key, value = cmdarg:match('([^=]+)=(.*)')
			if key == "turris_lists" then
				for list in value:gmatch('[^,]+') do
					Script(base_url .. list .. ".lua", script_options)
				end
			end
		end
		cmdf:close()
	end
end
