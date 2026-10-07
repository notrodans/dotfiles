local M = {}

local function backend()
	return require("resession")
end

function M.save()
	vim.ui.input({ prompt = "Session name> " }, function(name)
		if name then
			require("resession").save(name)
		end
	end)
end

function M.load()
	backend().load()
end

function M.delete()
	backend().delete()
end

return M
