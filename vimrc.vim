scriptencoding utf-8
set encoding=utf-8

let mapleader = ","
syntax enable                    " Turn on Syntax highlighting

" auto indenting
set et
set sw=4                         " shift width is four
set softtabstop=4                " four here. 
set expandtab                    " all tabs are actually spaces
set smartindent                  " FOR NOW....


" ----------------------------------------------------------------------------
" UI
" ----------------------------------------------------------------------------
set noshowcmd                    " Don't display incomplete commands
set nolazyredraw                 " If we're going to redraw, lets not be lazy about it.
syntax sync minlines=1000        " Look for synchronization points 1000 lines before the current position in the file.
set number                       " show line numbers
set wildmenu                     " Turn on wild menu. Sounds fun.
set wildmode=longest:list,full   " make tab completion act like bash, but even better!
set ch=2                         " Command line height
set backspace=indent,eol,start   " Fixes a problem where I cannot delete text that is existing in the file
set whichwrap=b,s,h,l,<,>,[,]    " Wrap on other things
set report=0                     " Tell us about changes
set nostartofline                " don't jump to the start of a line when scrolling
set wildignore+=.git,.hg,.svn " Ignore version control repos
set wildignore+=*.pyc         " Ignore python compiled files
set wildignore+=*.class       " Ignore java compiled files
set wildignore+=*.swp         " Ignore vim backupskk

" ----------------------------------------------------------------------------
" Visual stuff
" ----------------------------------------------------------------------------
set background=dark              " We use a dark terminal so we can play nethack
set mat=5                        " show matching brackets for 1/10 of a second
set laststatus=2                 " always have a file status line at the bottom, even when theres only one file
set novisualbell                 " Stop flashing at me and trying to give me seizures.
set virtualedit=block            " Allow virtual edit in just block mode.

" ----------------------------------------------------------------------------
" Searching and replacing
" ---------------------------------------------------------------------------
set showmatch                    " brackets/brace matching
set incsearch                    " show me whats matching as I type my search
set hlsearch                     " Highlight search results
set ignorecase                   " Ignore case while searching
" prepend all searches with \v to get rid of vim's 'crazy default regex characters'
nnoremap / /\v

"short cuts for common split commands.
nnoremap <silent> ss :split .
nnoremap <silent> vv :vsplit .

" Cleanup functions
function! RemoveTrailingWhiteSpace()
    if !&binary && &filetype != 'diff'
        normal mz
        normal Hmy
        :%s/\s\+$//e
        normal yz<CR>
        normal `z
    endif
endfunction

noremap <leader>s :call RemoveTrailingWhiteSpace()<CR>

" ---------------------------------------------------------------------------
" Python Stuff
" ---------------------------------------------------------------------------
autocmd FileType python setl sw=4                    " For python, the shift width is four, yes four
autocmd FileType python set softtabstop=4            " For python, tabs are four spaces!
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class " Autoindent my new blocks in python
highlight SpellBad term=reverse ctermbg=1

map <leader>m oimport ipdb; ipdb.set_trace()

" ---------------------------------------------------------------------------
" Plugins
" ---------------------------------------------------------------------------
"  --------------------------------------------------------------------------
"  " CUSTOM AUTOCMDS
"  "
"  --------------------------------------------------------------------------
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

""""""""""""""
"Code Folding"
""""""""""""""
set foldlevel=999

autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR SCHEME
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme lucius

highlight OverLength      ctermbg=red
highlight ColorColumn     ctermbg=darkgray
highlight ExtraWhitespace ctermbg=red guibg=red
"

" Better diff colors
highlight DiffAdd    cterm=bold ctermfg=black ctermbg=darkgreen gui=bold guifg=black guibg=darkgreen
highlight DiffChange cterm=bold ctermfg=black ctermbg=darkblue
highlight DiffText   cterm=bold ctermfg=black ctermbg=lightgray
highlight DiffDelete cterm=bold ctermfg=black ctermbg=darkred

" Easier visual indent
vnoremap < <gv
vnoremap > >gv

" Cursor / visual settings
set cursorline         " Show a line for the cursor
set laststatus=2       " Always show status line
set showmode           " Show the current mode

" Backup/Undo settings
execute "set directory=" . g:vim_home_path . "/swap"
execute "set backupdir=" . g:vim_home_path . "/backup"
set backup
set writebackup


if exists('+colorcolumn')
  set colorcolumn=81
  execute "set undodir=" . g:vim_home_path . "/undo"
  set undofile
  set undoreload=10000
endif

" Show extra which space and over 80
match OverLength /\%80v.\+/
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"------------------------------------------------
"" Plugin settings
"------------------------------------------------

" SuperTab settings
let g:SuperTabDefaultCompletionType = "context"

" NerdTree settings
let g:nerdtree_tabs_open_on_console_startup = 1
"
" Synstastic settings
let g:syntastic_python_checkers=['pylint', 'flake8']
let g:syntastic_python_flake8_args='--config ~/.flake8'
let g:syntastic_python_pylint_args='--rcfile .pylintrc --msg-template="{path}:{line}: [{msg_id}] {msg}" -r n'

" Indent Guides
let g:indent_guides_guide_size = 1

let g:NERDTreeDirArrows=0

if has('python')
python << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
endif

" Line number settings
set relativenumber     " Start with relative numbers
set numberwidth=3      " Use 3 columns for numbers

" Gundo settings
let g:gundo_preview_bottom = 1
let g:gundo_right = 1
let g:gundo_help = 0
let g:gundo_width = 25
let g:gundo_preview_height = 10

" Treat all html as htmldjango
autocmd BufNewFile,BufRead *.html set filetype=htmldjango

" Command to write as root if forgot to open with sudo
cmap w!! %!sudo tee > /dev/null %

" Key bindings
noremap <silent><leader>/ :nohlsearch<Bar>:echo<CR>
nnoremap <F2> :call NumberToggle()<cr>
map <F3> :set wrap! wrap?<CR>
map <F4> :set hlsearch! hlsearch?<CR>
map <F5> :edit <CR>
map <F6> :edit! <CR>
nmap <F12> :NERDTreeTabsToggle <CR>
nmap <F7> :GundoToggle <CR>
map <F8> :set expandtab! expandtab?<CR>
map <F9> :set paste! paste?<CR>
map <F10> :set cursorline! cursorline?<CR>
map <F11> :set spell! spell?<CR>
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>


"-------------------
"VirtualEnv Settings
"-------------------
" Add the virtualenv's site-packages to vim path
if has('python')
python << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
endif
