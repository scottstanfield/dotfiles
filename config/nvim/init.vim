" move a visual block around
" use arrow keys or control-movement keys to resize windows
" change line highlight color

let mapleader = ","             " Our free key to prefix custom commands
let localleader = "\\"
set hidden                      " switch buffers w/o saving

set clipboard+=unnamedplus

" Map CMD-S to save files (iTerm2 passes it along as an anchor)
nnoremap <silent> ⚓ :w<CR>
inoremap <silent> ⚓ <ESC>:w<CR>a

set encoding=utf-8
set fileencoding=utf-8

" Move visual blocks up/down: it's magic
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Long lines get wrapped with this cool symbol
let &showbreak = '↳ '
set breakindent
set breakindentopt=sbr

" mimic emacs like line-editing in insert-mode
ino <C-A> <Home>
ino <C-E> <End>
ino <C-F> <Right>
ino <C-B> <Left>
ino <C-D> <Del>
ino <C-K> <Esc>lDa
ino <C-U> <Esc>d0xi
ino <C-Y> <Esc>Pa

ino <C-X><C-S> <Esc>:w<CR>a



" Ctrl-s to save current file (in normal and insert mode)
imap <c-s> <Esc>:w<CR>a
nmap <c-s> :w<CR>


" Vertical Split
" lighten color of vertical split and remove | bar
" https://stackoverflow.com/questions/9001337/vim-split-bar-styling
highlight VertSplit ctermfg=grey
set fillchars+=vert:\ 

" Toggle the visibility of the bar by changing the color
" Good for screenshots!
let g:bar = 0
function! ToggleSplit()
	if g:bar
		highlight VertSplit ctermfg=grey
		let g:bar=0
	else
		highlight VertSplit ctermfg=white
		let g:bar=1
	endif
endfunction
command! ToggleSp call ToggleSplit()
"noremap <leader>tv :ToggleSp<CR>
noremap <leader>tv :call ToggleSplit()<CR>

" make :terminal cursor red 
highlight TermCursor ctermfg=red        

" Make / searches stand out in magenta
highlight Search term=bold ctermbg=LightMagenta guibg=LightMagenta

" Hide the Magenta with ,/
nnoremap <silent> <leader>/ :set hlsearch! hlsearch?<CR>

" Highlight current line and column
nnoremap <leader>c :set cursorcolumn!<CR>
nnoremap <leader>l :set cursorline!<CR>
hi CursorLine ctermbg=7 cterm=none

" Colors (solarized) g
    " let g:solarized_contrast="high"     
    " let g:solarized_visibility="high"
    " call togglebg#map("<leader>x")          " ,x toggles dark/light

    " let profile = $ITERM_PROFILE
    " if profile ==? 'solarized-dark'
    "     set background=dark                 " light | dark
    "     hi colorcolumn ctermbg=darkgrey
    " else
    "     set background=light
    "     hi colorcolumn ctermbg=lightgrey
    " endif
    " colorscheme solarized
    " "  Remove next line comment to force dark color scheme.
    " "  Usually it's picked because iTerm2 will pass it in.
    " " setenv ITERM_PROFILE solarized-dark
" 

"""""""""""""""""
" TABS AND SPACES
"""""""""""""""""
set nosmartindent       " explicitly turn off. C-style doesn't work with R comments #
set nowrap              " do not wrap lines please
set tabstop=4
set softtabstop=4
set shiftwidth=4        " no clue what this does
set shiftround          " if spaces, TAB maps to right spot

" Change tabs to spaces, or the other way around. Good for Python!
nmap <leader>1 :set et<cr>:retab<cr>    
nmap <leader>2 :set noet<cr>:retab!<cr>

" General
set nobackup                    " don't let vim backup files
set noswapfile
set nowritebackup               " And again.
set autochdir                   " always switch to current dir
set wildmode=list:longest       " Complete files like a shell.
set modeline
set noerrorbells                " No beeping!
set visualbell                  " No flashing either.
set wildignore+=*.jpg,*.gif,*.png,*.git,*.gem,*.zip,*.tar.gz,node_modules

"""""""""""
" UI CONFIG
"""""""""""
let loaded_matchparen = 1       " Just use % instead of auto paren matching
" set colorcolumn=80            " vertical line at 80 cols
set nostartofline               " Searches leave cursor on same column
set ignorecase                  " Case-insensitive searching.
set lazyredraw                  " No redraw during macro execution
set number                      " Show line numbers.
set shortmess=atIF               " stifle the long interrupt prompts
set showmode                    " Display the mode you're in.
set smartcase                   " But case-sensitive if has caps
set scrolloff=3                 " Show 3 lines around cursor (more context)
set noshowmode                  " hide the default mode text (e.g. -- INSERT --)
set title                       " Set the terminal's title

" Open new split panes to the right and bottom, which feels more natural
set splitbelow
set splitright

" #-----------------------------------------------------------------------
" # <leader>q will put a surround a line with comment blocks like this ^ v
" #-----------------------------------------------------------------------
nnoremap <leader>q <Esc>yyp<Esc>Vr-r#<Esc>yykPj


nnoremap <silent> <S-Up> :wincmd k<CR>
nnoremap <silent> <S-Down> :wincmd j<CR>
nnoremap <silent> <S-Left> :wincmd h<CR>
nnoremap <silent> <S-Right> :wincmd l<CR>

" keys to quickly resize window/pane splits
nmap + <C-w>5+
nmap - <C-w>5-
nmap < <C-w>5>
nmap > <C-w>5<

" move easily b/w panes with TAB
nnoremap <Tab> <C-w><C-w>



" Make it easier to (make it easier to (make it easier to (edit text)))
nnoremap <leader>vi :split $MYVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>

" Two quick jk exits insert mode (odd, I know)
inoremap jk <Esc>l

" Q for formatting paragraph or selection
vnoremap Q gq
nnoremap Q gqap

" Sane navigation for wrapped lines
nnoremap j gj
nnoremap k gk

" Use capital H/L for first/last non-whitespace character on line
noremap H ^
noremap L g_

" Select current line, excluding indents (great for copying to clipboard)
nnoremap vv ^vg_

" Disable K from looking stuff up
noremap K <Esc>

" ideas taken from Janus
" toggle line wrapping modes
nnoremap <silent> <leader>tw :set invwrap<CR>:set wrap?<CR>

:cnoremap Wq wq

" Open current Markdown (*.md) file in OS X "Marked" and force redraw
nnoremap <leader>m :silent !open -a "Marked 2.app" '%:p'<cr> :redraw!<cr>

"    nnoremap <leader>r gq}               " *r*eformat current paragraph

" Abbreviations From http://vimcasts.org/episodes/show-invisibles/
ab [heart] ❤
ab [cmd] ⌘
ab [shift] ⇧
ab [option] ⌥
ab [ctrl] ⌃
ab [tab] ⇥
ab [section] §
ab [lozenge] ◊
ab [interpunct] ·
ab [reference] ※
ab [ellipse] …     
ab [bar] ―
ab [left] ←
ab [right] →
ab [pi] π
ab [shrug]  ¯\_(ツ)_/¯
ab [yhat] ŷ

" Toggle invisible whiteSpace ¬ ¶
nnoremap <leader>i :set list!<CR>
set listchars=eol:¬,tab:▸\.,trail:▫,nbsp:_,extends:»,precedes:«

" Capital Y copies to the EOL
nnoremap <S-y> y$

" Page-up/down with Control harmonizes with vim keys
nmap <C-j> <C-d>
nmap <C-k> <C-u>
vmap <C-j> <C-d>
vmap <C-k> <C-u>

" not sure what this does
nnoremap <leader>b <C-w>l

" Flip between last two files
nnoremap <leader><leader> <c-^>
nnoremap `` <c-^>

" Indent and outdent now > and < keep the visual selection
vnoremap > >gv
vnoremap < <gv
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Make Control-T uppercase the current word 
inoremap <C-t> <ESC>bgUWea

" Add the . command to visual mode
vnoremap . :norm.<CR>

" Tabbed Windows g
nnoremap <S-Tab> :tabn<CR>
 

"""""""""
" PLUGINS
"""""""""
" https://github.com/junegunn/vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')

	Plug 'itchyny/lightline.vim'

	Plug 'junegunn/rainbow_parentheses.vim'
	let g:rainbow#pairs = [['(', ')'], ['[', ']']]

    Plug 'kassio/neoterm'
    Plug 'junegunn/goyo.vim'		
	let g:goyo_width = 100
	nmap <leader>g :silent Goyo<CR>

	Plug 'regedarek/ZoomWin'

    Plug 'junegunn/vim-easy-align',     { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)
    let g:easy_align_delimiters = { ';': {'pattern': ':'}, 'a': {'pattern': '<-'}, '<': {'pattern': '<-'}, ':': {'pattern': ':='}}

    " Python
    "   Plug 'neomake/neomake'
    "   let g:neomake_python_enabled_makers = ['flake8', 'pep8', 'vulture']
    "   let g:neomake_python_flake8_maker = { 'args': ['--ignore=E302,E501'], }
    "   autocmd! BufWritePost * Neomake
    "   
    "   R linter with neomake!
    "   https://github.com/neomake/neomake/pull/646/files
    "
    

    " For R language
    Plug 'jalvesaq/Nvim-r',   { 'for': 'r' }
    Plug 'jalvesaq/colorout', { 'for': 'r' }
    vmap <silent> <Space> <Plug>RSendSelection<Esc><Esc>
    nmap <silent> <Space> :call SendLineToR("stay")<CR><Esc><Home><Down>
    let R_assign = 0
    let R_args = ['--no-save', '--quiet']
    let R_hi_fun = 0
    let R_tmpdir = '~scott/R/tmp'
    let R_source_args = 'print.eval=F'
    " I needed to run `brew link --force readline` in order to get gcc5
    " to compile nvimcom (which updates automatically when you invoke nvim-r)

    " maltese
    nmap <silent> ✠ :call SendLineToR("stay")<CR><Esc><Home><Down>
    imap <silent> ✠ <Esc>:call SendLineToR("stay")<CR><Esc>A
    vmap ✠ <Plug>RSendSelection<Esc><Esc>
    nmap <leader>fe :call SendFunctionToR("echo", "stay")<CR><Esc>

    Plug 'kshenoy/vim-signature'                    " show marks in margin
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'                     " smarter commenting with gc
    Plug 'altercation/vim-colors-solarized'         " not sure what this is doing
    Plug 'matchit.zip'                              " smarter % key matching
    "Plug 'airblade/vim-gitgutter'             " shows git diff marks in the gutter

call plug#end()


" Wrapping autocmd in a group per http://bit.ly/15wKRrM
augroup my_au
    autocmd!
    au FileType python setlocal expandtab ts=2 sw=2 sts=2
    au FileType ruby setlocal ts=2 sw=2 sts=2
    au FileType make setlocal noexpandtab

    " place this after plugins have loaded
    " Set textwidth like a boss http://blog.ezyang.com/2010/03/vim-textwidth/
    au FileType text,markdown setlocal textwidth=72 colorcolumn=80
    au FileType stylus,jade set tabstop=2|set softtabstop=2|set shiftwidth=2|set expandtab
    au FileType javascript set ts=4|set shiftwidth=4|set expandtab
    au FileType coffee setlocal ts=2 shiftwidth=2 shiftwidth=2 expandtab
    au Filetype drake set ts=2 softtabstop=2 shiftwidth=2 expandtab
    au FileType r set ts=2 softtabstop=2 shiftwidth=2 expandtab

    au BufEnter *.tsv set tabstop=14 softtabstop=14 shiftwidth=14 noexpandtab

    " PEP8 has defined the proper indentation for Python
    au BufNewFile,BufRead *.py set ts=4 sts=4 sw=4 tw=79 expandtab fileformat=unix

    " Turn off line wrapping when working on HTML files
    au BufNewFile,BufRead *.html setlocal nowrap
augroup END

augroup rainbow_paren
	autocmd!
	autocmd FileType r RainbowParentheses
augroup END


" Remember the cursor position for every file
function! PositionCursorFromViminfo()
    if !(bufname("%") =~ '\(COMMIT_EDITMSG\)') && line("'\"") > 1 && line("'\"") <= line("$")
        exe "normal! g`\""
    endif
endfunction
au BufReadPost * call PositionCursorFromViminfo()


" Trim trailing characters when files are saved
function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction
autocmd BufWritePre *.py :call TrimWhiteSpace()
autocmd BufWritePre *.r :call TrimWhiteSpace()
nnoremap <leader>$ :silent call TrimWhiteSpace()<CR>

if has('persistent_undo')
    set undofile "Enable persistent undo

    " Set persistent undo directory
    set undodir=~/.vim/undo
    if !isdirectory(expand(&undodir))
        call mkdir(expand(&undodir), 'p')
    endif
endif

""""""""""""""""""""""""""""""""""""
" Word processiong mode for Markdown
""""""""""""""""""""""""""""""""""""

" Go into WordProcessorMode when typing Markdown paragraphs: <leader>0
" http://www.drbunsen.org/writing-in-vim/
func! WordProcessorMode()
    setlocal formatoptions=1t
    setlocal noexpandtab
    map j gj
    map k gk
    setlocal spell spelllang=en_us
    set complete+=s
    set formatprg=par
    setlocal wrap
    setlocal linebreak
endfu

nnoremap <leader>0 :silent call WordProcessorMode()
" Run "formd" command on buffer to fix Markdown hyperlinks
" This script assumes formd is in your path at:
" ~/bin/formd/formd
" http://drbunsen.github.com/formd/
 
function! Formd(option)
    :let save_view = winsaveview()
    :let flag = a:option
    :if flag == "-r"
        :%! ~/bin/formd -r
    :elseif flag == "-i"
        :%! ~/bin/formd -i
    :else
        :%! ~/bin/formd -f
    :endif
    :call winrestview(save_view)
endfunction
 
" These are too close to <leader>f for R so remove for now
" nmap <leader>fr :call Formd("-r")<CR>
" nmap <leader>fi :call Formd("-i")<CR>
" nmap <leader>f :call Formd("-f")<CR>
"
"""""""""""""""""""""""""""""""""""""""""""""""

" Set cursor to underscore in insertmode 

"if $TERM_PROGRAM =~ "iTerm.app"
    let &t_SI = "\<Esc>]50;CursorShape=2\x7" " 1 = vertical bar; 2 = underscore
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
"endif

" Easily get out of Terminal mode
tnoremap <Esc> <C-\><C-n>
tnoremap <Esc><Esc> <C-\><C-n><C-w>k

