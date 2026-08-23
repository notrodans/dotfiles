local M = {}

local function backend()
	return require("resession")
end

function M.save()
	backend().save()
end

function M.load()
	backend().load()
end

function M.delete()
	backend().delete()
end

return M
