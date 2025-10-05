" https://www.rosipov.com/blog/sane-vim-defaults-from-neovim/
" https://codekoalas.com/blog/why-you-should-still-use-neovim
" https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
" https://danishpraka.sh/2018/06/30/vim-plugins-i-use.html
" https://dev.to/casonadams/ditch-vscode-for-neovim-25ca

" zR • open all folds
" zM • close all folds

let mapleader = ","				" Our free key to prefix custom commands
let localleader = "\\"
let g:plug_shallow=1

" PLUGINS {{{

" https://github.com/junegunn/vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

function! CheckForR()
    return executable('R')
endfunction 

call plug#begin('~/.config/nvim/plugged')

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-lua/plenary.nvim'

" Essential
"Plug 'sheerun/vim-polyglot'				" all the best language / syntax packs
Plug 'ryanoasis/vim-devicons'
Plug 'tmux-plugins/vim-tmux'
"Plug 'JuliaEditorSupport/julia-vim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'tpope/vim-unimpaired'              " ]p paste below; [p paste above

Plug 'nicwest/vim-camelsnek'

" Colors
Plug 'dracula/vim', {'as': 'dracula'}
Plug 'p00f/alabaster.nvim'

" from vim boilerplate generator
"Plug 'dense-analysis/ale'           " code linting

Plug 'Yggdroot/indentLine'          " | in the white space
let g:indentLine_enabled = 0
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_faster = 1

"" HTML Bundle
Plug 'hail2u/vim-css3-syntax'
Plug 'tpope/vim-haml'
Plug 'mattn/emmet-vim'
Plug 'jelera/vim-javascript-syntax'

Plug 'mileszs/ack.vim'
"Plug 'Raimondi/delimitMate'		 " auto closing quotes

Plug 'atelierbram/vim-colors_atelier-schemes'
Plug 'csexton/trailertrash.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'lifepillar/vim-colortemplate'
Plug 'chriskempson/base16-vim'

" Highlight a code block in visual mode and :Silicon to generate a nice PNG
Plug 'segeljakt/vim-silicon'

" Slideshows with remarkjs
" Plug 'idbrii/vim-remarkjs'
" Plug 'idbrii/vim-gogo'
" Plug 'tyru/open-browser.vim'
" Plug 'sotte/presenting.vim'

Plug 'powerman/vim-plugin-AnsiEsc'

Plug 'scottstanfield/vimcmdline'
Plug 'jalvesaq/colorout', { 'for': 'r' }

" colorschemes
"Plug 'NLKNguyen/papercolor-theme'
Plug 'dracula/vim'
Plug 'junegunn/seoul256.vim'

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'jistr/vim-nerdtree-tabs'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/limelight.vim'
nmap <leader>tl :Limelight!! 0.7<CR>

Plug 'junegunn/vim-peekaboo'

" Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
Plug 'junegunn/goyo.vim'
let g:goyo_width = 80
nmap <leader>to :silent Goyo<CR>

Plug 'junegunn/vim-easy-align',		{ 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] }
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
let g:easy_align_delimiters = { '/': {'pattern': '/'}, ';': {'pattern': ';'}, '>': {'pattern': '>'}, 'a': {'pattern': '<-'}, '<': {'pattern': '<-'}, ':': {'pattern': ':='}}
au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>


" vim as a markdown editor: https://secluded.site/vim-as-a-markdown-editor
" Plug 'godlygeek/tabular'
" Plug 'plasticboy/vim-markdown'

" plasticboy/vim-markdown 
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_edit_url_in = 'tab'
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_toml_frontmatter = 1
	
" Plug 'itchyny/lightline.vim'
" let g:lightline = {'colorscheme': 'dracula'}

Plug 'edkolev/tmuxline.vim', {'on': ['Tmuxline', 'TmuxlineSimple', 'TmuxlineSnapshot'] }

Plug 'kassio/neoterm'

Plug 'jalvesaq/colorout', { 'for': 'r' }

command Z w | qa
cabbrev wqa Z

Plug 'kshenoy/vim-signature'                    " show marks in margin
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'						" smarter commenting with gc
Plug 'tpope/vim-vinegar'						" smarter commenting with gc
Plug 'tpope/vim-surround'

Plug 'airblade/vim-gitgutter'					" shows git diff marks in the gutter
nmap <silent> <leader>tg :GitGutterToggle<CR>
let g:gitgutter_enabled = 1						" off by default

Plug 'github/copilot.vim'
"Plug 'mechatroner/rainbow_csv'

Plug 'junegunn/rainbow_parentheses.vim'
let g:rainbow#pairs = [['(', ')'], ['[', ']']]
augroup rainbow
  autocmd!
    autocmd FileType julia RainbowParentheses
    autocmd FileType r RainbowParentheses
    autocmd FileType c RainbowParentheses
    autocmd FileType cpp RainbowParentheses
    autocmd FileType python RainbowParentheses
    autocmd FileType bash RainbowParentheses
    autocmd FileType vim RainbowParentheses
    autocmd FileType zsh RainbowParentheses
augroup END

call plug#end()
" }}}

" Plugin Configurations {{{

" junegunn/goyo.vim {{{
let g:goyo_width = 70
nmap <leader>tm :silent Goyo<CR>
" }}}

" jalvesaq/Nvim-r {{{
" rlang

function! s:customRlangMappings()
	noremap <silent> <Space> :call SendLineToR("stay")<CR><Esc><Home><Down>
	vnoremap <silent> <Space> :call SendSelectionToR("silent", "stay")<cr>
endfunction
augroup nvimr
    autocmd!
	let R_args = ['--no-save', '--quiet']
	let R_assign = 0
	" let R_auto_start = 1
    "autocmd filetype r call s:customRlangMappings()
augroup END

" rlang
	" let R_tmpdir = '~$USER/R/tmp'				  " TODO: consider removing this
	" let R_source_args = 'print.eval=F'
	" let R_nvimpager = 'no'
	"let R_auto_start = 1
	" " I needed to run `brew link --force readline` in order to get gcc5
	" to compile nvimcom (which updates automatically when you invoke nvim-r)
	" vnoremap <silent> <Space> <Plug>RSendSelection<Esc><Esc>
	"  inoremap <s-cr> <Esc>:call SendLineToR("stay")<cr><down><home>i

	" handle <s-cr> and <c-cr>
	" https://stackoverflow.com/questions/16359878/how-to-map-shift-enter

	"nmap <Space> <Plug>RSendLine

	" vmap <Space> <Plug>RSendSelection
	" nmap <Space> <Plug>RSendLine

	" nmap <silent> ✠		:call SendLineToR("stay")<CR><Esc><Home><Down>
	" imap <silent> ✠		<Esc>:call SendLineToR("stay")<CR><Esc>A
	" vmap ✠				  <Plug>RSendSelection<Esc><Esc>
"}}}

"autocmd VimLeave * if exists("g:SendCmdToR") && string(g:SendCmdToR) != "function('SendCmdToR_fake')" | call RQuit("nosave") | endif


" fuzzyfinder {{{
nnoremap <silent> <c-p> :FZF<CR>
nnoremap <silent> <leader>ff :FZF<CR>
nnoremap <silent> <leader>ft :Files<CR>
nmap <leader>fc		:Commits<CR>
"let g:fzf_layout = { 'window': 'left' }
au FileType fzf tnoremap <nowait><buffer> <esc> <c-g>
" }}}

" Nerdtree {{{
let g:NERDTreeShowHidden=1
let g:NERDTreeMinimalUI=1
let g:NERDTreeIgnore=['\.git$[[dir]]', 'node_modules','\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']

augroup nerd_loader
	autocmd!
	autocmd VimEnter * silent! autocmd! FileExplorer
	autocmd BufEnter,BufNew *
		\  if isdirectory(expand('<amatch>'))
		\|	 call plug#load('nerdtree')
		\|	 execute 'autocmd! nerd_loader'
		\| endif
augroup END
nnoremap <leader>n :NERDTreeToggle<cr>
nnoremap <c-t> :NERDTreeToggle<cr>
nnoremap <silent> <F2> :NERDTreeFind<CR>
nnoremap <silent> <F3> :NERDTreeToggle<CR>
" }}}
" scottstanfield/vimcmdline {{{

let cmdline_map_start			 = '<LocalLeader>s'
let cmdline_map_send			 = '<Space>'
let cmdline_map_send_and_stay  = '<LocalLeader><Space>'
let cmdline_map_source_fun	 = '<LocalLeader>f'
let cmdline_map_send_paragraph = '<LocalLeader>p'
let cmdline_map_send_block	 = '<LocalLeader>b'
let cmdline_map_quit			 = '<LocalLeader>q'
let cmdline_vsplit	  = 0	   " Split the window vertically
let cmdline_esc_term	  = 1	   " Remap <Esc> to :stopinsert in Neovim's terminal
let cmdline_in_buffer   = 1	   " Start the interpreter in a Neovim's terminal
let cmdline_term_height = 15	   " Initial height of interpreter window or pane
let cmdline_term_width  = 80	   " Initial width of interpreter window or pane
let cmdline_tmp_dir	  = '/tmp' " Temporary directory to save files
let cmdline_outhl		  = 1	   " Syntax highlight the output
let cmdline_auto_scroll = 1	   " Keep the cursor at the end of terminal (nvim)
let cmdline_app = {}
let cmdline_app['python'] = 'ipython --no-confirm-exit'
let cmdline_app['sh']		= 'bash'
let cmdline_app['julia']	= 'julia'
let cmdline_app['javascript']  = 'node'
let cmdline_app['sql']  = 'duckdb'
let cmdline_app['r']  = 'R --no-save --quiet --no-restore-data'


" }}}
" TrailerTrash {{{
nmap <silent> <leader>$ :TrailerTrim<cr>
nmap <silent> <leader>w :Trailer<cr>
let g:show_trailertrash = 1
"autocmd FileType c,python,r,javascript BufWritePre :call TrailerTrim()
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

inoremap <expr> <C-d> ShowDigraphs()
function! ShowDigraphs()
	digraphs
	call getchar()
	return "\<C-K>"
endfunction

" }}}

" Abbreviations {{{
" digraph list: https://devhints.io/vim-digraphs
" Abbreviations From http://vimcasts.org/episodes/show-invisibles/
" https://www.typography.com/blog/house-of-flying-reference-marks
" *, †, ‡, §, ||, #, **, ††, ‡‡, §§, ||||, ###, ***, †††, ‡‡‡

ab [pm] ±
ab [dagger] †
ab [obelus] †
ab [dagger2] ‡
ab [diesis] ‡
ab [section] §
ab [lozenge] ◊
ab [check] ✓
ab [x] ×
ab [o] ○
ab [.] •
ab [>] ▸
ab [heart] ❤
ab [cmd] ⌘
ab [command] ⌘
ab [shift] ⇧
ab [capslock] ⇪
ab [option] ⌥
ab [ctrl] ⌃
ab [tab] ⇥
ab [interpunct] ·
ab [reference] ※
ab [ellipse] …     
ab [bar] ―
ab [left] ←
ab [right] →
ab [pi] π
ab [PI] Π
ab [Pi] Π
ab [rho] ρ
ab [shrug]	¯\_(ツ)_/¯
ab [yhat] ŷ
ab [space] ␢
ab [degree] ° 
ab [deg] ° 
ab [mu] µ
ab [ss] §
ab [sd] σ
ab [theta] θ
ab [Theta] Θ
ab [sigma] σ
ab [Sigma] Σ
ab [rho] ρ
ab [pi] Π
ab [blank] ␣
ab [Delta] Δ
ab [delta] δ
ab [root] √
ab [square] ²
ab [cube] ³


" }}}


" SETS {{{

set clipboard+=unnamedplus		" Use system clipboard

" Vertical Split lighten color of vertical split and remove | bar
" https://stackoverflow.com/questions/9001337/vim-split-bar-styling
"highlight VertSplit ctermfg=bg
set fillchars+=vert:\

set hidden						" switch buffers w/o saving
set undofile

" Long lines get wrapped with this cool symbol
let &showbreak = '↳ '
set breakindent
set breakindentopt=sbr

"""""""""""""""""
" TABS AND SPACES
"""""""""""""""""
set nosmartindent		" explicitly turn off. C-style doesn't work with R comments #
"set smartindent	   " explicitly turn off. C-style doesn't work with R comments #
set nowrap				" do not wrap lines please
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4		" no clue what this does
set shiftround			" if spaces, TAB maps to right spot

" General
set nobackup					" don't let vim backup files
set noswapfile
set nowritebackup				" And again.
set autochdir					" always switch to current dir
set wildmode=list:longest		" Complete files like a shell.
set modeline
set noerrorbells				" No beeping!
set novisualbell				" No flashing either.
set wildignore+=*.jpg,*.gif,*.png,*.git,*.gem,*.zip,*.tar.gz,node_modules,*.pyc

"""""""""""
" UI CONFIG
"""""""""""
let loaded_matchparen=1			" Just use % instead of auto paren matching
set colorcolumn=80				" vertical line at 80 cols
set nostartofline				" Searches leave cursor on same column
set ignorecase					" Case-insensitive searching.
set lazyredraw					" No redraw during macro execution
set number						" Show line numbers.
set shortmess=atIF				" stifle the long interrupt prompts
set showmode					" Display the mode you're in.
set smartcase					" But case-sensitive if has caps
set scrolloff=3					" Show 3 lines around cursor (more context)
set noshowmode					" hide the default mode text (e.g. -- INSERT --)
set splitbelow					" more natural to open new splits below
set splitright					" and to the right
set autowrite                   " autosave before :make
"}}}

" MAPS {{{

" 'space' pages down like LESS does
" nnoremap <space> <c-j>
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
inoremap `` <c-\><c-o>:w<cr>
noremap `` :w<cr>

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
nmap <M-,> <c-w>5<
nmap <M-.> <c-w>5>
nmap <M-w> <c-W>+
nmap <M-s> <c-W>-

" Q for formatting paragraph or selection
vnoremap Q gq
nnoremap Q gqap
nnoremap <C-q> :q<cr>

" Noop remap q for macro recording: I never use it
nnoremap q :x<cr>

" Sane navigation for wrapped lines
nnoremap j gj
nnoremap k gk
"}}}

" TOGGLES {{{

" toggle line wrap
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
"nnoremap vv ^vg_|		 " Select current line, excluding indents (great for copying to clipboard)
"noremap K <Esc>|		 " Disable K from looking stuff up
"noremap H ^|			" Use capital H/L for first/last non-whitespace character on line
"noremap L g_

" split window vertically into two linked columns--very cool
noremap <silent> <leader>vs :<C-u>let @z=&so<CR>:set so=0 noscb<CR>:bo vs<CR>Ljzt:setl scb<CR><C-w>p:setl scb<CR>:let &so=@z<CR>
" map q <Nop>
" I rarely use macros, but I accidentally hit q all the time

"}}}

" NEOVIM terminal commands {{{

if has('nvim')

function! OpenTerminal()
  split term://zsh
  resize 10
endfunction
nnoremap <c-n> :call OpenTerminal()<CR>

cnoremap Wq wq
cnoremap Qa qa

" Easily get out of neovim Terminal mode
tnoremap <Esc> <C-\><C-n>
"tnoremap <Esc><Esc> <C-\><C-n><C-w>k

" " Meta key ⌥	mappings
" tnoremap <M-h> <C-\><C-N><C-w>h
" tnoremap <M-j> <C-\><C-N><C-w>j
" tnoremap <M-k> <C-\><C-N><C-w>k
" tnoremap <M-l> <C-\><C-N><C-w>l
" inoremap <M-h> <C-\><C-N><C-w>h
" inoremap <M-j> <C-\><C-N><C-w>j
" inoremap <M-k> <C-\><C-N><C-w>k
" inoremap <M-l> <C-\><C-N><C-w>l
" nnoremap <M-h> <C-w>h
" nnoremap <M-j> <C-w>j
" nnoremap <M-k> <C-w>k
" nnoremap <M-l> <C-w>l
" nnoremap <M-t> :split term://zsh

au TermOpen * setlocal nonumber norelativenumber
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
endif

"}}}

" Folding {{{

" default to all folds open
set foldlevel=99
highlight folded ctermbg=7 ctermfg=4
set foldmethod=marker
" rlang
" nnoremap <silent> <space> @=(foldlevel('.')?'za':"\<Space>")<CR>
" vnoremap <space> zf
"}}}

" AUTOGROUPS {{{

" https://asciinema.org/a/kE1398clJWRPPhk3lWbtvbanF

" Presentation mode
" use <left> and <right> to navigate the slides
" https://github.com/plasticboy/vim-markdown Makes folds by sections (among many other things)
" https://github.com/junegunn/goyo.vim Distraction-free writing (and reading) in Vim

function! s:enter_presentation()
	" increase conceal level
	set conceallevel=3
	" open first fold
	normal ggzo
	" add navigation
	" C-n next slide
		" zc - close current fold
		" zj - move to the next
		" zo - and open it
		" [z - move to the start of the current fold
		" j  - move the cursor out of the way
	nnoremap <buffer> <right> zczjzo[z<esc>j
	" C-p previous slide
		" zc - close current fold
		" zk - move to the previous
		" zo - and open it
		" [z - move to the start of the current fold
		" j  - move the cursor out of the way
	nnoremap <buffer> <left> zczkzo[zj
endfunction

function! s:exit_presentation()
	" reset conceal level
	set conceallevel=0
	nunmap <buffer> <left>
	nunmap <buffer> <right>
endfunction

autocmd! User GoyoEnter nested call <SID>enter_presentation()
autocmd! User GoyoLeave nested call <SID>exit_presentation()

nnoremap <buffer> <Right> :n<cr>
nnoremap <buffer> <Left> :N<cr>

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

augroup templates
	autocmd!
	autocmd BufNewFile *.html	 0r ~/.config/nvim/templates/template.html
augroup END

augroup asm
    autocmd!
	autocmd BufNewFile,BufReadPost *.s set filetype=asm
	autocmd BufNewFile,BufReadPost *.s let g:rplugin_disabled = 1
augroup END


" Wrapping autocmd in a group per http://bit.ly/15wKRrM
augroup my_au
	autocmd!
	"	 au FileType python setlocal expandtab ts=2 sw=2 sts=2
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


" Remember the cursor position for every file
" function! PositionCursorFromViminfo()
"	  if !(bufname("%") =~ '\(COMMIT_EDITMSG\)') && line("'\"") > 1 && line("'\"") <= line("$")
"		  exe "normal! g`\""
"	  endif
" endfunction
" autocmd BufReadPost * call PositionCursorFromViminfo()

" see :help restore-cursor
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |	exe "normal! g`\""
  \ | endif


" }}}

" Markdown and Word processing mode {{{
" Go into WordProcessorMode when typing Markdown paragraphs: <leader>0
" http://www.drbunsen.org/writing-in-vim/
" Install formd: npm install -g @seth-brown/formd

nnoremap <leader>t0 :silent call WordProcessorMode()
func! WordProcessorMode()
	setlocal tw=80
	setlocal formatoptions=1t
	setlocal noexpandtab
	setlocal spell spelllang=en_us
	set complete+=s
	setlocal wrap
	setlocal linebreak
endfu

nnoremap <silent><leader>vv :Goyo<cr>:set linebreak<cr>:set wrap<cr>

function! Formd(option)
	:let save_view = winsaveview()
	:let flag = a:option
	:if flag == "-r"
		:%! formd -r
	:else
		:%! formd -i
	:endif
	:call winrestview(save_view)
endfunction

" Toggle hyperlinks in Markdown on/off
nnoremap <leader>fi :call Formd("-i")<CR>
nnoremap <leader>fr :call Formd("-r")<CR>

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
" nnoremap <Leader>/ :Ack!<Space>

" Navigate quickfix list with ease
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>

" COLORS {{{

" colorscheme stuff has to go afer plug
" https://github.com/junegunn/vim-plug/wiki/faq#im-getting-cannot-find-color-scheme--does-vim-plug-support-color-schemes

" Set solarized to dark or light depending on what
" iterm profile the session was launched with.

let g:background_light=0
function! SetDefaultSolar()          " ,x toggles dark/light
    if g:background_light == 0
        call SolarDark()
    elseif g:background_light == 1
        call SolarLight()
    endif
    call lightline#colorscheme()
endfunction

function! SetBackgroundDark()
    let g:background_light=0
    colorscheme dracula
    set background=dark
    hi colorcolumn ctermbg=darkgrey
    call lightline#colorscheme()
endfunction

function! SetBackgroundLight()
    let g:background_light=1
    set background=light
    colorscheme alabaster
    hi colorcolumn ctermbg=lightgrey
    call lightline#colorscheme()
endfunction

function! ToggleBackground()
    if g:background_light == 0 | call SetBackgroundLight() | else | call SetBackgroundDark() | endif
endfunction
noremap <leader>tc :call ToggleBackground()<CR>

if has('termguicolors')
	set termguicolors
endif

set background=dark
colorscheme dracula
" hi colorcolumn ctermbg=darkgrey

" Hide the Magenta with ,/
nnoremap <silent> <leader>/ :set hlsearch! hlsearch?<CR>

hi Cursor guifg=green guibg=magenta
hi Cursor2 guifg=red guibg=red

" TODO: fix cursor for insert mode 
"set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50

set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
		  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
		  \,sm:block-blinkwait175-blinkoff150-blinkon175

" }}}

highlight Comment cterm=italic gui=italic
set t_ZH=[3m
set t_ZR=[23m

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

" }}}

"function! UpdateCFlags()
"	let l:pkg_config_files = system("pkg-config --cflags libczmq libzmq protobuf libprotobuf-c fmt CLI11")
"	let g:ale_c_clang_options = l:pkg_config_files
"	let g:ale_c_gcc_options = l:pkg_config_files
"	let g:ale_cpp_cc_options = l:pkg_config_files
"endfunction

""autocmd FileType c call UpdateCFlags()

"let g:ale_c_parse_makefile = 1
"let g:ale_cpp_parse_makefile = 1
"let g:ale_echo_msg_error_str = 'E'
"let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
"let g:ale_echo_msg_warning_str = 'W'
"let g:ale_fixers = { 'javascript': ['eslint'] }
"let g:ale_fix_on_save = 1
""let g:ale_linters = {'c': ['gcc'], 'cpp': ['clang', 'g++'], 'javascript': ['eslint'] }
"let g:ale_linters = {'c': ['gcc'], 'cpp': ['clang', 'g++'], 'python': ['flake8'], 'r': ['lintr'], 'javascript': ['eslint'] }
"let g:ale_cpp_clang_options = '-std=c++20'
"let g:ale_cpp_gcc_options = '-std=gnu++20'
"let g:ale_python_flake8_options = '--max-line-length 88 --extend-ignore=E203'
"let g:ale_sign_error = '>>'
"let g:ale_sign_warning = '--'

let g:csv_default_delim=','

" helper to debug what is setting indent options
command! ShowIndent verbose set et? ts? sw? sts? indentexpr?

" --- tree-sitter config (lua inside init.vim) ---
lua << EOF
require('nvim-treesitter.configs').setup({
  ensure_installed = { "c", "cpp" },   -- grammars you want
  highlight = { enable = true },       -- syntax highlighting
  indent = { enable = false },         -- don't let TS override indent
})
EOF
