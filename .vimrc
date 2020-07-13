" http://amix.dk/blog/post/19691#The-ultimate-Vim-configuration-on-Github

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{
set nocompatible

" Search down into subfolders, with auto-complete
set path+=**

" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on
filetype on

" Enable mouse support (resize splits, select in visual mode, etc)
set mouse=a

" Set to auto read when a file is changed from the outside
set autoread
set number
set termguicolors
set cursorline

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Double leader is Esc
" imap <Leader><Leader> <ESC>

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
try
  command W w !sudo tee % > /dev/null
catch
endtry

" Use system clipboard
set clipboard=unnamedplus

" Leader timeout
set notimeout
set ttimeout

" Enable folding
set foldmethod=indent
set foldlevel=99
" Enable folding with the spacebar
nnoremap <space> za

" Non printable chars
set showbreak=↪\
set listchars=tab:»\ ,eol:¬,nbsp:␣,space:·,trail:•,extends:→,precedes:←
" set list

" Shortcut for vimrc and auto source on save.
map <leader>vimrc :tabe ~/.vimrc<cr>
augroup GroupSource
    autocmd!
    autocmd bufwritepost .vimrc source $MYVIMRC
augroup END

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

" Quit with uppercase Q, because sloppy
cnoreabbrev Q q

" Delete, not cut
" https://stackoverflow.com/a/11993928/575085
nnoremap d "_d
xnoremap d "_d
"xnoremap p "_dP

" Diff options
set diffopt+=vertical

" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{

" Install vim plug with:
"  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Python
Plug 'vim-python/python-syntax'
Plug 'davidhalter/jedi-vim'
Plug 'jeetsukumaran/vim-pythonsense'
" Typescript
Plug 'HerringtonDarkholme/yats.vim'
" Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
" XML/HTML
Plug 'alvan/vim-closetag' 
" Text Utils
Plug 'machakann/vim-sandwich'
Plug 'scrooloose/nerdcommenter'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'junegunn/vim-easy-align'
Plug 'plasticboy/vim-markdown'
" Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
" Search and complete
Plug 'tpope/vim-fugitive'
Plug 'Valloric/YouCompleteMe'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'dense-analysis/ale'
Plug 'tpope/vim-abolish'
" UI
Plug 'qpkorr/vim-bufkill'
Plug 'psliwka/vim-smoothie'
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" Plug 'jistr/vim-nerdtree-tabs'
" Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'tmhedberg/SimpylFold'
Plug 'rhysd/git-messenger.vim'
Plug 'kshenoy/vim-signature'
Plug 'mbbill/undotree'
Plug 'flazz/vim-colorschemes'
Plug 'ryanoasis/vim-devicons' " Always load the vim-devicons as the very last one.

" Initialize plugin system
call plug#end()

" Plugin Configuration

" Vim Abolish
" Usage: :Subvert/address{,es}/reference{,s}/g
"        :Subvert/blog{,s}/post{,s}/g
"        :Subvert/child{,ren}/adult{,s}/g
"        :Abolish {despa,sepe}rat{e,es,ed,ing,ely,ion,ions,or}  {despe,sepa}rat{}

" NerdCommenter
let g:NERDSpaceDelims = 1  " Add a space after the command markers

" Ignore files in NERDTree
let g:NERDTreeIgnore=['\.pyc$', '\~$']
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''

let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 0

 "Auto start NerdTree if vim is started with a directory.
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
" Close VIM if NT is the only window open
augroup GroupNerd
    autocmd!
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END
" Toggle NerdTree
map <C-N> :NERDTreeToggle<CR>

let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline#extensions#tabline#enabled = 1
" Use compact names for branches (2), disable with = 0
let g:airline#extensions#branch#format = 2
let g:airline_theme='powerlineish'
" Compact mode names
let g:airline_mode_map = {
    \ '__' : '--',
    \ 'n'  : 'N',
    \ 'i'  : 'I',
    \ 'R'  : 'R',
    \ 'c'  : 'C',
    \ 'v'  : 'V',
    \ 'V'  : 'V-L',
    \ '' : 'V-B',
    \ 's'  : 'S',
    \ 'S'  : 'S-L',
    \ '' : 'S-B',
    \ 't'  : 'T',
    \ }
let $FZF_DEFAULT_COMMAND='ag -l --nocolor --hidden -g ""'

" YCM:
"
" Install:
"     cd ~/.vim/bundle/YouCompleteMe
"     python3 install.py --all
"
" After changing any of these options, restart server with :YcmRestartServer

" Enabled in comments
let g:ycm_complete_in_comments = 1
" Preload completion with language keywords
let g:ycm_seed_identifiers_with_syntax = 1
" Get rid of the preview window
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
" This option controls the key mappings used to select the first completion string.
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>']
" This option controls the key mappings used to close the completion menu
let g:ycm_key_list_stop_completion = ['<C-y>']
" Invoke the completion menu for semantic completion
let g:ycm_key_invoke_completion = '<C-Space>'
" This option controls the key mapping used to show the full diagnostic text when the user's cursor is on the line with the diagnostic.
let g:ycm_key_detailed_diagnostics = '<leader>ycmdiag'
" Args to pass to ycm_global_extra_conf.py
let cwd = getcwd()
let g:ycm_extra_conf_vim_data = []
" Global configuraton
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_global_extra_conf.py'  " Global configuration file

"" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<leader><tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsSnippetDirectories=['UltiSnips', $HOME.'/.vim/UltiSnips']
let g:ultisnips_python_style='google'

" ALE
let g:ale_fixers = {'python': ['black', 'isort']}
let g:ale_linters = {'python': ['mypy',  'flake8', 'pydocstyle', 'mypy']}
let g:ale_virtualenv_dir_names = ['.venv3', '.venv36', '.venv37', '.env', '.venv', 'env', 've-py3', 've', 'virtualenv', 'venv']
let g:ale_python_black_options = '--line-length 80 --target-version py36'
" let g:ale_fix_on_save = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_python_black_change_directory = 1
let g:ale_change_sign_column_color = 1
let g:ale_sign_error = ''
let g:ale_sign_warning = ''

" Vim Easy Align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Vim Instant Markdown
" Start with :InstantMarkdownPreview, stop with: InstantMarkdownStop
"let g:instant_markdown_autostart = 0

" Vim Sandwich
" Usage: sa{motion/textobject}{addition} -> Add a surrounding
"        sd{deletion} -> Delete surrounding
"        sr{deletion}{addition} -> replace surrounding

" Fzf
" Commands: 
"     :Files 
"     :Buffers 
"     :Colors 
"     :Ag
"     :Lines
"     :Snippets
"     :Commits
"     :Commands
" CTRL-T -> Open in tab 
" CTRL-X -> Open in split
" CTRL-V -> Open in vertical split
map <C-P> :Files<CR>
map <Leader>a :Ag<CR>
noremap <silent> <leader>ga :Ag <C-R><C-W><CR>

" Vim Gitgutter
let g:gitgutter_sign_added = ''
let g:gitgutter_sign_modified = ''
let g:gitgutter_sign_removed = ''
let g:gitgutter_sign_removed_first_line = ''
let g:gitgutter_sign_modified_removed = ''

" Vim Close tag
" These are the file extensions where this plugin is enabled.
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'
" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'
" These are the file types where this plugin is enabled.
let g:closetag_filetypes = 'html,xhtml,phtml'
" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filetypes = 'xhtml,jsx'
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
let g:closetag_emptyTags_caseSensitive = 1
" Disables auto-close if not in a "valid" region (based on filetype)
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }
" Shortcut for closing tags, default is '>'
let g:closetag_shortcut = '>'
" Add > at current position without closing the current tag, default is ''
let g:closetag_close_shortcut = '<leader>>'

" Vim bufkill
" Usage: :BD -> delete buffer
"        :BW -> wipe a file from the buffer
"        :BUN -> Unload buffer
"        :BA -> Alternate buffers
"        :BB :BF -> Move in buffers

" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Python
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{

" Vim jedi
"  Completion <C-Space>
"  Goto assignments <leader>g (typical goto function)
"  Goto definitions <leader>d (follow identifier as far as possible, includes imports and statements)
"  Show Documentation/Pydoc K (shows a popup with assignments)
"  Renaming <leader>r
"  Usages <leader>n (shows all the usages of a name)
"  Open module, e.g. :Pyimport os (opens the os module)

" Vim Pythonsense
" class OneRing(object):             -----------------------------+
"                                   --------------------+        |
"    def __init__(self):                                |        |
"        print("One ring to ...")                       |        |
"                                                       |        |
"    def rule_them_all(self):                           |        |
"        self.find_them()                               |        |
"                                                       |        |
"    def find_them(self):           ------------+       |        |
"        a = [3, 7, 9, 1]           ----+       |       |        |
"        self.bring_them(a)             |- `if` |- `af` |- `ic`  | - `ac`
"        self.bind_them("darkness") ----+       |       |        |
"                                   ------------+       |        |
"    def bring_them_all(self, a):                       |        |
"        self.bind_them(a, '#000')                      |        |
"                                                       |        |
"    def bind_them(self, a, c):                         |        |
"        print("shadows lie.")      --------------------+        |
"                                   -----------------------------+
"
"
" ]] : Move (forward) to the beginning of the next Python class.
" ][ : Move (forward) to the end of the current Python class.
" [[ : Move (backward) to beginning of the current Python class (or beginning
"      of the previous Python class if not currently in a class or already at
"      the beginning of a class).
" [] : Move (backward) to end of the previous Python class.
" ]m : Move (forward) to the beginning of the next Python method or function.
" ]M : Move (forward) to the end of the current Python method or function.
" [m : Move (backward) to the beginning of the current Python method or function
"      (or to the beginning of the previous method or function if not currently in
"      a method/function or already at the beginning of a method/function).
" [M : Move (backward) to the end of the previous Python method or function.
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Properly disable sound on errors on MacVim
"if has("gui_macvim")
    "autocmd GUIEnter * set vb t_vb=
"endif


" Add a bit extra margin to the left
set foldcolumn=1

" Transparent floating windows
if has('nvim-0.1')
  set pumblend=15
  hi PmenuSel blend=0
endif
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{
" Enable syntax highlighting
syntax enable

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

try
    colorscheme vim-material
catch
endtry

set background=dark

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" set true colors
if has("termguicolors")
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum
    set termguicolors
endif

" Transparent background
hi Normal guibg=NONE ctermbg=NONE

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Set git gutter colors (after config. colors so they don't get overwritten
highlight GitGutterAdd    guifg=#C3E88D
highlight GitGutterChange guifg=#FFCB6B
highlight GitGutterDelete guifg=#FF5370
highlight clear SignColumn
highlight Normal guibg=NONE ctermbg=NONE
highlight Search guibg=#ffcb6b guifg=#444444 gui=NONE
highlight FoldColumn guifg=#e4e4e4
highlight ALEWarningSign guifg=#FFCB6B
highlight ALEErrorSign guifg=#FF5370
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{
" Turn backup off, since most stuff is in SVN, git et.c anyway...
"set nobackup
"set nowb
"set noswapfile

set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Except for:
"augroup GroupTabsize
    "autocmd!
    "autocmd FileType *.ts,*.html,*.css,*.json setlocal shiftwidth=2 tabstop=2 softtabstop=2
"augroup END
"
" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" }}}

""""""""""""""""""""""""""""""
" => Visual mode related
"""""""""""""""""""""""""""""" {{{
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
"vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
"vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{
" Switch buffers
"nnoremap <F7> :bp<CR>
"nnoremap <F9> :bn<CR>

" Disable highlight when <leader><cr> is pressed
"map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
"map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
"map <leader>tn :tabnew<cr>
"map <leader>to :tabonly<cr>
"map <leader>tc :tabclose<cr>
"map <leader>tm :tabmove
"map <leader>t<leader> :tabnext

" Let 'tl' toggle between this and the last accessed tab
"let g:lasttab = 1
"nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
"au TabLeave * let g:lasttab = tabpagenr()


" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
"map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
"map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using Shift+[jk]
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

if has("autocmd")
    augroup GroupNerd
        autocmd!
        autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee,*.ts,*.json,*.html :call CleanExtraSpaces()
    augroup END
endif

" Auto Formatting
command! PrettyJSON4 %!python -c "import json, sys, collections; print(json.dumps(json.load(sys.stdin, object_pairs_hook=collections.OrderedDict), indent=4))"
command! PrettyJSON2 %!python -c "import json, sys, collections; print(json.dumps(json.load(sys.stdin, object_pairs_hook=collections.OrderedDict), indent=2))"
command! PrettyJSON4S %!python -c "import json, sys, collections; print(json.dumps(json.load(sys.stdin, object_pairs_hook=collections.OrderedDict), indent=4, sort_keys=True))"
command! PrettyJSON2S %!python -c "import json, sys, collections; print(json.dumps(json.load(sys.stdin, object_pairs_hook=collections.OrderedDict), indent=2, sort_keys=True))"

" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{
set spelllang=en_us
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
" Next error
map <leader>sn ]s
" Prev error
map <leader>sp [s
" Add to dictionary
map <leader>sa zg
" Show suggestions
map <leader>s? z=
" Correct last error
inoremap <C-f> <c-g>u<Esc>[s1z=`]a<c-g>u

" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{
" Remove the Windows ^M - when the encodings gets messed up
"noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
"map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
"map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
"map <leader>pp :setlocal paste!<cr>

" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{
" Returns true if paste mode is enabled
"function! HasPaste()
    "if &paste
        "return 'PASTE MODE  '
    "endif
    "return ''
"endfunction

"" Don't close window, when deleting a buffer
"command! Bclose call <SID>BufcloseCloseIt()
"function! <SID>BufcloseCloseIt()
   "let l:currentBufNum = bufnr("%")
   "let l:alternateBufNum = bufnr("#")

   "if buflisted(l:alternateBufNum)
     "buffer #
   "else
     "bnext
   "endif

   "if bufnr("%") == l:currentBufNum
     "new
   "endif

   "if buflisted(l:currentBufNum)
     "execute("bdelete! ".l:currentBufNum)
   "endif
"endfunction

"function! CmdLine(str)
    "exe "menu Foo.Bar :" . a:str
    "emenu Foo.Bar
    "unmenu Foo
"endfunction

"function! VisualSelection(direction, extra_filter) range
    "let l:saved_reg = @"
    "execute "normal! vgvy"

    "let l:pattern = escape(@", "\\/.*'$^~[]")
    "let l:pattern = substitute(l:pattern, "\n$", "", "")

    "if a:direction == 'gv'
        "call CmdLine("Ack '" . l:pattern . "' " )
    "elseif a:direction == 'replace'
        "call CmdLine("%s" . '/'. l:pattern . '/')
    "endif

    "let @/ = l:pattern
    "let @" = l:saved_reg
"endfunction

" }}}

" _vim:foldmethod=marker:foldlevel=0

