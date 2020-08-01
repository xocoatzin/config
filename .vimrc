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
set signcolumn=yes                               " Draw always

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
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{

" Install vim plug with:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin('~/.vim/plugged')

" Typescript
" Plug 'HerringtonDarkholme/yats.vim'
" Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
" Text Utils
Plug 'machakann/vim-sandwich'
Plug 'scrooloose/nerdcommenter'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'junegunn/vim-easy-align'
" Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
" Search and complete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-abolish'
" UI
Plug 'qpkorr/vim-bufkill'
Plug 'psliwka/vim-smoothie'
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'nelstrom/vim-visual-star-search'  " Use * to search for text selected in visual mode
Plug 'machakann/vim-highlightedyank'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tmhedberg/SimpylFold'
Plug 'kshenoy/vim-signature'
Plug 'mbbill/undotree'
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
" let $FZF_DEFAULT_OPTS='--reverse'
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }

" UltiSnips
" TODO: Disable these 3
let g:UltiSnipsExpandTrigger = "<leader>_xx"
let g:UltiSnipsJumpForwardTrigger = "<leader>_xx"
let g:UltiSnipsJumpBackwardTrigger = "<leader>_xx"

let g:UltiSnipsSnippetDirectories=['UltiSnips', $HOME.'/.vim/UltiSnips']
let g:ultisnips_python_style='google'

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
"     :Files      :Buffers        :Colors     :Ag
"     :Lines      :Snippets       :Commits    :Commands
" CTRL-T -> Open in tab 
" CTRL-X -> Open in split
" CTRL-V -> Open in vertical split
map <C-P> :Files<CR>
map <Leader>ag :Ag<CR>
nnoremap <silent> <Leader>ga :Ag <C-R><C-W><CR>

" Vim bufkill
" Usage: :BD -> delete buffer
"        :BW -> wipe a file from the buffer
"        :BUN -> Unload buffer
"        :BA -> Alternate buffers
"        :BB :BF -> Move in buffers


" crc 	coerce to camelCase
" crm 	coerce to MixedCase
" crs (also cr_) 	coerce to snake_case
" cru 	coerce to SNAKE_UPPERCASE
" cr- 	coerce to dash-case

let g:highlightedyank_highlight_duration = 200

" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => COC
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" {{{
" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
augroup mygroup_1
  autocmd!
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup end

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  :call CocAction('format')<CR>

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

nnoremap <silent> <leader>h :call CocActionAsync('doHover')<cr>

" Multiple cursors
nmap <expr> <silent> <leader>d <SID>select_current_word()
function! s:select_current_word()
  if !get(g:, 'coc_cursors_activated', 0)
    return "\<Plug>(coc-cursors-word)"
  endif
  return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
endfunc

"
" Coc-snippets
"
let g:coc_snippet_next = '<leader>j'
let g:coc_snippet_prev = '<leader>k'

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
let g:gruvbox_invert_signs = 1
highlight clear SignColumn
highlight FoldColumn guifg=#e4e4e4
highlight HighlightedyankRegion cterm=reverse gui=reverse
highlight Normal guibg=NONE ctermbg=NONE  " Transparent background
highlight link CocErrorSign GruvboxRed
highlight link CocWarningSign GruvboxYellow
highlight link CocInfoSign GruvboxBlue
highlight link CocHintSign GruvboxGreen

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
