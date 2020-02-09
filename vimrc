" Minimal .vimrc for VIM v8

" Had some slow startup issues with nvim that I suspected had
" something to do with macOS Catalina. Step 1:
" nvim --cmd 'profile start profile.txt' --cmd 'profile func *'
" Bottom of file shows the top 10 slowest functions. Found
" a call to xsel, which is the X11 clipboard.
" https://stackoverflow.com/questions/47822357/how-to-use-x11-forwarding-to-copy-from-vim-to-local-machine
" lead me to reset the X11 clipboard in XQuartz preferences: fixed!

set encoding=utf-8

syntax on						" turn on synax coloring
filetype plugin indent on		" enable built-in identation

"colorscheme desert				" a reasonable default

let mapleader = ","
nnoremap <Leader>a :echo "Hey there"<CR>

inoremap jk <Esc>

set nowrap						" don't wrap long lines (>80 is ok)
set smartindent					" indent based on the file extension
set autoindent					" indent based on the previous line

set nobackup
set showmatch

set formatoptions+=j " Delete comment character when joining commented lines
set autoread            " auto reload file if changed outside of vim

set listchars=eol:¶,trail:•,tab:▸\         " whitespace characters
set listchars=eol:¬,tab:▸\.,trail:▫,nbsp:_,extends:»,precedes:«
set scrolloff=999                          " center cursor position vertically
set showbreak=↪
set showmatch

set hlsearch					" when searching with "/", highlight the term
nnoremap <leader>/ :set hlsearch! hlsearch? <CR>
hi Search ctermbg=LightBlue ctermfg=Black

set autoindent
set nobackup

set modeline
set noerrorbells                " No beeping!
set visualbell                  " No flashing either.
set nostartofline               " Searches leave cursor on same column
set ignorecase                  " Case-insensitive searching.
set laststatus=2				" 2 lines of status on the bottom
set ruler
set wildmenu

set number                      " Show line numbers.
set shortmess=atIF               " stifle the long interrupt prompts
set showmode                    " Display the mode you're in.
set smartcase                   " But case-sensitive if has caps
set scrolloff=3                 " Show 3 lines around cursor (more context)
set noshowmode                  " hide the default mode text (e.g. -- INSERT --)

set viminfo^=!
set sessionoptions-=options


" Q for formatting paragraph or selection
vnoremap Q gq
nnoremap Q gqap

" Select current line, excluding indents (great for copying to clipboard)
nnoremap vv ^vg_

" Disable K from looking stuff up
noremap K <Esc>

" Sane navigation for wrapped lines
nnoremap j gj
nnoremap k gk

" For Mac keyboards without ESC, just type jk
inoremap jk <Esc>
"
" for consistency with other cap commands (D, C)
nnoremap Y y$

" toggles
nnoremap <leader>ts :set list!<CR>
nnoremap <leader>ti :set list!<CR>
nnoremap <leader>tw :set invwrap<CR>:set wrap?<CR>
nnoremap <leader>tn :set invnumber<CR>
nnoremap <leader>tc :set cursorcolumn!<CR>
nnoremap <leader>tl :set cursorline!<CR>

" Change tabs to spaces, or the other way around. Good for Python!
nmap <leader>1 :set et<cr>:retab<cr>
nmap <leader>2 :set noet<cr>:retab!<cr>

" Indent / outdent consistent
vnoremap > >gv
vnoremap < <gv
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" tab jumps between windows
nnoremap <S-Tab> :tabn<CR>
nnoremap <Tab> <C-w><C-w>

" Disble macros
nnoremap <silent> q <space>

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

" Trim trailing spaces
function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction
nnoremap <leader>$ :silent call TrimWhiteSpace()<CR>


" vim:set ft=vim et sw=2:

