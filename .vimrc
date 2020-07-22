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
set number
set termguicolors
set cursorline
set clipboard=unnamedplus                        " Use system clipboard
set notimeout                                    " Leader timeout
set ttimeout
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

" Backups and undoing
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
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

" Spell checking
set spelllang=en_us
map <leader>ss :setlocal spell!<cr> " Pressing ,ss will toggle and untoggle spell checking
map <leader>sn ]s " Next error
map <leader>sp [s " Prev error
map <leader>sa zg " Add to dictionary
map <leader>s? z= " Show suggestions
inoremap <C-f> <c-g>u<Esc>[s1z=`]a<c-g>u " Correct last error

" Enable folding with the spacebar
nnoremap <space> za

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
" From the yank register
xnoremap p "0p
xnoremap P "0P

" Avoid garbled characters in Chinese language windows OS
" let $LANG='en'
" source $VIMRUNTIME/delmenu.vim
" source $VIMRUNTIME/menu.vim
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{

" Install vim plug with:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
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
" Plug 'fmoralesc/vim-pad', { 'branch': 'devel' }
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
Plug 'nelstrom/vim-visual-star-search'  " Use * to search for text selected in visual mode
Plug 'machakann/vim-highlightedyank'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'tmhedberg/SimpylFold'
Plug 'rhysd/git-messenger.vim'
Plug 'kshenoy/vim-signature'
Plug 'mbbill/undotree'
" Plug 'chuling/equinusocio-material.vim'
Plug 'flazz/vim-colorschemes'
Plug 'ryanoasis/vim-devicons' " Always load the vim-devicons as the very last one.

" Initialize plugin system
call plug#end()

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
" Install:
"     cd ~/.vim/bundle/YouCompleteMe && python3 install.py --all
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
nnoremap <silent> <Leader>ga :Ag <C-R><C-W><CR>

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

let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" crc 	coerce to camelCase
" crm 	coerce to MixedCase
" crs (also cr_) 	coerce to snake_case
" cru 	coerce to SNAKE_UPPERCASE
" cr- 	coerce to dash-case

let g:highlightedyank_highlight_duration = 200

" let g:pad#dir = '~/l/notes'
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
" => Nvim Specific
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{
if has('nvim-0.1')
  " Transparent floating windows
  set pumblend=15
  highlight PmenuSel blend=0
endif

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
    colorscheme vim-material
    " colorscheme equinusocio_material
catch
endtry

" set true colors
if has("termguicolors")
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum
    set termguicolors
endif


" Set git gutter colors (after config. colors so they don't get overwritten
highlight GitGutterAdd    guifg=#C3E88D
highlight GitGutterChange guifg=#FFCB6B
highlight GitGutterDelete guifg=#FF5370
highlight clear SignColumn
highlight Search guibg=#ffcb6b guifg=#444444 gui=NONE
highlight FoldColumn guifg=#e4e4e4
highlight ALEWarningSign guifg=#FFCB6B
highlight ALEErrorSign guifg=#FF5370
highlight Comment guifg=#49656F
highlight TermCursorNC ctermfg=15 guifg=#fdf6e3 guibg=#93a1a1
highlight HighlightedyankRegion cterm=reverse gui=reverse
highlight Normal guibg=NONE ctermbg=NONE  " Transparent background

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

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

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

augroup GroupCleanSpaces
    autocmd!
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee,*.ts,*.json,*.html :call CleanExtraSpaces()
augroup END

" Auto Formatting
command! PrettyJSON4 %!python -c "import json, sys, collections; print(json.dumps(json.load(sys.stdin, object_pairs_hook=collections.OrderedDict), indent=4))"
command! PrettyJSON2 %!python -c "import json, sys, collections; print(json.dumps(json.load(sys.stdin, object_pairs_hook=collections.OrderedDict), indent=2))"
command! PrettyJSON4S %!python -c "import json, sys, collections; print(json.dumps(json.load(sys.stdin, object_pairs_hook=collections.OrderedDict), indent=4, sort_keys=True))"
command! PrettyJSON2S %!python -c "import json, sys, collections; print(json.dumps(json.load(sys.stdin, object_pairs_hook=collections.OrderedDict), indent=2, sort_keys=True))"

" }}}
