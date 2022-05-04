"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{
let mapleader = ","
let g:mapleader = ","

filetype plugin on " Enable filetype plugins
filetype indent on
filetype on

set nocompatible
set path+=**                                     " Search down into subfolders, with auto-complete
set history=500                                  " Sets how many lines of history VIM has to remember
set mouse=a                                      " Enable mouse support (resize splits, select in visual mode, etc)
set autoread                                     " Set to auto read when a file is changed from the outside

set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

set termguicolors
set cursorline
set clipboard=unnamedplus                        " Use system clipboard
set foldmethod=indent                            " Enable folding
set foldlevel=99
set foldcolumn=1                                 " Add a bit extra margin to the left
set diffopt+=vertical                            " Diff options
set ruler                                        " Always show current position
set cmdheight=1                                  " Height of the command bar
set hid                                          " A buffer becomes hidden when it is abandoned
set backspace=eol,start,indent                   " Configure backspace so it acts as it should act
set whichwrap+=<,>,h,l
set so=7                                         " Set 7 lines to the cursor - when moving vertically using j/k
set wildmenu                                     " Turn on the WiLd menu
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.DS_Store " Ignore compiled files
set ignorecase                                   " Ignore case when searching
set smartcase                                    " When searching try to be smart about cases
set hlsearch                                     " Highlight search results
set incsearch                                    " Makes search act like search in modern browsers
set inccommand=nosplit                           " Preview replacements
set lazyredraw                                   " Don't redraw while executing macros (good performance config)
set magic                                        " For regular expressions turn magic on
set showmatch                                    " Show matching brackets when text indicator is over them
set mat=2                                        " How many tenths of a second to blink when matching brackets
set noerrorbells                                 " No annoying sound on errors
set novisualbell
set t_vb=
set tm=500
set encoding=utf8                                " Set utf8 as standard encoding
set langmenu=en                                  " en_US as the standard language
set ffs=unix,dos,mac                             " Use Unix as the standard file type
set updatetime=50                                " Time to wait before write swap file to disk
set shortmess+=c                                 " Don't pass messages to |ins-completion-menu|.
set signcolumn=yes:2                             " Draw always

" Backups and undoing
set backup
set backupdir=/tmp
set backupskip=/tmp/*,/private/tmp/*
set backupcopy=yes
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

" Text, tab and indent related
set expandtab                                    " Use spaces instead of tabs
set smarttab                                     " Be smart when using tabs ;)
set shiftwidth=4                                 " 1 tab == 4 spaces
set tabstop=4
set lbr                                          " Linebreak on 500 characters
set tw=500
set ai                                           " Auto indent
set si                                           " Smart indent
set wrap                                         " Wrap lines

" Search for .vimrc files in the project's directory
set exrc
set secure

" Spell checking
set spelllang=en_us
map <leader>ss :setlocal spell!<cr> " Pressing ,ss will toggle and untoggle spell checking
map <leader>sn ]s " Next error
map <leader>sp [s " Prev error
map <leader>sa zg " Add to dictionary
map <leader>s? z= " Show suggestions
inoremap <C-f> <c-g>u<Esc>[s1z=`]a<c-g>u " Correct last error

" Enable folding with the spacebar
" nnoremap <space> za

set showbreak=↪\
set listchars=tab:»\ ,eol:¬,nbsp:␣,space:·,trail:•,extends:→,precedes:← " Non printable chars

" Shortcut for vimrc and auto source on save.
command! VimConfig :tabe ~/.vimrc
command! VimReload source ~/.vimrc

" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif

" Alias for commands
cnoreabbrev Q q
cnoreabbrev W w

" Delete, not cut
" https://stackoverflow.com/a/11993928/575085
" To the black hole register
nnoremap d "_d
xnoremap d "_d
vnoremap d "_d
nnoremap D "_D
vnoremap D "_D
nnoremap c "_c
vnoremap c "_c
nnoremap C "_C
vnoremap C "_C
nnoremap x "+x
xnoremap x "+x
xnoremap p "+p
xnoremap P "+P

" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{
" Enable syntax highlighting
syntax enable
set fillchars+=vert:│
set background=dark

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

try
    colorscheme gruvbox
catch
endtry

" set true colors
if has("termguicolors")
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum
    set termguicolors
endif


" Set git gutter colors (after config. colors so they don't get overwritten
highlight clear SignColumn
highlight FoldColumn guifg=#e4e4e4

if has('nvim-0.1')
  set pumblend=15  " Transparent floating windows
  highlight PmenuSel blend=0
endif
" }}}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{
" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files
augroup GroupGoback
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{
" Remap VIM 0 to first non-blank character
" map 0 ^

" Keep selection when indenting in visual mode.
vmap < <gv
vmap > >gv

if has('macunix')
    nnoremap ∆ :m .+1<CR>==
    nnoremap ˚ :m .-2<CR>==
    inoremap ∆ <Esc>:m .+1<CR>==gi
    inoremap ˚ <Esc>:m .-2<CR>==gi
    vnoremap ∆ :m '>+1<CR>gv=gv
    vnoremap ˚ :m '<-2<CR>gv=gv
else
    nnoremap <A-j> :m .+1<CR>==
    nnoremap <A-k> :m .-2<CR>==
    inoremap <A-j> <Esc>:m .+1<CR>==gi
    inoremap <A-k> <Esc>:m .-2<CR>==gi
    vnoremap <A-j> :m '>+1<CR>gv=gv
    vnoremap <A-k> :m '<-2<CR>gv=gv
endif

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

augroup GroupCleanSpaces
    autocmd!
    autocmd BufWritePre *.c,*cpp,*.h,*.txt,*.js,*.py,*.wiki,*.sh,*.coffee,*.ts,*.json,*.html :call CleanExtraSpaces()
augroup END


" }}}

