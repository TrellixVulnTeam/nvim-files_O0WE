if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

"Plugins ----------------------------------------------------------------------
set nocompatible
filetype off

call plug#begin('~/.local/share/nvim/plugged')

Plug 'preservim/nerdtree'
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
Plug 'ryanoasis/vim-devicons'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'chrisbra/Colorizer'
Plug 'powerline/fonts'
Plug 'ycm-core/YouCompleteMe'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'davidhalter/jedi-vim'
" Plug 'nvie/vim-flake8'
Plug 'Valloric/ListToggle'
Plug 'kien/ctrlp.vim'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'kalekundert/vim-coiled-snake'
Plug 'Konfekt/FastFold'
Plug 'tpope/vim-commentary'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'jeetsukumaran/vim-pythonsense'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-fugitive'
Plug 'ntpeters/vim-better-whitespace'
Plug 'christoomey/vim-tmux-navigator'
Plug 'sheerun/vim-polyglot'
Plug 'alvan/vim-closetag'
Plug 'heavenshell/vim-pydocstring'
Plug 'tpope/vim-repeat'
Plug 'dense-analysis/ale'

call plug#end()

"Remaps -----------------------------------------------------------------------

" Native
inoremap jk <Esc>
inoremap JK <Esc>

nnoremap <silent><A-j> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent><A-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>
nnoremap <silent><A-l> :bnext<CR>
nnoremap <silent><A-h> :bprevious<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

tnoremap <Esc> <C-\><C-n>

map ]f <Plug>(PythonsenseStartOfNextPythonFunction)
map ]F <Plug>(PythonsenseEndOfPythonFunction)
map [f <Plug>(PythonsenseStartOfPythonFunction)
map [F <Plug>(PythonsenseEndOfPreviousPythonFunction)

" Leader
let mapleader=" "
map      <silent><leader>n :NERDTreeToggle<CR>
nmap     <leader>go :Goyo<CR>
nnoremap <leader>gtd :YcmCompleter GoTo<CR>
nnoremap <leader>gtr :YcmCompleter GoToReferences<CR>
nnoremap <leader>gt :YcmCompleter GetType<CR>
nnoremap <leader>gd :YcmCompleter GetDoc<CR>
nnoremap <silent><leader>f za
nnoremap <silent><leader><Space> :set relativenumber!<CR>
noremap <Leader>y "+yg_
noremap <Leader>p "+p
nnoremap <leader>e :call flake8#Flake8ShowError()<CR>
nnoremap <silent><leader><CR> :noh<CR>
nnoremap <silent><leader>t :TagbarToggle<CR>
nnoremap <leader>w :StripWhitespace<CR>
nmap <Leader>b1 <Plug>lightline#bufferline#go(1)
nmap <Leader>b2 <Plug>lightline#bufferline#go(2)
nmap <Leader>b3 <Plug>lightline#bufferline#go(3)
nmap <Leader>b4 <Plug>lightline#bufferline#go(4)
nmap <Leader>b5 <Plug>lightline#bufferline#go(5)
nmap <Leader>b6 <Plug>lightline#bufferline#go(6)
nmap <silent><leader>rn :Semshi rename<CR>
nmap <silent> <Tab> :Semshi goto name next<CR>
nmap <silent> <S-Tab> :Semshi goto name prev<CR>
nmap <Leader>x :call flake8#Flake8UnplaceMarkers()<CR>
nmap <silent> <C-_> <Plug>(pydocstring)


" Plugins Config ---------------------------------------------------------------

" Lightline
let g:lightline = {
		\'colorscheme': 'custom_nord',
		\'active': {
		\	'left': [ [ 'mode', 'paste' ],
		\			  [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
		\	'right':[ [ 'lineinfo' ],
		\			  [ 'totalLines' ],
		\			  [ 'fileencoding', 'filetype' ] ]
		\},
		\'inactive': {
		\	'left': [ ['readonly', 'filename', 'modified'] ],
		\	'right':[ [ 'lineinfo' ],
		\			  [ 'totalLines' ],
		\			  [ 'fileencoding', 'filetype'] ]
		\},
                \'component': {
                \   'totalLines': "%3p%% %{printf('(%03d)', line('$'))}"
                \},
		\'component_function': {
                \   'gitbranch': 'FugitiveHead'
		\},
		\}

let g:lightline#bufferline#show_number  = 2
let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#unnamed      = '[No Name]'
let g:lightline#bufferline#filename_modifier = ':t'

let g:lightline.tabline          = {'left': [['buffers']], 'right': [[]]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}
let g:lightline#bufferline#enable_devicons  = 1
let g:lightline#bufferline#min_buffer_count = 2

" Semshi
let g:semshi#mark_selected_nodes = 0
let g:semshi#error_sign_delay = 4
let g:semshi#error_sign = v:false

" Jedi
let g:jedi#auto_vim_configuration   = 0
let g:jedi#use_splits_not_buffers   = "bottom"
let g:jedi#popup_on_dot			    = 0
let g:jedi#popup_select_first       = 0
let g:jedi#goto_command             = ""
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_stubs_command       = ""
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command    = ""
let g:jedi#usages_command           = ""
let g:jedi#completions_command      = ""
let g:jedi#rename_command           = ""

" indentLine
let g:indentLine_char  = '▏'

" NerdTree
let NERDTreeShowHidden = 1

" Supertab
let g:SuperTabDefaultCompletionType = "<c-n>"

" YCM
let g:ycm_auto_trigger = 1

" ListToggle
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>q'

" Flake8
let g:flake8_show_quickfix  = 0
let g:flake8_show_in_gutter = 1
let g:flake8_show_in_file   = 1
let flake8_error_marker     ='✖'
let flake8_warning_marker   ='!'
hi link Flake8_Error      Error
hi link Flake8_Warning    WarningMsg
hi link Flake8_Complexity WarningMsg
hi link Flake8_Naming     WarningMsg
hi link Flake8_PyFlake    WarningMsg

" Fast fold
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']

" Pydocstring
let g:pydocstring_doq_path = "/home/john/.local/bin/doq"

" ALE
let g:ale_linters = {
      \   'python': ['flake8', 'pylint'],
      \}


" Options ----------------------------------------------------------------------
let $NVIM_TUI_ENABLE_TRUE_COLOR = 1

set 		number
syntax 		on

colorscheme molokai
let s:molokai_original = 0

set 	  colorcolumn=80
highlight LineNr ctermbg=234
highlight Comment gui=bold
highlight MatchParen cterm=none ctermbg=none ctermfg=202
highlight Flake8_Error ctermbg=124
highlight Flake8_Warning ctermbg=142 ctermfg=233
highlight Pmenu ctermfg=15 ctermbg=234 guifg=#bababa guibg=#1f1f1f
highlight ExtraWhitespace ctermbg=235

set completeopt-=preview
set incsearch ignorecase smartcase hlsearch
set noshowmode
set nofoldenable
set foldlevel=1
setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8
set splitbelow
set splitright
set wrap!
set scrolloff=3
set smartcase
set pumheight=15
set nohlsearch
set diffopt+=vertical
set hidden

"Other ------------------------------------------------------------------------
filetype plugin indent on
let g:python3_host_prog = '/usr/bin/python3'
let python_highlight_all = 0
let python_highlight_space_errors = 0

" cmd/func
autocmd VimEnter  * nnoremap <silent><leader>bn :bnext<CR>
autocmd VimEnter  * nnoremap <silent><leader>bd :bd<CR>
autocmd BufEnter  * set foldlevel=1
" autocmd BufWritePost *.py call flake8#Flake8()
autocmd BufRead,BufNewFile *.py let python_highlight_all=1
autocmd VimEnter * call SetColors()
autocmd FileType qf call AdjustWindowHeight(3, 10)
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
autocmd FileType python setlocal indentkeys-=<:>
autocmd FileType python setlocal indentkeys-=:


function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

function! SetColors()
    hi semshiLocal           ctermfg=209
    hi semshiGlobal          ctermfg=172
    hi semshiImported        ctermfg=172    guifg=#CC7E00
    hi semshiParameter       ctermfg=75
    hi semshiParameterUnused ctermfg=117
    hi semshiFree            ctermfg=84
    hi semshiBuiltin         ctermfg=112
    hi semshiAttribute       ctermfg=49
    hi semshiSelf            ctermfg=249
    hi semshiUnresolved      ctermfg=226
    hi semshiSelected        ctermfg=231

    hi semshiErrorSign       ctermfg=231
    hi semshiErrorChar       ctermfg=231
    sign define semshiError text=E texthl=semshiErrorSign


    if g:colors_name ==# "molokai"
        set cursorline
        hi CursorLine            guibg=#070707
        hi Normal                guibg=#090909
        hi MatchParen            gui=none       guibg=none      guifg=#BF4900
        hi LineNr                guibg=#121212  guifg=#5E5E5E
        hi Comment               guibg=none     guifg=#343434
        hi ExtraWhitespace       guibg=#292929
        hi ColorColumn           guibg=#070707
        hi Visual                guibg=#4A4A4A
        " hi Error                 guibg=#FFFFFF
        hi WarningMsg            guibg=#9FA317  guifg=#1f1f1f
    endif

endfunction

