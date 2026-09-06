local M = {}

local cache_version = "1"
local config_path = vim.fn.stdpath("config") .. "/lua/nvconfig.lua"
local lock_path = vim.fn.stdpath("config") .. "/lazy-lock.json"
local stamp_path = vim.g.base46_cache .. ".fingerprint"

local function read(path)
	local file = io.open(path, "rb")
	if not file then
		return ""
	end

	local content = file:read("*a")
	file:close()

	return content
end

local function base46_revision()
	local lock = read(lock_path)
	if lock == "" then
		return ""
	end

	local ok, decoded = pcall(vim.json.decode, lock)
	if not ok or type(decoded) ~= "table" or type(decoded.base46) ~= "table" then
		return ""
	end

	return decoded.base46.commit or ""
end

local function local_theme_source()
	local theme = require("nvconfig").base46.theme
	local path = vim.fn.stdpath("config") .. "/lua/themes/" .. theme .. ".lua"

	return read(path)
end

local function fingerprint()
	local version = vim.version()
	local runtime = table.concat({
		tostring(version.major),
		tostring(version.minor),
		tostring(version.patch),
		jit and jit.version or _VERSION,
	}, ".")

	return vim.fn.sha256(table.concat({
		cache_version,
		runtime,
		base46_revision(),
		read(config_path),
		local_theme_source(),
	}, "\0"))
end

local function write_stamp(value)
	vim.fn.mkdir(vim.g.base46_cache, "p")

	local file, err = io.open(stamp_path, "wb")
	if not file then
		error("failed to write Base46 cache fingerprint: " .. tostring(err))
	end

	file:write(value)
	file:close()
end

local function load_cache()
	local files = vim.fn.readdir(vim.g.base46_cache)
	table.sort(files)

	for _, name in ipairs(files) do
		if name ~= "colors" and name ~= "term" and name:sub(1, 1) ~= "." then
			local path = vim.g.base46_cache .. name
			local stat = vim.uv.fs_stat(path)

			if stat and stat.type == "file" then
				dofile(path)
			end
		end
	end
end

function M.rebuild()
	require("base46").load_all_highlights()
	write_stamp(fingerprint())
end

function M.sync()
	local current = fingerprint()
	local cached = read(stamp_path)
	local defaults = vim.g.base46_cache .. "defaults"

	if current ~= cached or not vim.uv.fs_stat(defaults) then
		M.rebuild()
		return
	end

	load_cache()
end

return M
