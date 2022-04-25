vim.o.runtimepath='/.vim,' .. vim.o.runtimepath .. ',~/.vim/after'

-- Search down into subfolders, with auto-complete
vim.o.path = vim.o.path .. '**'
-- Sets how many lines of history VIM has to remember
vim.o.history = 500
-- Enable mouse support (resize splits, select in visual mode, etc)
vim.o.mouse = 'a'



-- Enables 24-bit RGB color (and use "gui" highlights)
vim.o.termguicolors = true
vim.o.guifont='FiraCode Nerd Font:h14'
-- Highlight the screen line of the cursor with CursorLine
vim.o.cursorline = true
-- Use system clipboard
vim.o.clipboard='unnamedplus'
-- Enable folding
vim.o.foldmethod='indent'
vim.o.foldlevel=99
-- Add a bit extra margin to the left
vim.o.foldcolumn='1'
-- Diff options
vim.o.diffopt=vim.o.diffopt .. ',vertical'
-- Height of the command bar
vim.o.cmdheight=1
-- A buffer becomes hidden when it is abandoned
vim.o.hidden=true
vim.o.whichwrap=vim.o.whichwrap .. ',<,>,h,l'
-- Set 7 lines to the cursor - when moving vertically using j/k
vim.o.scrolloff=10

-- Turn on the WiLd menu (ctrl-y to accept)
vim.o.wildmenu=true
-- Ignore compiled files
vim.o.wildignore='*.o,*~,*.pyc,*/.git/*,*/.DS_Store'

-- Ignore case in search patterns
vim.o.ignorecase=true
-- Override ignorecase if the pattern contains an uppercase character.
vim.o.smartcase=true
-- Highlight search results
vim.o.hlsearch=true
-- While typing, show where the pattern matches.
vim.o.incsearch=true
-- Preview replacements
vim.o.inccommand='nosplit'
-- Don't redraw while executing macros (good performance config)
vim.o.lazyredraw=true
-- Show matching brackets when text indicator is over them
vim.o.showmatch=true
-- How many tenths of a second to blink when matching brackets
vim.o.matchtime=5

-- No annoying sound on errors
vim.o.errorbells=false
vim.o.visualbell=false
--vim.o.t_vb=''


-- Set the title of the window
vim.o.title=true
-- Time in milliseconds to wait for a mapped sequence to complete.
vim.o.timeoutlen=500
-- en_US as the standard language
vim.o.langmenu='en'
-- Automatic detect end of line style
vim.o.fileformats='unix,dos,mac'
-- Time to wait before write swap file to disk
vim.o.updatetime=100
-- Don't pass messages to |ins-completion-menu|.
-- vim.o.shortmess=vim.o.shortmess .. 'c'
-- Draw always the sign column
vim.o.signcolumn='yes:2'



-- Backups and undoing
vim.o.backup=true
vim.o.backupdir='/tmp'
vim.o.backupskip='/tmp/*,/private/tmp/*'
vim.o.backupcopy='yes'
vim.o.directory='~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp'
vim.o.writebackup=true


--
-- Text, tab and indent related
--
-- Use spaces instead of tabs
vim.o.expandtab=true
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
-- Smart indent
vim.o.smartindent=true
-- Wrap lines
vim.o.wrap=true


--------------------------------------------------------------------------------
-- Spell checking
--------------------------------------------------------------------------------
vim.o.spelllang='en_us'


-- Non printable chars
-- vim.o.showbreak='↪\\'
-- vim.o.listchars='tab:»\ ,eol:¬,nbsp:␣,space:·,trail:•,extends:→,precedes:← '
vim.o.list = true

--------------------------------------------------------------------------------
-- Appearance
--------------------------------------------------------------------------------
-- vim.o.fillchars=vim.o.fillchars .. 'vert:│'
vim.o.background='dark'
-- Transparent floating windows
vim.o.pumblend=15

-- Enable 256 colors palette in Gnome Terminal
-- iTerm is `truecolor`
if vim.env.COLORTERM == 'gnome-terminal' then
    vim.o.t_Co=254
end

-- Set true colors
if vim.fn.has('termguicolors') == 1 then
--    vim.o.t_8f='[38;2;%lu;%lu;%lum'
--    vim.o.t_8b='[48;2;%lu;%lu;%lum'
    vim.o.termguicolors=true
end

--------------------------------------------------------------------------------
-- Moving around, tabs, windows, and buffers
--------------------------------------------------------------------------------
-- Specify the behavior when switching between buffers
vim.o.switchbuf='useopen,usetab,uselast'
-- Show tabline always
vim.o.showtabline=2
