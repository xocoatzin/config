require("dap-python").setup("python3")

local dap = require("dap")

vim.fn.sign_define(
	"DapBreakpoint",
	{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpointLine", numhl = "DapBreakpointLine" }
)
vim.fn.sign_define("DapBreakpointCondition", {
	text = "ﳁ",
	texthl = "DapBreakpointCondition",
	linehl = "DapBreakpointLine",
	numhl = "DapBreakpointLine",
})
vim.fn.sign_define("DapBreakpointRejected", {
	text = "",
	texthl = "DapBreakpointRejected",
	linehl = "DapBreakpointLine",
	numhl = "DapBreakpointLine",
})
vim.fn.sign_define(
	"DapLogPoint",
	{ text = "", texthl = "DapLogPoint", linehl = "DapLogPointLine", numhl = "DapLogPointLine" }
)
vim.fn.sign_define(
	"DapStopped",
	{ text = "", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "DapStoppedLine" }
)
-- dap.adapters.python = {
-- 	type = "executable",
-- 	command = ".venv3/bin/python",
-- 	args = { "-m", "debugpy.adapter" },
-- }

vim.keymap.set("n", "<F1>", require("dap").step_back, { desc = "[DAP] Step Back" })
vim.keymap.set("n", "<F2>", require("dap").step_into, { desc = "[DAP] Step Into" })
vim.keymap.set("n", "<F3>", require("dap").step_over, { desc = "[DAP] Step Over" })
vim.keymap.set("n", "<F4>", require("dap").step_out, { desc = "[DAP] Step Out" })
vim.keymap.set("n", "<F5>", require("dap").continue, { desc = "[DAP] Continue" })
vim.keymap.set("n", "<leader>dr", require("dap").repl.open, { desc = "[DAP] Open repl" })
vim.keymap.set("n", "<leader>db", require("dap").toggle_breakpoint, { desc = "[DAP] Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
	require("dap").set_breakpoint(vim.fn.input("[DAP] Condition > "))
end, {
	desc = "[DAP] Toggle Breakpoint (cond.)",
})
vim.keymap.set("n", "<leader>dL", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("[DAP] Log Message > "))
end, {
	desc = "[DAP] Add Log Point Message",
})

-- map("<leader>de", require("dapui").eval)
-- map("<leader>dE", function()
-- 	require("dapui").eval(vim.fn.input("[DAP] Expression > "))
-- end)
--
require("nvim-dap-virtual-text").setup({
	commented = true,
})

local dapui = require("dapui")
dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
