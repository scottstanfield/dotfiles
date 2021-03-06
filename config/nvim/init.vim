" https://www.rosipov.com/blog/sane-vim-defaults-from-neovim/
" https://codekoalas.com/blog/why-you-should-still-use-neovim
" https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
" https://danishpraka.sh/2018/06/30/vim-plugins-i-use.html
" https://dev.to/casonadams/ditch-vscode-for-neovim-25ca

" zR • open all folds
" zM • close all folds

let g:solar_state=1

let mapleader = ","             " Our free key to prefix custom commands
let localleader = "\\"
let g:plug_shallow=1

" PLUGINS {{{

" https://github.com/junegunn/vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

    " Essential
    Plug 'sheerun/vim-polyglot'             " all the best language / syntax packs
    Plug 'ryanoasis/vim-devicons'

    Plug 'mileszs/ack.vim'

    Plug 'csexton/trailertrash.vim'         "
    Plug 'editorconfig/editorconfig-vim'
    Plug 'lifepillar/vim-colortemplate'
    Plug 'tpope/vim-fugitive'
    Plug 'chriskempson/base16-vim'

    " Highlight a code block in visual mode and :Silicon to generate a nice PNG
    Plug 'segeljakt/vim-silicon'

    " Slideshows with remarkjs
    Plug 'idbrii/vim-remarkjs'
    Plug 'idbrii/vim-gogo'
    Plug 'tyru/open-browser.vim'

    Plug 'sotte/presenting.vim'

    Plug 'powerman/vim-plugin-AnsiEsc'

    " Plug 'scottstanfield/vimcmdline'

    " colorschemes
    Plug 'lifepillar/vim-solarized8'
    "Plug 'NLKNguyen/papercolor-theme'
    Plug 'dracula/vim'
    Plug 'junegunn/seoul256.vim'

    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
    Plug 'ryanoasis/vim-devicons'

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/limelight.vim'
    Plug 'junegunn/rainbow_parentheses.vim'
    Plug 'junegunn/vim-peekaboo'

    Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
    let g:goyo_width = 80
    nmap <leader>to :silent Goyo<CR>

    Plug 'junegunn/vim-easy-align',     { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)
    let g:easy_align_delimiters = { ';': {'pattern': ':'}, '>': {'pattern': '>'}, 'a': {'pattern': '<-'}, '<': {'pattern': '<-'}, ':': {'pattern': ':='}}
    au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>


    " vim as a markdown editor: https://secluded.site/vim-as-a-markdown-editor
    Plug 'godlygeek/tabular'

    Plug 'plasticboy/vim-markdown'
    Plug 'itchyny/lightline.vim'
    let g:lightline = {'colorscheme': 'solarized'}

    Plug 'edkolev/tmuxline.vim', {'on': ['Tmuxline', 'TmuxlineSimple', 'TmuxlineSnapshot'] }

    Plug 'kassio/neoterm'

    Plug 'jalvesaq/colorout', { 'for': 'r' }
    Plug 'jalvesaq/Nvim-r', {'branch': 'stable' }
    Plug 'kshenoy/vim-signature'                    " show marks in margin

    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-commentary'                     " smarter commenting with gc
    Plug 'tpope/vim-vinegar'                        " smarter commenting with gc

    Plug 'airblade/vim-gitgutter'                   " shows git diff marks in the gutter

call plug#end()
" }}}

" Plugin Configurations {{{

function! ColorSolarizedDark()
    let g:airline_theme='solarized'
    colorscheme solarized8_high
    call lightline#colorscheme()
endfunction

function! ColorDracula()
    color dracula
    let g:lightline = {'colorscheme': 'ayu_light'}
    call lightline#colorscheme()
endfunction

function! ColorSeoul256()
    color seoul256
    let g:airline_theme='silver'
    call lightline#colorscheme()
endfunction

nmap <leader>e1 :call ColorSolarizedDark()<cr>
nmap <leader>e2 :call ColorDracula()<cr>
nmap <leader>e3 :call ColorSeoul256()<cr>


" junegunn/rainbow_parenthesis
let g:rainbow#pairs = [['(', ')'], ['[', ']']]

nmap <leader>tl :Limelight!! 0.7<CR>

" junegunn/goyo.vim {{{
let g:goyo_width = 70
nmap <leader>tm :silent Goyo<CR>
" }}}
" jalvesaq/Nvim-r {{{
    let R_assign = 0
    let R_args = ['--no-save', '--quiet']
    let R_tmpdir = '~scott/R/tmp'               " TODO: consider removing this
    let R_source_args = 'print.eval=F'
    " " I needed to run `brew link --force readline` in order to get gcc5
    " to compile nvimcom (which updates automatically when you invoke nvim-r)
    " map <silent> <Space> :call SendLineToR("stay")<CR><Esc><Home><Down>
    " vmap <silent> <Space> <Plug>RSendSelection<Esc><Esc>
    " nmap <silent> ✠       :call SendLineToR("stay")<CR><Esc><Home><Down>
    " imap <silent> ✠       <Esc>:call SendLineToR("stay")<CR><Esc>A
    " vmap ✠                  <Plug>RSendSelection<Esc><Esc>
"}}}
" edkolev/tmuxline.vim {{{
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
"nmap <leader>tm :Tmuxline<CR>

" Test tmux settings from vim (weird, I know) by typing ,tm
" If good, run :TmuxlineSnapshot ~/.tmux.snapshot
" Then merge that into the bottom of your .tmux.conf
" }}}
" fuzzyfinder {{{
nnoremap <silent> <c-p> :FZF<CR>
nnoremap <silent> <leader>ff :FZF<CR>
nnoremap <silent> <leader>ft :Files<CR>
nmap <leader>fc     :Commits<CR>
"let g:fzf_layout = { 'window': 'left' }
au FileType fzf tnoremap <nowait><buffer> <esc> <c-g>
" }}}
" plasticboy/vim-markdown {{{
    let g:vim_markdown_folding_disabled = 1
    let g:vim_markdown_frontmatter = 1
    let g:vim_markdown_strikethrough = 1
    let g:vim_markdown_conceal = 2
    let g:vim_markdown_conceal_code_blocks = 0
    let g:vim_markdown_edit_url_in = 'tab'
    let g:vim_markdown_follow_anchor = 1
    let g:vim_markdown_frontmatter = 1
    let g:vim_markdown_strikethrough = 1
    let g:vim_markdown_toml_frontmatter = 1
"}}}
" Nerdtree {{{
let g:NERDTreeShowHidden=1
let g:NERDTreeMinimalUI=1
let g:NERDTreeIgnore=['\.git$[[dir]]']

augroup nerd_loader
    autocmd!
    autocmd VimEnter * silent! autocmd! FileExplorer
    autocmd BufEnter,BufNew *
        \  if isdirectory(expand('<amatch>'))
        \|   call plug#load('nerdtree')
        \|   execute 'autocmd! nerd_loader'
        \| endif
augroup END
nnoremap <leader>n :NERDTreeToggle<cr>
nnoremap <c-t> :NERDTreeToggle<cr>
" }}}
" scottstanfield/vimcmdline {{{
" let cmdline_map_start          = '<LocalLeader>s'
" let cmdline_map_send           = '<Space>'
" let cmdline_map_send_and_stay  = '<LocalLeader><Space>'
" let cmdline_map_source_fun     = '<LocalLeader>f'
" let cmdline_map_send_paragraph = '<LocalLeader>p'
" let cmdline_map_send_block     = '<LocalLeader>b'
" let cmdline_map_quit           = '<LocalLeader>q'
" let cmdline_vsplit      = 0      " Split the window vertically
" let cmdline_esc_term    = 1      " Remap <Esc> to :stopinsert in Neovim's terminal
" let cmdline_in_buffer   = 1      " Start the interpreter in a Neovim's terminal
" let cmdline_term_height = 15     " Initial height of interpreter window or pane
" let cmdline_term_width  = 80     " Initial width of interpreter window or pane
" let cmdline_tmp_dir     = '/tmp' " Temporary directory to save files
" let cmdline_outhl       = 1      " Syntax highlight the output
" let cmdline_auto_scroll = 1      " Keep the cursor at the end of terminal (nvim)
" let cmdline_app = {}
" let cmdline_app['python'] = 'ipython'
" let cmdline_app['sh']     = 'bash'
" let cmdline_app['julia']  = 'julia'
" let cmdline_app['javascript']  = 'node'
" }}}
" TrailerTrash {{{
nmap <silent> <leader>$ :TrailerTrim<cr>
nmap <silent> <leader>w :Trailer<cr>
let g:show_trailertrash = 1
"autocmd FileType c,python,r,javascript BufWritePre :call TrailerTrim()
" }}}
" airblade/vim-gutter {{{
    nmap <silent> <leader>tg :GitGutterToggle<CR>
    let g:gitgutter_enabled = 0                     " off by default
" }}}

" }}} Plugin configuration

" INSERT MODE  {{{
" readline: mimic emacs like line-editing in insert-mode
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

" Ctrl-s to save current file (in normal and insert mode)
imap <c-s> <Esc>:w<CR>a
nmap <c-s> :w<CR>

inoremap <expr> <C-d> ShowDigraphs()
function! ShowDigraphs()
    digraphs
    call getchar()
    return "\<C-K>"
endfunction

" }}}

" COLORS {{{
" Hide the Magenta with ,/
nnoremap <silent> <leader>/ :set hlsearch! hlsearch?<CR>

if has('termguicolors')
    set termguicolors
endif
hi Cursor guifg=green guibg=green
hi Cursor2 guifg=red guibg=red

" TODO: fix cursor for insert mode 
"set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50

set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
		  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
		  \,sm:block-blinkwait175-blinkoff150-blinkon175

 " highlight Cursor guifg=white guibg=black
 " highlight iCursor guifg=white guibg=steelblue
 " set guicursor=n-v-c:block-Cursor
 " set guicursor+=i:ver100-iCursor
 " set guicursor+=n-v-c:blinkon0
 " set guicursor+=i:blinkwait10

" }}}

" SETS {{{

set clipboard+=unnamedplus      " Use system clipboard

" Vertical Split lighten color of vertical split and remove | bar
" https://stackoverflow.com/questions/9001337/vim-split-bar-styling
"highlight VertSplit ctermfg=bg
set fillchars+=vert:\

set hidden                      " switch buffers w/o saving
set undofile

" Long lines get wrapped with this cool symbol
let &showbreak = '↳ '
set breakindent
set breakindentopt=sbr

"""""""""""""""""
" TABS AND SPACES
"""""""""""""""""
"set nosmartindent       " explicitly turn off. C-style doesn't work with R comments #
set smartindent       " explicitly turn off. C-style doesn't work with R comments #
set nowrap              " do not wrap lines please
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4        " no clue what this does
set shiftround          " if spaces, TAB maps to right spot

" General
set nobackup                    " don't let vim backup files
set noswapfile
set nowritebackup               " And again.
set autochdir                   " always switch to current dir
set wildmode=list:longest       " Complete files like a shell.
set modeline
set noerrorbells                " No beeping!
set novisualbell                " No flashing either.
set wildignore+=*.jpg,*.gif,*.png,*.git,*.gem,*.zip,*.tar.gz,node_modules

"""""""""""
" UI CONFIG
"""""""""""
let loaded_matchparen=1         " Just use % instead of auto paren matching
set colorcolumn=80              " vertical line at 80 cols
set nostartofline               " Searches leave cursor on same column
set ignorecase                  " Case-insensitive searching.
set lazyredraw                  " No redraw during macro execution
set number                      " Show line numbers.
set shortmess=atIF              " stifle the long interrupt prompts
set showmode                    " Display the mode you're in.
set smartcase                   " But case-sensitive if has caps
set scrolloff=3                 " Show 3 lines around cursor (more context)
set noshowmode                  " hide the default mode text (e.g. -- INSERT --)
set splitbelow                  " more natural to open new splits below
set splitright                  " and to the right
"}}}

" MAPS {{{

" Make ctrl-6 the same as ctrl-^
nnoremap <c-6> <c-^>
" Flip back to previous file
nnoremap `` <c-^>
nnoremap <leader><leader> <c-^>

" Move visual blocks up/down: it's magic
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv


" Capital Y copies to the EOL for consistency with other capital commands
nnoremap Y y$

" Page-up/down with Control harmonizes with vim keys
nmap <C-j> <C-d>
" nmap <C-k> <C-u>
vmap <C-j> <C-d>
vmap <C-k> <C-u>

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

" Open current Markdown (*.md) file in OS X "Marked" and force redraw
nnoremap <leader>m :silent !open -a "Marked 2.app" '%:p'<cr> :redraw!<cr>

" Two quick jk exits insert mode (odd, I know)
inoremap jk <Esc>l

" Change tabs to spaces, or the other way around. Good for Python!
nmap <leader>1 :set et<cr>:retab<cr>
nmap <leader>2 :set noet<cr>:retab!<cr>

nnoremap <silent> <S-Up> :wincmd k<CR>
nnoremap <silent> <S-Down> :wincmd j<CR>
nnoremap <silent> <S-Left> :wincmd h<CR>
nnoremap <silent> <S-Right> :wincmd l<CR>

" keys to quickly resize window/pane splits
" plus and minus (really underscore)
nmap + <C-w>5+
nmap = <C-w>5+
nmap - <C-w>5-
nmap < <C-w>5<
nmap > <C-w>5>

" Q for formatting paragraph or selection
vnoremap Q gq
nnoremap Q gqap
nnoremap <C-q> :q<cr>

" Sane navigation for wrapped lines
nnoremap j gj
nnoremap k gk
"}}}

" TOGGLES {{{
" toggle line wrapping modes
nnoremap <silent> <leader>tw :set invwrap<CR>:set wrap?<CR>

" Toggle invisible whiteSpace ¬ ¶
nnoremap <leader>i :set list!<CR>
set listchars=eol:¬,tab:▸\.,trail:▫,nbsp:_,extends:»,precedes:«


" Toggle Line numbers on/off
nmap <silent> <leader>tn :set invnumber<CR>

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

" Highlight current line and column
nnoremap <leader>c :set cursorcolumn!<CR>
nnoremap <leader>l :set cursorline!<CR>

function! ToggleFolds()
    if &foldlevel > 0
        set foldlevel=0
    else
        set foldlevel=3
    endif
endfunction
nnoremap zz :call ToggleFolds()<cr>

"}}}

" OBSOLETE; kept for historical reasons{{{
"nnoremap <silent> q <space>
"nnoremap vv ^vg_|       " Select current line, excluding indents (great for copying to clipboard)
"noremap K <Esc>|        " Disable K from looking stuff up
"noremap H ^|           " Use capital H/L for first/last non-whitespace character on line
"noremap L g_

" split window vertically into two linked columns--very cool
noremap <silent> <leader>vs :<C-u>let @z=&so<CR>:set so=0 noscb<CR>:bo vs<CR>Ljzt:setl scb<CR><C-w>p:setl scb<CR>:let &so=@z<CR>
" map q <Nop>
" I rarely use macros, but I accidentally hit q all the time

"}}}

" NEOVIM terminal commands {{{

function! OpenTerminal()
  split term://zsh
  resize 10
endfunction
nnoremap <c-n> :call OpenTerminal()<CR>

cnoremap Wq wq
cnoremap Qa qa

" Easily get out of neovim Terminal mode
tnoremap <Esc> <C-\><C-n>
tnoremap <Esc><Esc> <C-\><C-n><C-w>k

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

au TermOpen * setlocal nonumber norelativenumber
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
"}}}

" Folding {{{

highlight folded ctermbg=7 ctermfg=4
set foldmethod=marker
nnoremap <silent> <space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <space> zf
"}}}

" AUTOGROUPS {{{

" Check spelling: [s ]s z= zg
augroup markdown
    autocmd!
    "autocmd Filetype markdown setlocal spell spelllang=en_us
    autocmd filetype markdown set conceallevel=2
    autocmd filetype markdown set cursorline
augroup END

" buffers
" https://dev.to/nickjj/writing-and-previewing-markdown-in-real-time-with-vim-8-3icf

let g:iron_map_defaults=0
augroup ironmapping
    autocmd!
    autocmd Filetype python nmap <buffer> <leader>t <Plug>(iron-send-motion)
    autocmd Filetype python vmap <buffer> <leader>t <Plug>(iron-send-motion)
    autocmd Filetype python nmap <buffer> <leader>. <Plug>(iron-repeat-cmd)
augroup END

augroup yaml_syntax
    autocmd!
    autocmd BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
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
    "au FileType javascript set tabstop=4|set shiftwidth=4|set expandtab
    au FileType javascript set tabstop=2|set shiftwidth=2|set expandtab
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
    autocmd FileType bash RainbowParentheses
augroup END

" Remember the cursor position for every file
" function! PositionCursorFromViminfo()
"     if !(bufname("%") =~ '\(COMMIT_EDITMSG\)') && line("'\"") > 1 && line("'\"") <= line("$")
"         exe "normal! g`\""
"     endif
" endfunction
" autocmd BufReadPost * call PositionCursorFromViminfo()

" see :help restore-cursor
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif


" }}}

" Markdown and Word processing mode {{{
" Go into WordProcessorMode when typing Markdown paragraphs: <leader>0
" http://www.drbunsen.org/writing-in-vim/
func! WordProcessorMode()
    setlocal tw=80
    setlocal formatoptions=1t
    setlocal noexpandtab
    "setlocal spell spelllang=en_us
    set complete+=s
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
        :%! formd -r
    :elseif flag == "-i"
        :%! formd -i
    :else
        :%! formd -f
    :endif
    :call winrestview(save_view)
endfunction

" Toggle hyperlinks in Markdown on/off
nnoremap <leader>th :call Formd("-f")<CR>
" nmap <leader>fi :call Formd("-i")<CR>
" nmap <leader>f :call Formd("-f")<CR>
"




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

"}}}

" Use ripgrep for searching ⚡️
" Options include:
" --vimgrep -> Needed to parse the rg response properly for ack.vim
" --type-not sql -> Avoid huge sql file dumps as it slows down the search
" --smart-case -> Search case insensitive if all lowercase pattern, Search case sensitively otherwise
let g:ackprg = 'rg --vimgrep --type-not sql --smart-case'

" Auto close the Quickfix list after pressing '<enter>' on a list item
let g:ack_autoclose = 1

" Any empty ack search will search for the work the cursor is on
let g:ack_use_cword_for_empty_search = 1

" Don't jump to first match
cnoreabbrev Ack Ack!

" Maps <leader>/ so we're ready to type the search keyword
nnoremap <Leader>/ :Ack!<Space>

" Navigate quickfix list with ease
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>

" colorscheme stuff has to go afer plug
" https://github.com/junegunn/vim-plug/wiki/faq#im-getting-cannot-find-color-scheme--does-vim-plug-support-color-schemes

" Set solarized to dark or light depending on what
" iterm profile the session was launched with.
"
let g:solar_state=1
function! SetDefaultSolar()          " ,x toggles dark/light
    elseif g:solar_state == 0
        call SolarDark()
    elseif g:solar_state == 1
        call SolarLight()
    endif
    call lightline#colorscheme()
endfunction

function! SolarDark()
    let g:solar_state=0
    set background=dark
    colorscheme solarized8_high
    " hi colorcolumn ctermbg=darkgrey
endfunction

function! SolarLight()
    let g:solar_state=1
    set background=light
    colorscheme solarized8_high
    hi colorcolumn ctermbg=lightgrey
endfunction

function! ToggleColors()
    if g:solar_state == 0 | call SolarLight() | else | call SolarDark() | endif
endfunction
noremap <leader>tc :call ToggleColors()<CR>

" set background=dark
" try
"   colorscheme solarized8_high
" catch
" endtry

highlight Comment cterm=italic
set t_ZH=[3m
set t_ZR=[23m

set background=dark
colorscheme solarized8_high


" if filereadable(expand("~/.vimrc_background"))
"   let base16colorspace=256
"   set background=dark
"   source ~/.vimrc_background
" endif



" CAPSLOCK {{{
  " Insert and command-line mode Caps Lock.
  " Lock search keymap to be the same as insert mode.
  set imsearch=-1
  " Load the keymap that acts like capslock.

try
    set keymap=insert-only_capslock
    " Turn it off by default.
    set iminsert=0
    " kill capslock when leaving insert mode
    autocmd InsertLeave * set iminsert=0
    let b:keymap_name="CAPS"
    set statusline^=%k
catch
endtry

" highlight Cursor guifg=NONE guibg=Green
" highlight lCursor guifg=NONE guibg=Cyan

  
" }}}

