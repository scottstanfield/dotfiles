" move a visual block around
" use arrow keys or control-movement keys to resize windows
" change line highlight color
scriptencoding utf-8

let mapleader = ","             " Our free key to prefix custom commands
let localleader = "\\"
set hidden                      " switch buffers w/o saving

"set clipboard^=unnamed
set clipboard+=unnamedplus
"set clipboard^=unnamed

" Folding for R files
"let r_syntax_folding = 1
" set nofoldenable              " start with all folds open
"nnoremap <Enter> za


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
" control-K is for diagraphs
" ino <C-K> <Esc>lDa
ino <C-U> <Esc>d0xi
ino <C-Y> <Esc>Pa

ino <C-X><C-S> <Esc>:w<CR>a

" I rarely use macros, but I accidentally hit q all the time
" map q <Nop>

" Ctrl-s to save current file (in normal and insert mode)
imap <c-s> <Esc>:w<CR>a
nmap <c-s> :w<CR>


" Vertical Split
" lighten color of vertical split and remove | bar
" https://stackoverflow.com/questions/9001337/vim-split-bar-styling
highlight VertSplit ctermfg=grey
set fillchars+=vert:\ 

" Toggle the visibility of the bar by changing the color (for screenshots)
let g:toggle_split = 0
function! ToggleSplit()
    if g:toggle_split
        highlight VertSplit ctermfg=grey
        let g:toggle_split=0
    else
        highlight VertSplit ctermfg=white
        let g:toggle_split=1
    endif
endfunction
noremap <leader>ts :call ToggleSplit()<CR>

" make :terminal cursor red 
highlight TermCursor ctermfg=red        

" Hide the Magenta with ,/
nnoremap <silent> <leader>/ :set hlsearch! hlsearch?<CR>

" Highlight current line and column
nnoremap <leader>c :set cursorcolumn!<CR>
nnoremap <leader>l :set cursorline!<CR>

" 
" Set solarized to dark or light depending on what 
" iterm profile the session was launched with.
" 
let g:solar_state=0 
function! SetDefaultSolar()          " ,x toggles dark/light
    if $ITERM_PROFILE == 'solarized-dark'
        call SolarDark()
    elseif $ITERM_PROFILE == 'solarized-light'
        call SolarLight()
	elseif g:solar_state == 0
        call SolarDark()
	elseif g:solar_state == 1
        call SolarLight()
    endif
	call lightline#colorscheme()
endfunction
autocmd VimEnter * call SetDefaultSolar()

function! SolarDark()
	let g:solar_state=0
    colorscheme PaperColor "solarized8_dark
    set background=dark
    hi colorcolumn ctermbg=darkgrey
endfunction

function! SolarLight()
	let g:solar_state=1
	colorscheme PaperColor "solarized_light
	set background=light
	hi colorcolumn ctermbg=lightgrey
endfunction

function! ToggleColors()
	if g:solar_state == 0 | call SolarLight() | else | call SolarDark() | endif
endfunction
noremap <leader>tc :call ToggleColors()<CR>

" Remove next line comment to force dark color scheme.
" Usually it's picked because iTerm2 will pass it in.
" setenv ITERM_PROFILE solarized-dark

 

"""""""""""""""""
" TABS AND SPACES
"""""""""""""""""
"set nosmartindent       " explicitly turn off. C-style doesn't work with R comments #
set smartindent       " explicitly turn off. C-style doesn't work with R comments #
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
nmap < <C-w>5<
nmap > <C-w>5>


" Make it easier to (make it easier to (make it easier to (edit text)))
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

" Run this file through psql
" map gp :wa<CR>:!psql -d INSERTDBNAMEHERE -f %<CR>
" map ss :wa<CR>:!sqlcmd -D -S DBNAME -P PASSWORD -U sa -i %<CR>
"


" Run this file through python3
" map gy :wa<CR>:!python3 %<CR>


" Open current Markdown (*.md) file in OS X "Marked" and force redraw
nnoremap <leader>m :silent !open -a "Marked 2.app" '%:p'<cr> :redraw!<cr>

"    nnoremap <leader>r gq}               " *r*eformat current paragraph

" Abbreviations From http://vimcasts.org/episodes/show-invisibles/
ab [check] ✓
ab [x] ×
ab [o] ○
ab [dag] †
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
ab [space] ␢
ab [degree] ° 
ab [mu] µ
ab [ss] §
ab [sd] σ
ab [blank] ␣

" Toggle invisible whiteSpace ¬ ¶
nnoremap <leader>i :set list!<CR>
set listchars=eol:¬,tab:▸\.,trail:▫,nbsp:_,extends:»,precedes:«

" Capital Y copies to the EOL
nnoremap <S-y> y$

" Page-up/down with Control harmonizes with vim keys
nmap <C-j> <C-d>
" nmap <C-k> <C-u>
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
" nnoremap <Tab> :tabp<CR>
" move easily b/w panes with TAB
nnoremap <Tab> <C-w><C-w>




 

"""""""""
" PLUGINS
"""""""""
" https://github.com/junegunn/vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')

	Plug 'jalvesaq/vimcmdline'
	let cmdline_map_start          = '<LocalLeader>s'
	let cmdline_map_send           = '<Space>'
	let cmdline_map_send_and_stay  = '<LocalLeader><Space>'
	let cmdline_map_source_fun     = '<LocalLeader>f'
	let cmdline_map_send_paragraph = '<LocalLeader>p'
	let cmdline_map_send_block     = '<LocalLeader>b'
	let cmdline_map_quit           = '<LocalLeader>q'
	" vimcmdline options
	let cmdline_vsplit      = 1      " Split the window vertically
	let cmdline_esc_term    = 1      " Remap <Esc> to :stopinsert in Neovim's terminal
	let cmdline_in_buffer   = 1      " Start the interpreter in a Neovim's terminal
	let cmdline_term_height = 15     " Initial height of interpreter window or pane
	let cmdline_term_width  = 80     " Initial width of interpreter window or pane
	let cmdline_tmp_dir     = '/tmp' " Temporary directory to save files
	let cmdline_outhl       = 1      " Syntax highlight the output
	let cmdline_auto_scroll = 1      " Keep the cursor at the end of terminal (nvim)
	let cmdline_app = {}
	let cmdline_app['python'] = 'ipython'
	let cmdline_app['sh']     = 'bash'


    Plug 'lifepillar/vim-solarized8'        " for solarized8_dark or solarized8_light
	Plug 'NLKNguyen/papercolor-theme'

    Plug 'kchmck/vim-coffee-script'         " syntax: coffee script
    Plug 'digitaltoad/vim-pug'              " syntax: pug
    Plug 'iloginow/vim-stylus'              " syntax: stylus

    " Plug 'chrisbra/csv.vim'
    "

    Plug 'nixon/vim-vmath'
    " vmap <expr> ++ VMATH_YankAndAnalyse()
    " nmap        ++ vip++

    " After installing, run ~/.fzf/install
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    nnoremap <silent> <leader>ff        :FZF<CR>
    nnoremap <silent> <C-T> :Files<CR>
    nmap <leader>fc     :Commits<CR>
    "let g:fzf_layout = { 'window': 'left' }
    au FileType fzf tnoremap <nowait><buffer> <esc> <c-g>

    Plug 'junegunn/limelight.vim'
    nmap <leader>tl :Limelight!! 0.7<CR>

    Plug 'junegunn/rainbow_parentheses.vim'
    let g:rainbow#pairs = [['(', ')'], ['[', ']']]

    Plug 'junegunn/goyo.vim'        
    let g:goyo_width = 100
    nmap <leader>tg :silent Goyo<CR>

    Plug 'junegunn/vim-easy-align',     { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)
    let g:easy_align_delimiters = { ';': {'pattern': ':'}, 'a': {'pattern': '<-'}, '<': {'pattern': '<-'}, ':': {'pattern': ':='}}
    
    Plug 'junegunn/vim-peekaboo'        " extend hash and at "

    Plug 'junegunn/vim-easy-align',     { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)
    let g:easy_align_delimiters = { ';': {'pattern': ':'}, 'a': {'pattern': '<-'}, '<': {'pattern': '<-'}, ':': {'pattern': ':='}}


    Plug 'itchyny/lightline.vim'
    "let g:lightline = {'colorscheme': 'solarized'}

    Plug 'edkolev/tmuxline.vim', {'on': ['Tmuxline', 'TmuxlineSimple', 'TmuxlineSnapshot'] }
    let g:tmuxline_preset               = 'minimal'
    let g:tmuxline_theme                = 'lightline'
    let g:tmuxline_powerline_separators = 0
    let g:tmuxline_status_justify       = 'left'
    " Special prompt variables come from stftime and https://github.com/edkolev/tmuxline.vim
    let g:tmuxline_preset = {
        \'a'    : '#S',
        \'cwin' : '#I #W',
        \'win'  : '#I #W',
        \'y'    : '%a %b %e',
        \'z'    : '%-l:%M %p'}
    nmap <leader>tm :Tmuxline<CR>

    " Test tmux settings from vim (weird, I know) by typing ,tm
    " If good, run :TmuxlineSnapshot ~/.tmux.snapshot
    " Then merge that into the bottom of your .tmux.conf
    
    Plug 'kassio/neoterm'

    Plug 'regedarek/ZoomWin'            " <ctrl-w>o zoom in/out window

    " For R language
    Plug 'jalvesaq/colorout', { 'for': 'r' }
    Plug 'jalvesaq/Nvim-r',   { 'for': 'r' }
    vmap <silent> <Space> <Plug>RSendSelection<Esc><Esc>
    nmap <silent> <Space> :call SendLineToR("stay")<CR><Esc><Home><Down>
    "nmap <silent> <S-C-l> :call SendLineToR("system('clear')")<CR><Esc><Home><Down>

    let R_assign = 0
    let R_args = ['--no-save', '--quiet']
    " let R_hi_fun = 0   " workaround no longer needed
    let R_tmpdir = '~scott/R/tmp'
    let R_source_args = 'print.eval=F'
    " I needed to run `brew link --force readline` in order to get gcc5
    " to compile nvimcom (which updates automatically when you invoke nvim-r)

    " maltese
    nmap <silent> ✠ :call SendLineToR("stay")<CR><Esc><Home><Down>
    imap <silent> ✠ <Esc>:call SendLineToR("stay")<CR><Esc>A
    vmap ✠ <Plug>RSendSelection<Esc><Esc>
    " nmap <leader>fe :call SendFunctionToR("echo", "stay")<CR><Esc>

    Plug 'kshenoy/vim-signature'                    " show marks in margin
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'                     " smarter commenting with gc

    Plug 'airblade/vim-gitgutter'                   " shows git diff marks in the gutter
    nmap <silent> <leader>tu :GitGutterToggle<CR>   
    let g:gitgutter_enabled = 1                     " off by default

call plug#end()

" Toggle Line numbers on/off
nmap <silent> <leader>tn :set invnumber<CR>

let g:iron_map_defaults=0
augroup ironmapping
    autocmd!
    autocmd Filetype python nmap <buffer> <leader>t <Plug>(iron-send-motion)
    autocmd Filetype python vmap <buffer> <leader>t <Plug>(iron-send-motion)
    autocmd Filetype python nmap <buffer> <leader>. <Plug>(iron-repeat-cmd)
augroup END


" Wrapping autocmd in a group per http://bit.ly/15wKRrM
augroup my_au
    autocmd!
    "    au FileType python setlocal expandtab ts=2 sw=2 sts=2
    au FileType make setlocal noexpandtab

    " place this after plugins have loaded
    " Set textwidth like a boss http://blog.ezyang.com/2010/03/vim-textwidth/
    au FileType text,markdown setlocal textwidth=72 colorcolumn=80
    au FileType stylus,jade set tabstop=2|set softtabstop=2|set shiftwidth=2|set expandtab
    au FileType javascript set tabstop=4|set shiftwidth=4|set expandtab
    au FileType r set ts=2 softtabstop=2 shiftwidth=2 expandtab
    au FileType zsh set tabstop=4|set shiftwidth=4|set expandtab

    au BufEnter *.tsv set tabstop=14 softtabstop=14 shiftwidth=14 noexpandtab

    " PEP8 has defined the proper indentation for Python
    au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=90 expandtab fileformat=unix

    " Turn off line wrapping when working on HTML files
    au BufNewFile,BufRead *.html setlocal nowrap

    " Go into insert mode when entering terminal
    " au BufEnter * if &buftype == 'terminal' | :startinsert | endif
augroup END

augroup rainbow_paren
    autocmd!
    autocmd FileType r RainbowParentheses
    autocmd FileType python RainbowParentheses
augroup END

" Remember the cursor position for every file
function! PositionCursorFromViminfo()
    if !(bufname("%") =~ '\(COMMIT_EDITMSG\)') && line("'\"") > 1 && line("'\"") <= line("$")
        exe "normal! g`\""
    endif
endfunction
autocmd BufReadPost * call PositionCursorFromViminfo()


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

nnoremap <leader>t0 :silent call WordProcessorMode()
" Run "formd" command on buffer to fix Markdown hyperlinks
" This script assumes formd is in your path at:
" ~/bin/formd/formd
" http://drbunsen.github.com/formd/
 
function! Formd(option)
    :let save_view = winsaveview()
    :let flag = a:option
    :if flag == "-r"
        :%! formd.py -r
    :elseif flag == "-i"
        :%! formd.py -i
    :else
        :%! formd.py -f
    :endif
    :call winrestview(save_view)
endfunction
 
" Toggle hyperlinks in Markdown on/off
nnoremap <leader>th :call Formd("-f")<CR>
" nmap <leader>fi :call Formd("-i")<CR>
" nmap <leader>f :call Formd("-f")<CR>
"
"""""""""""""""""""""""""""""""""""""""""""""""

" Meta key ⌥  mappings
tnoremap <M-h> <C-\><C-N><C-w>h
tnoremap <M-j> <C-\><C-N><C-w>j
tnoremap <M-k> <C-\><C-N><C-w>k
tnoremap <M-l> <C-\><C-N><C-w>l
inoremap <M-h> <C-\><C-N><C-w>h
inoremap <M-j> <C-\><C-N><C-w>j
inoremap <M-k> <C-\><C-N><C-w>k
inoremap <M-l> <C-\><C-N><C-w>l
nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l
nnoremap <M-t> :split term://zsh


" Easily get out of Terminal mode
tnoremap <Esc> <C-\><C-n>
tnoremap <Esc><Esc> <C-\><C-n><C-w>k

hi Folded ctermbg=7 ctermfg=4
"
" Make / searches stand out in magenta
highlight Search term=bold ctermbg=LightMagenta guibg=LightMagenta



highlight CursorLine cterm=none ctermbg=Blue 

" Colors
"highlight CursorLine cterm=none ctermbg=LightGrey 

" The order for next two lines here might matter
set termguicolors                   " Set the cursor color
" colorscheme solarized8_light

au VimLeave * set guicursor=a:block-blinkon0

highlight Cursor guifg=#FF00FF guibg=#FF00FF        " magenta cursor
"highlight CursorLine cterm=none ctermbg=none guifg=#FFFF00 guibg=#FFFF00
highlight CursorLine guifg=#FF0000 guibg=#DDDD00

set guicursor=n-v-c:block-Cursor/lCursor-blinkon0
set guicursor+=i-ci:ver50-Cursor/lCursor-blinkwait500-blinkon200-blinkoff150
set guicursor+=r-cr:hor20-Cursor/lCursor

noremap <silent> <leader>om :call OpenMarkdownPreview()<cr>

function! OpenMarkdownPreview() abort
  if exists('s:markdown_job_id') && s:markdown_job_id > 0
    call jobstop(s:markdown_job_id)
    unlet s:markdown_job_id
  endif
  let s:markdown_job_id = jobstart('grip ' . shellescape(expand('%:p')))
  if s:markdown_job_id <= 0 | return | endif
  call system('open http://localhost:6419')
endfunction


autocmd Filetype coffee setlocal ts=2 sw=2 sts=0 expandtab
autocmd Filetype pug set ts=2 sts=0 sw=2 expandtab

" help :digraph
inoremap <expr> <C-K> ShowDigraphs()
function! ShowDigraphs()
    digraphs
    call getchar()
    return "\<C-K>"
endfunction

au TermOpen * setlocal nonumber norelativenumber
