set runtimepath^=/.vim runtimepath+=~/.vim/after

let g:python2_host_prog = '/usr/bin/python'
let g:python3_host_prog = '~/.vimvenv3/bin/python3'

let &packpath = &runtimepath

source ~/.vimrc

