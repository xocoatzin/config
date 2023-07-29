-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

-- show absolute numbers in insert mode, relative in normal mode
opt.relativenumber = true
vim.cmd([[
  augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
  augroup END
]])

opt.hidden = true -- allow background buffers
opt.joinspaces = false -- join lines without two spaces

-- Disable LazyVim's default clipboard.
-- opt.clipboard = ""

-- Tab complete for cmd mode should autocomplete the first result immediately.
opt.wildmode = "full"

-------------------------------------------------------------------------------

-- Search down into subfolders, with auto-complete
vim.o.path = vim.o.path .. '**'
-- Sets how many lines of history VIM has to remember
vim.o.history = 500
vim.o.guifont='JetBrainsMono Nerd Font:h14'
-- vim.o.guifont='FiraCode Nerd Font:h14'
-- Global Statusline
-- vim.o.laststatus = 3
-- Diff options
vim.o.diffopt=vim.o.diffopt .. ',vertical'
vim.o.whichwrap=vim.o.whichwrap .. ',<,>,h,l'
-- Set 10 lines to the cursor - when moving vertically using j/k
vim.o.scrolloff=10
-- Turn on the WiLd menu (ctrl-y to accept)
vim.o.wildmenu=true
-- Ignore compiled files
vim.o.wildignore='*.o,*~,*.pyc,*/.git/*,*/.DS_Store'
-- Highlight search results
vim.o.hlsearch=true
-- While typing, show where the pattern matches.
vim.o.incsearch=true
-- Show matching brackets when text indicator is over them
vim.o.showmatch=true
-- How many tenths of a second to blink when matching brackets
vim.o.matchtime=5

-- No annoying sound on errors
vim.o.errorbells=false
vim.o.visualbell=false

-- Time in milliseconds to wait for a mapped sequence to complete.
vim.o.timeoutlen=500
-- en_US as the standard language
vim.o.langmenu='en'
-- Automatic detect end of line style
vim.o.fileformats='unix,dos,mac'
-- Draw always the sign column
vim.o.signcolumn='yes:2'

-- Backups and undoing
vim.o.backup=true
vim.o.backupdir='/tmp'
vim.o.backupskip='/tmp/*,/private/tmp/*'
vim.o.backupcopy='yes'
vim.o.directory='~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp'
vim.o.writebackup=true
vim.opt.undodir=vim.fn.expand('$HOME/.nvim/undo')
vim.opt.undofile=true

--
-- Text, tab and indent related
--
-- Use spaces instead of tabs
vim.o.smarttab=true
-- The number of spaces to use for each step of auto indent.
vim.o.shiftwidth=4
-- 1 tab == 4 spaces
vim.o.tabstop=4
-- Wrap long lines
vim.o.linebreak=true
vim.o.textwidth=500
-- Auto indent
vim.o.autoindent=true
-- Wrap lines
vim.o.wrap=true


--------------------------------------------------------------------------------
-- Spell checking
--------------------------------------------------------------------------------
vim.o.spell=true

-- Non printable chars
-- vim.o.showbreak='↪\\'
-- vim.o.listchars='tab:»\ ,eol:¬,nbsp:␣,space:·,trail:•,extends:→,precedes:← '

--------------------------------------------------------------------------------
-- Appearance
--------------------------------------------------------------------------------
-- vim.o.fillchars=vim.o.fillchars .. 'vert:│'
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.background='dark'
vim.o.winbar=[[%=%m %f]]
vim.o.colorcolumn="80,100"

--------------------------------------------------------------------------------
-- Moving around, tabs, windows, and buffers
--------------------------------------------------------------------------------
-- Specify the behavior when switching between buffers
-- vim.o.switchbuf='useopen,usetab,uselast'
-- Show tabline always
-- vim.o.showtabline=2
vim.o.splitkeep='screen'
