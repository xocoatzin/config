local health = require("health")
local M = {}

local check_cmd = function(name)
	if vim.fn.executable(name) == 1 then
		health.report_ok(name .. " found")
	else
		health.report_error(name .. " not found")
	end
end
-- vim.health.report_info({msg})
-- vim.health.report_ok({msg})
-- vim.health.report_warn({msg} [, {advice}])
-- vim.health.report_error({msg} [, {advice}])

M.check = function()
	health.report_start("Checking for general utilities...")
	check_cmd("git")
	check_cmd("ag")
	check_cmd("rg")
	check_cmd("fd")
	check_cmd("prettier")
	health.report_start("Checking for python dependencies...")
	check_cmd("python3")
	check_cmd("black")
	check_cmd("mypy")
	check_cmd("pyright")
	check_cmd("isort")
	check_cmd("flake8")
	check_cmd("pydocstyle")
	check_cmd("debugpy")
end

return M
