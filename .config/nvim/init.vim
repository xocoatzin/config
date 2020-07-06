" To install nvim on ubuntu:
" sudo apt-get install software-properties-common
" sudo add-apt-repository ppa:neovim-ppa/unstable
" sudo apt-get update
" sudo apt-get install neovim
" sudo apt-get install python-dev python-pip python3-dev python3-pip
" sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
" sudo update-alternatives --config vi
" sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
" sudo update-alternatives --config vim
" sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
" sudo update-alternatives --config editor
"
" Then when running neovim the first time, run ":PlugInstall"

" Python paths
" pip2 install --user neovim
" pip3 install --user neovim

set runtimepath^=/.vim runtimepath+=~/.vim/after

" let g:python2_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '~/venv/nvim/bin/python3'

let &packpath = &runtimepath

source ~/.vimrc

