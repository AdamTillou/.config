" ==============================================================================
" Filename:     init.vim
" Description:  Configures various elements of nvim
" Author:       Adam Tillou
" ==============================================================================

let already_loaded = 0

" Set up runtimepath
set runtimepath=''
let g:config_path = expand('<sfile>:p:h')
let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)
let &runtimepath = printf('%s,%s,%s/after', g:config_path, &runtimepath, g:config_path)

" Set leader key
let mapleader="'"

" Initialize basic settings
call settings#Initialize()

" Initialize colors
call colors#Initialize()

" Initialize mappings
call mappings#Initialize()

" Initialize functions
call functions#Initialize()

" Initialize plugins
" Add plugins to runtime path " {{{1
call plug#begin(g:config_path . "/plugins")
" Show syntax errors
Plug 'dense-analysis/ale'

" Autocompletion
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'

" Git changes
Plug 'airblade/vim-gitgutter'

" Git commands
Plug 'tpope/vim-fugitive'

" Highlight hex codes with the corresponding color
Plug 'ap/vim-css-color'

" Multiple cursors
Plug 'terryma/vim-multiple-cursors'

" Statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Snippets
Plug 'sirver/UltiSnips'
Plug 'honza/vim-snippets'

" Undo tree
Plug 'simnalamburt/vim-mundo'

" File overview
Plug 'vim-scripts/taglist.vim'

" File tree
Plug 'AdamTillou/vim-filetree'

" NCM2 completion sources
Plug 'ncm2/ncm2-bufword' " Words in buffer
Plug 'ncm2/ncm2-clang' " C languages
Plug 'ncm2/ncm2-jedi' " Python
Plug 'ObserverOfTime/ncm2-jc2', {'for': ['java', 'jsp']} " Java
Plug 'artur-shaik/vim-javacomplete2', {'for': ['java', 'jsp']} " Java
call plug#end() " }}}
call plugins#Initialize()

" Finish
let already_loaded = 1
