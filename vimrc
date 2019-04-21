syntax on		" for colors
filetype indent on

let mapleader = ","
inoremap jk <Esc>
set autoindent
set nobackup
set showmatch

set listchars=eol:¶,trail:•,tab:▸\         " whitespace characters
set scrolloff=999                          " center cursor position vertically
set showbreak=¬\ 
set showmatch

set hlsearch
nnoremap <leader>/ :set hlsearch! hlsearch? <CR>
nnoremap / :set hlsearch<cr>/
hi Search ctermbg=LightBlue ctermfg=Black
