" ==============================================================================
" Filename:     init.vim
" Description:  Configures various elements of nvim
" Author:       Adam Tillou
" ==============================================================================

"let already_loaded = 0

" Set up runtimepath
set runtimepath=''
let g:init#config = expand('<sfile>:p:h')
let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)
let &runtimepath = printf('%s,%s,%s/after', g:init#config, &runtimepath, g:init#config)
"
"" Set leader key
let mapleader="'"

" Initialize basic settings
call settings#Initialize()

" Initialize colors
call colors#Initialize()

" Initialize mappings
call mappings#Initialize()

" Initialize the statusline
call statusline#Initialize()

" Initialize functions
call functions#Initialize()

" Initialize plugins
" Add plugins to runtime path " {{{1
call plug#begin(g:init#config . "/plugins")
" Completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }

" Snippets
Plug 'sirver/UltiSnips'
Plug 'honza/vim-snippets'

" Show syntax errors
Plug 'dense-analysis/ale'

" Graphical debugger
Plug 'puremourning/vimspector'

" Window manager
Plug 'AdamTillou/vim-wm'

" File tree
Plug 'AdamTillou/vim-filetree'

" Undo tree
Plug 'simnalamburt/vim-mundo'

" Highlight hex codes with the corresponding color
Plug 'ap/vim-css-color'

" Multiple cursors
Plug 'terryma/vim-multiple-cursors'

" File overview
Plug 'vim-scripts/taglist.vim'

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
call plug#end() " }}}
call plugins#Initialize()

" Initialize leader mappings
call leader#Initialize()

" Finish
let already_loaded = 1
