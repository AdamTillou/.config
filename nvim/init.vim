" =============================================================================
" Filename:			init.vim
" Description:	Configures various elements of nvim
" Author:				Adam Tillou
" ==============================================================================

" Basic settings {{{1
let already_loaded = 0

set number
set nocursorline
set showcmd
set scrolloff=1000
set shiftwidth=2
set tabstop=2
set autoindent
set hidden
set ignorecase
set nowrap
set undofile
set noexpandtab
set foldmethod=indent
set list
set noincsearch
set nohlsearch
set lazyredraw
set laststatus=0
set splitbelow
set splitright
set ve+=onemore
set fillchars=vert:\│
set listchars=eol:↲,tab:│\ 
let loaded_matchparen = 1
let mapleader="'"

" Set file locations
set runtimepath=''
let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)
let s:portable = expand('<sfile>:p:h')
let &runtimepath = printf('%s,%s,%s/after', s:portable, &runtimepath, s:portable)
set undodir=~/.cache/nvim/undo
set viminfo+=n~/.cache/nvim/viminfo

let g:mappings = []

" Set colors
set t_Co=256
syntax on
filetype plugin on
colorscheme superman

" }}}
" Basic mappings {{{1
" Movement mappings {{{2
" Set hjkl movements to not quit other mappings when going off an edge
noremap <expr> h col('.')==1 ? '' : 'h'
noremap <expr> l col('.')==col('$') ? '' : 'l'
noremap <expr> j line('.')==line('$') ? '' : 'j'
noremap <expr> k line('.')==1 ? '' : 'k'

" Set magnified hjkl movements
noremap H 4h
noremap L 4l
noremap J 4j
noremap K 4k

" Make g+movements go to the ends of the line/document
noremap gh 0
noremap gl $l
noremap gj G
noremap gk gg

" Map < and > to go forward and backward through jumps
nnoremap < <C-o>
nnoremap > <C-i>

" }}}
" Text modification mappings {{{2
nnoremap x "_x
nnoremap z "_X
nnoremap <expr> X col('.')==col('$') ? '' : '"_de'
nnoremap <expr> Z col('.')==1 ? '' : '"_db'

nnoremap d "_d
nnoremap D "_dd
nnoremap dd 0"_d$

nnoremap c "_c
nnoremap C "_cc

nnoremap s d
nnoremap S dd
nnoremap ss 0d$

nnoremap Y yy 
nnoremap yy mz0y$`z

vnoremap c "_c
vnoremap x "_d
vnoremap d "_d
vnoremap s d

" Map g+key to add to the register
nnoremap gy "Zy
nnoremap gY "Zyy

nnoremap gs "Zd
nnoremap gS "Zdd

nnoremap gp "zp
nnoremap gP "zP

nnoremap gyc :silent let @z = ""<CR>

" Map leader+key to use the system register
nnoremap <leader>y "+y
nnoremap <leader>Y "+yy
vnoremap <leader>y "+y

nnoremap <leader>s "+d
nnoremap <leader>S "+dd
vnoremap <leader>s "+d

nnoremap <leader>p "+p
nnoremap <leader>P "+P

" }}}
" Motion mappings {{{2
" Map v to select entire words
onoremap v aw
onoremap V aW

" Map b and m to select to the beginning/end of the line
onoremap b 0
onoremap m $

" }}}
" Buffer mappings {{{2
noremap ( :bp!<CR>
noremap ) :bn!<CR>

" Map C-hjkl to move around buffers
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Open a new split window
noremap <C-w>v :vnew<CR>
noremap <C-w>n :new<CR>

" Tab mappings
noremap <C-w>t :tabnew<CR>
noremap <C-w>] :tabnext<CR>
noremap <C-w>[ :tabprev<CR>

" Map Ctrl [ and ] to resize the current buffer
noremap <nowait> _ :resize -1<CR>
noremap <nowait> + :resize +1<CR>
noremap <nowait> - :vertical resize -2<CR>
noremap <nowait> = :vertical resize +2<CR>

" Map Ctrl + w + d to delete the buffer without deleting the window
noremap <expr> <C-w>d (&mod == 0) ? ":let delbuf=bufnr('%')<CR>:bp<CR>:exec delbuf . 'bd'<CR>" : ":echo 'Current buffer has unsaved changes.'<CR>"
noremap <C-w>D :let delbuf=bufnr('%')<CR>:bp!<CR>:exec delbuf . "bd!"<CR>

" Map Ctrl + w + c to close the window without deleting the buffer
noremap <C-w>c :close!<CR>

" Sliding tab mappings
"noremap <C-]> :call TabScroll("next")<CR>
"noremap <C-[> :call TabScroll("prev")<CR>

" }}}
" Useful mappings {{{2
" Map leader+q to macros and q to esc
noremap q <Nop>
noremap Q q

" Map <Esc> to stay on the same character
inoremap <expr> <Esc> col('.')==1 ? '<Esc>' : '<Esc>l'

" Map Alt+q to esc
nnoremap <M-q> <Esc>l
inoremap <M-q> <Esc>l
cnoremap <M-q> <Esc>l
vnoremap <M-q> <Esc>l
nnoremap <M-Q> <Esc>l
inoremap <M-Q> <Esc>l
cnoremap <M-Q> <Esc>l
vnoremap <M-Q> <Esc>l

" Map U to redo
nnoremap U <C-r>

" Map regular i and a to go before/after visual selections
vnoremap i I
vnoremap a A

" Map g+>/< to increment/decrement a number
noremap g> <C-a>
noremap g< <C-x>

" Map tab and shift tab to indent
nnoremap <Tab> mz>>`z
nnoremap <S-Tab> mz<<`z
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
inoremap <S-Tab> <Esc>mz<<`za

" Map space to toggle the current fold
nnoremap <Space> za

" Map enter to create a new line in normal mode
nnoremap <CR> o0"_d$

" Disable comment spreading
nnoremap o A-<Esc>^"_d$A
nnoremap O O-<Esc>^"_d$A
inoremap <CR> <CR>-<Esc>^"_d$A

" Map M to merge 2 lines
nnoremap M J

" Map gz to folds
nnoremap gz z
nnoremap gzO 100zo
nnoremap gzC 100zc

" }}}
" File related mappings {{{2
" Map Ctrl+S to save
noremap <C-s> <Esc>:w<CR>

" Map Ctrl+X to exit
noremap <C-x> <Esc>:wa<CR>:qa<CR>

" Map Ctrl+Q to quit
noremap <C-q> <Esc>:q<CR>

" Map Ctrl+R to reload the config file
noremap <C-r> mz:source ~/.config/nvim/init.vim<CR>:edit<CR>`z

" Map Ctrl+o to open a file search window
nnoremap <C-o> :Files<CR>

" Map Ctrl+f to show the filetree
nnoremap <silent> <C-f> :echo ""<CR>:call sidebar#Open("filetree")<CR>

" }}}
" }}}
" Insert mode mappings {{{1
" Movement mappings {{{2
map! <A-h> <Left>
map! <A-j> <Down>
map! <A-k> <Up>
map! <A-l> <Right>
map! <A-H> <Left><Left><Left><Left>
map! <A-J> <Down><Down><Down><Down>
map! <A-K> <Up><Up><Up><Up>
map! <A-L> <Right><Right><Right><Right>
imap <M-w> <Esc>wi
imap <M-W> <Esc>Wi
imap <M-e> <Esc>ea
imap <M-E> <Esc>Ea

" Text modification mappings {{{2
imap <M-d> <Esc>ddi
imap <M-s> <Esc>dsi
imap <M-v> <Esc>dvi
imap <M-V> <Esc>dVi
imap <M-y> <Esc>yyi
imap <M-c> <Esc>yypi
imap <M-C> <Esc>yyPi
imap <M-p> <Esc>pa
imap <M-P> <Esc>Pa
imap <M-u> <Esc>ui
imap <M-U> <Esc>Ui
imap <M-x> <Esc>xi
imap <M-X> <Esc>Xi
imap <M-z> <Esc>zi
imap <M-Z> <Esc>Zi
imap <M-> <Esc><CR>i

" Adding folds {{{2
imap <M-f>1 <Esc>A {<Right>{{1<CR><CR>" }<Right>}}<Up>
imap <M-f>2 <Esc>A {<Right>{{2<CR><CR>" }<Right>}}<Up>
imap <M-f>3 <Esc>A {<Right>{{3<CR><CR>" }<Right>}}<Up>
imap <M-f>4 <Esc>A {<Right>{{4<CR><CR>" }<Right>}}<Up>
imap <M-f>5 <Esc>A {<Right>{{5<CR><CR>" }<Right>}}<Up>

" Pair autocompletion {{{2
imap <M-(> ()<Left>
imap <M-{> {}<Left>
imap <M-[> []<Left>
imap <M-"> ""<Left>
imap <M-'> ''<Left>
imap <M-<> <><Left>

" }}}
" Returning to normal mode {{{2
nnoremap <M-q> <Esc>l
inoremap <M-q> <Esc>l
vnoremap <M-q> <Esc>l
cnoremap <M-q> <Esc>l
" }}}
" }}}
" Leader mappings {{{1
" Settings mappings {{{2
	" Set the folding method
	noremap <leader>sfi :setlocal foldmethod=indent<CR>
	noremap <leader>sfb :setlocal foldmethod=marker<CR>
	noremap <leader>sfm :setlocal foldmethod=manual<CR>
	noremap <leader>sfs :setlocal foldmethod=syntax<CR>

	" Toggle showing special characters
	noremap <leader>sl :setlocal list!<CR>

" }}}
" Inserting text {{{2
" Map leader+i+l to insert a better horizontal line
nnoremap <leader>il i│<Esc>l

" Map leader+i+# to insert a comment heading
nnoremap <leader>i# i#<Esc>yl79pyypO# <Esc>yl77pi##<Esc>03lR

" Useful commands {{{2
" Map leader+;+s to run the substitute command
nnoremap <leader>cs :%s///g<Left><Left><Left>
vnoremap <leader>cs :s/\%V//g<Left><Left><Left>
vnoremap / /\%V
" }}}
" Misc {{{2
" Map leader+f to format the file
nnoremap <leader>f mzgg=G`z
" }}}
" }}}
" Plugins {{{1
call plug#begin('~/.config/nvim/autoload/')

" Sidebar: Various functions {{{2
"Plug 'vim-sidebar/sidebar'

let &rtp .= "," . expand("~/Documents/Vim Plugins/sidebar.vim")

" }}}
" You Complete Me: Code autocompletion {{{2
Plug 'ycm-core/YouCompleteMe'

" }}}
" Syntastic: Error checking {{{2
Plug 'vim-syntastic/syntastic'

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" }}}
" FZF: Fuzzy search {{{2
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

let $FZF_DEFAULT_COMMAND="find ~ -type f | grep -v 'undo'"
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let height = &lines * 5 / 6
  let width = &columns * 2 / 3
  let horizontal = &columns / 6
  let vertical = &lines / 12

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction

" }}}
" CSS Color: Highlight hex codes with corresponding color {{{2
Plug 'ap/vim-css-color'

" }}}

call plug#end()
" }}}
" Useful functions {{{1
" Get the character under the cursor {{{2
function! Getchar()
	return strcharpart(strpart(getline('.'), col('.') - 1), 0, 1)
endfun

" }}}
" Open a floating window in the center of the screen {{{2
function! FloatingWindow()
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction

" }}}
" Open help menu in floating window {{{2
command! -nargs=1 H call Help("<args>")

function! Help(term)
	let origional_name = @%
	exec "help " . a:term
	let help_line = line(".")
	let help_path = expand("%:p")

	if @% == origional_name
		return 0
	else
		bdelete
	endif

	call FloatingWindow()
	exec "e " . help_path
	call cursor(help_line, 0)
	noremap <buffer> <Esc> :bd!<CR>:q<CR>
	noremap <buffer> <C-q> :bd!<CR>:q<CR>
endfunction

" }}}
" Show animation when switching tabs {{{2
function! TabScroll(dir)
	let current_tab = GetDisplayedLines()
	exec "tab" . a:dir
	let new_tab = GetDisplayedLines()
	let real_buffer = bufnr()
	enew
	setlocal nowrap
	setlocal foldmethod=manual
	let temp_buffer = bufnr()

	for i in range(&lines - 1)
		put =0
	endfor
	call cursor(1, 1)

	let redraws = 80
	let total_time = 200
	for i in range(redraws)
		for j in range(&lines)
			let current_line = (len(current_tab) > j ? current_tab[j] : repeat(" ", &columns))
			let new_line = (len(new_tab) > j ? new_tab[j] : repeat(" ", &columns))
			let full_line = a:dir == "next" ? (current_line . new_line) : (new_line . current_line)
			let truncate_chars = a:dir == "next" ? ((i * &columns) / redraws) : (&columns - ((i * &columns) / redraws))
			let truncated_line = full_line[truncate_chars:-1]
			call setline(j + 1, truncated_line)
		endfor

		redraw
		exec "sleep " . (total_time / redraws) . "m"
	endfor

	silent exec real_buffer . "buffer"
	silent exec temp_buffer . "bdelete!"
endfunction

" }}}
" Get a list of lines of the current window {{{2
function! GetDisplayedLines()
	let real_scrolloff = &scrolloff
	let real_cursor = [line("."), col(".")]

	set scrolloff=0
	norm! H
	let top_line = line(".")
	call cursor(real_cursor)
	norm! L
	let bottom_line = line(".")
	call cursor(real_cursor)
	exec "set scrolloff=" . real_scrolloff

	let line_list = []
	for i in range(top_line, bottom_line)
		let add_line = substitute(substitute(getline(i), "\n", "", "g"), "	", "  ", "g")
		let add_line = add_line . repeat(" ", &columns - len(add_line))
		
		call add(line_list, add_line)
	endfor

	return line_list
endfunction

" }}}
" }}}
" GUI Options {{{1
if exists("g:gnvim")
	set guifont=Inconsolata\ Semicondensed:h13
	set fillchars=vert:\ 
endif

" }}}
" Set status to loaded {{{1
let already_loaded = 1

" }}}
