local M = {}

local cache_version = "1"
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

local function serialize(value)
	local kind = type(value)

	if kind == "nil" then
		return "nil"
	end

	if kind == "boolean" or kind == "number" then
		return tostring(value)
	end

	if kind == "string" then
		return string.format("%q", value)
	end

	if kind ~= "table" then
		error("unsupported Base46 cache fingerprint value: " .. kind)
	end

	local keys = {}
	for key in pairs(value) do
		keys[#keys + 1] = key
	end

	table.sort(keys, function(left, right)
		return type(left) .. tostring(left) < type(right) .. tostring(right)
	end)

	local parts = {}
	for _, key in ipairs(keys) do
		parts[#parts + 1] = serialize(key) .. "=" .. serialize(value[key])
	end

	return "{" .. table.concat(parts, ",") .. "}"
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

local function local_theme_source(config)
	local path = vim.fn.stdpath("config") .. "/lua/themes/" .. config.theme .. ".lua"

	return read(path)
end

local function fingerprint()
	local config = require("nvconfig").base46
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
		serialize(config),
		local_theme_source(config),
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
