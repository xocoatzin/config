set runtimepath^=/.vim runtimepath+=~/.vim/after

let g:python3_host_prog = '~/.venv/nvim/bin/python3'

let &packpath = &runtimepath

source ~/.vimrc

lua << EOF
require("statusline.lua")
require("bufferline.lua")
require("treesitter.lua")
--require("telescope-nvim.lua")
EOF

set guifont=FiraCode\ Nerd\ Font:h14
