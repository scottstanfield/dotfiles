vim9s

# new comments
# def for functions
# var for variables 
# no backslash
# no call
# no let
# no eval

syntax on						" for colors
set encoding=utf-8
filetype indent on
filetype plugin on
filetype indent on
g:mapleader = ","

set autoindent
set nobackup

set modeline
set noerrorbells                # No beeping!
set visualbell                  # No flashing either.
set nostartofline               # Searches leave cursor on same column
set ignorecase                  # Case-insensitive searching.
set laststatus=2		# 2 lines of status on the bottom

set number                      # Show line numbers.
set shortmess=atIF              # stifle the long interrupt prompts
set showmode                    # Display the mode you're in.
set smartcase                   # But case-sensitive if has caps
set scrolloff=3                 # Show 3 lines around cursor (more context)
set noshowmode                  # hide the default mode text (e.g. -- INSERT --)

# Q for formatting paragraph or selection
vnoremap Q gq					
nnoremap Q gqap

# Select current line, excluding indents (great for copying to clipboard)
nnoremap vv ^vg_

# Disable K from looking stuff up
noremap K <Esc>

# Sane navigation for wrapped lines
nnoremap j gj
nnoremap k gk

# For keyboards without ESC, just type jk
inoremap jk <Esc>						   

set listchars=eol:¶,trail:•,tab:▸\         # whitespace characters
set scrolloff=999                          # center cursor position vertically
set showbreak=¬				   # for lines that wrap

set hlsearch
nnoremap <leader>/ :set hlsearch! hlsearch? <CR>
nnoremap / :set hlsearch<cr>/
hi Search ctermbg=LightBlue ctermfg=Black

# toggles
nnoremap <silent> <leader>tw :set invwrap<CR>:set wrap?<CR>
nnoremap <leader>i :set list!<CR>

set listchars=eol:¬,tab:▸\.,trail:▫,nbsp:_,extends:»,precedes:«
nmap <silent> <leader>tn :set invnumber<CR>

nnoremap <leader>c :set cursorcolumn!<CR>
nnoremap <leader>l :set cursorline!<CR>

# Change tabs to spaces, or the other way around. Good for Python!
nmap <leader>1 :set et<cr>:retab<cr>    
nmap <leader>2 :set noet<cr>:retab!<cr>

# Indent / outdent consistent
vnoremap > >gv
vnoremap < <gv
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

# tab jumps between windows
nnoremap <S-Tab> :tabn<CR>
nnoremap <Tab> <C-w><C-w>

nnoremap <silent> q <space>

plug#begin()
Plug 'junegunn/vim-easy-align'
Plug 'jalvesaq/Nvim-R'
plug#end()


g:R_assign = 0
g:R_args = ['--no-save', '--quiet']
g:R_tmpdir = '~$USER/R/tmp'
g:R_source_args = 'print.eval=F'

map <silent> <Space> :call SendLineToR("stay")<CR><Esc><Home><Down>
vmap <silent> <Space> <Plug>RSendSelection<Esc><Esc>
