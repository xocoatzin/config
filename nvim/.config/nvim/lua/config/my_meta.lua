require("meta")
require("meta.cmds")
require("meta.hg").setup()


function call_berry(mode)
	vim.fn.jobstart({'fish', '-c', 'berry ' .. mode .. ' ' .. vim.fn.getcwd()})
end

vim.keymap.set(
	"n",
	"<space>bt",
	function() call_berry("test") end,
	{ noremap = true, silent = true, desc = "[Berry] Tests" }
)

vim.keymap.set(
	"n",
	"<space>br",
	function() call_berry("run") end,
	{ noremap = true, silent = true, desc = "[Berry] Run" }
)

return {
	is_meta = true
}
