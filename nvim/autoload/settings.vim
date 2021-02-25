" ==============================================================================
" Filename:     settings.vim
" Description:  Basic vim preferences
" Author:       Adam Tillou
" ==============================================================================

function! settings#Initialize()
	" Set basic preferences
	set number " Show line numbers
	set nocursorline " Don't highlight the current line
	set showcmd " Show the letters being typed
	set scrolloff=1000 " Keep the cursor in the center of the screen
	set laststatus=1 " Show the statusline for all windows if multiple are open
	set noswapfile " Disable swap files
	set nowrap " Don't wrap lines that extend beyond the window width
	set noexpandtab " Use tabs instead of spaces for indents
	set autoindent " Automatically indent new line to expected amount
	set confirm " If a command requires an !, ask instead of returning an error
	set list " Show hidden characters
	set ve+=onemore " Allow the cursor to sit after the last character in the line
	set signcolumn=yes " Always show the sign column
	set completeopt=menuone,noinsert " Show the autocomplete menu even if there is only 1 option
	set hidden " Unload empty buffers when they are hidden
	let mapleader='|'

	" Enable concealing
	set conceallevel=1
	set concealcursor=nvic

	" Save words to a spellfile, but don't enable spelling by default
	execute 'set spellfile=' . g:init#config . '/files/spellfile.add'
	set nospell

	" Set gui specific options
	set guifont=FiraCode:h11 " Set the default font for gui mode
	set linespace=3 " Set the spacing between each line

	" Set default foldmethod to indent, with folds always open
	set foldmethod=indent
	set foldlevel=100

	" Ignore cases in search, unless the search term contains an uppercase
	set ignorecase
	set smartcase

	" Search normally
	set noincsearch
	set nohlsearch

	" Automatically create splits after and below the current file
	set splitbelow
	set splitright

	" Set the tab width to 2
	set shiftwidth=2
	set tabstop=2

	" Set file locations
	set undodir=~/.cache/nvim/undo
	set viminfo+=n~/.cache/nvim/viminfo

	" Other important settings
	set undofile " Remember undo history
	set lazyredraw " Don't redraw the screen in the middle of a function

	" Set special characters
	set fillchars=vert:\│

	set listchars=eol:↲,tab:\ \ 

	" Set gui options
	if exists("g:neovide") && g:neovide
		let g:neovide_cursor_animation_length = 0
	endif

	" Reload stubborn settings when entering a python file
	autocmd BufWinEnter *.py setlocal noexpandtab | setlocal shiftwidth=2 | setlocal tabstop=2

	" Load syntax file for notes
	autocmd BufWinEnter *.note exec 'source ' . g:init#config . '/syntax/note.vim'
endfunction
