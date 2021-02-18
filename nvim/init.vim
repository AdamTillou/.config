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

" Initialize leader mappings
call leader#Initialize()

" Initialize plugins
" Add plugins to runtime path " {{{1
call plug#begin(g:init#config . "/plugins")
" Completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }

" Snippets
Plug 'sirver/UltiSnips'

" Show syntax errors
Plug 'dense-analysis/ale'

" Graphical debugger
Plug 'puremourning/vimspector'

" Window manager
Plug 'AdamTillou/vim-wm'

" File tree
Plug 'AdamTillou/vim-filetree'

" Images
Plug 'AdamTillou/vim-imager'

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

" Latex preview
Plug 'xuhdev/vim-latex-live-preview', { 'on': 'LLPStartPreview' }

" Detect indent width
Plug 'ciaranm/detectindent'

" Cheat.sh
Plug 'dbeniamine/cheat.sh-vim'

" Tables
Plug 'dhruvasagar/vim-table-mode'

" Layout
Plug 'AdamTillou/wysiwyg.vim'
call plug#end() " }}}
call plugins#Initialize()

" Finish
let g:init#loaded = 1
