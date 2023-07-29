-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.api.nvim_set_keymap
local cmd = vim.cmd

-- map arrow keys to pane shifts.
-- map("n", "<Up>", "<C-w><C-k>", { noremap = true })
-- map("n", "<Down>", "<C-w><C-j>", { noremap = true })
-- map("n", "<Left>", "<C-w><C-h>", { noremap = true })
-- map("n", "<Right>", "<C-w><C-l>", { noremap = true })

-- avoid mistyping write/quit
cmd("command WQ wq")
cmd("command Wq wq")
cmd("command W w")
cmd("command Q q")
cmd("command Vs vs")
cmd("command VS vs")
cmd("command Sp sp")
cmd("command SP sp")

-- using Meta/Alt can result in <Esc> being interpreted as Meta/Alt, which makes
-- for odd behaviors when quickly pressing <Esc> sometimes, so disable Meta
-- chords.
-- https://github.com/neovim/neovim/issues/20064
-- vim.keymap.del({ "n", "i", "v" }, "<A-j>")
-- vim.keymap.del({ "n", "i", "v" }, "<A-k>")
--


-- Delete, not cut
-- https://stackoverflow.com/a/11993928/575085
-- To the black hole register
map("n", "d", [["_d]], { noremap = true })
map("x", "d", [["_d]], { noremap = true })
map("v", "d", [["_d]], { noremap = true })
map("n", "D", [["_D]], { noremap = true })
map("v", "D", [["_D]], { noremap = true })
map("n", "c", [["_c]], { noremap = true })
map("v", "c", [["_c]], { noremap = true })
map("n", "C", [["_C]], { noremap = true })
map("v", "C", [["_C]], { noremap = true })
map("n", "x", [["+x]], { noremap = true })
map("x", "x", [["+x]], { noremap = true })
map("x", "p", [["+p]], { noremap = true })
map("x", "P", [["+P]], { noremap = true })

-- dial.nvim
vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), {noremap = true})
vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), {noremap = true})
vim.keymap.set("n", "g<C-a>", require("dial.map").inc_gnormal(), {noremap = true})
vim.keymap.set("n", "g<C-x>", require("dial.map").dec_gnormal(), {noremap = true})
vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), {noremap = true})
vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), {noremap = true})
vim.keymap.set("v", "g<C-a>",require("dial.map").inc_gvisual(), {noremap = true})
vim.keymap.set("v", "g<C-x>",require("dial.map").dec_gvisual(), {noremap = true})

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

