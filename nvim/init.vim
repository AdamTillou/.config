" ==============================================================================
" Filename:     init.vim
" Description:  Configures various elements of nvim
" Author:       Adam Tillou
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
set paste
set noexpandtab
set foldmethod=indent
set nolist
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
nnoremap dd ^"_d$

nnoremap c "_c
nnoremap C "_cc

nnoremap s d
nnoremap S dd
nnoremap ss ^d$

" Make the numbered registers hold the previous values of the main register
command! YankShift if @1 != @" | for i in range(8) | exec ("let @" . (9 - i) . " = @" . (8 - i)) | endfor | let @1 = @" | endif

nnoremap <silent> Y yy
nnoremap <silent> yy mz^y$`z

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

" Map v to modify entire words
onoremap v aw
onoremap V aW

" Map z and x to go to the beginning and ends of lines
onoremap z 0
onoremap x $
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
"noremap <nowait> _ :resize -1<CR>
"noremap <nowait> + :resize +1<CR>
"noremap <nowait> - :vertical resize -2<CR>
"noremap <nowait> = :vertical resize +2<CR>

" Map Ctrl + w + d to delete the buffer without closing the window
noremap <C-w>d :let delbuf=bufnr('%')<CR>:bp!<CR>:exec delbuf . "bd!"<CR>

" Map Ctrl + w + c to close the window without deleting the buffer
noremap <expr> <C-w>c @% == "" ? ":bdelete<CR>" : ":close!<CR>"

" Sliding tab mappings
"noremap <C-]> :call TabScroll("next")<CR>
"noremap <C-[> :call TabScroll("prev")<CR>
" }}}
" Useful mappings {{{2
" Map leader+q to macros and q to esc
noremap q <Nop>
noremap <leader>q q

" Make F1 not bring up help menu
noremap <F1> <Nop>
noremap <M-F1> <Nop>

" Map <Esc> to stay on the same character
inoremap <expr> <Esc> col('.')==1 ? '<Esc>' : '<Esc>l'

" Map Alt+q to esc
nnoremap <A-q> <Esc>l
inoremap <A-q> <Esc>l
cnoremap <A-q> <Esc>l
vnoremap <A-q> <Esc>l
nnoremap <A-Q> <Esc>l
inoremap <A-Q> <Esc>l
cnoremap <A-Q> <Esc>l
vnoremap <A-Q> <Esc>l

" Map U to redo
nnoremap U <C-r>

" Map regular i and a to go before/after visual selections
vnoremap i I
vnoremap a A

" Map g+>/< to increment/decrement a number
noremap g> <C-a>
noremap g< <C-x>

" Map tab and shift tab to indent
nnoremap } mz>>`z
nnoremap { mz<<`z
vnoremap } >gv
vnoremap { <gv

" Map space to toggle the current fold
nnoremap <Space> za

" Map Enter to create a new blank line in normal mode
nnoremap <CR> o

" Map M to merge two lines since J is already mapped
nnoremap M J

" Map gz to folds
nnoremap gz z
nnoremap gzO 100zo
nnoremap gzC 100zc
nnoremap gzj ]z$l
nnoremap gzk [z$l
" }}}
" File related mappings {{{2
" Map Ctrl+S to save
noremap <silent> <C-s> <Esc>:w<CR>

" Map Ctrl+X to exit
noremap <C-x> <Esc>:wa<CR>:qa<CR>

" Map Ctrl+Q to quit
noremap <C-q> <Esc>:q<CR>

" Map Ctrl+R to reload the config file
noremap <silent> <C-r> mz:source ~/.config/nvim/init.vim<CR>:edit<CR>`z

" Map F4 to force quit
nnoremap <silent> <F4> :qa!<CR>

" Map Ctrl+f to show the filetree
nnoremap <silent> <C-f> :call filetree#Initialize()<CR>
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
imap <A-w> <Esc>wi
imap <A-W> <Esc>Wi
imap <A-e> <Esc>ea
imap <A-E> <Esc>Ea

" Text modification mappings {{{2
imap <A-d> <Esc>ddi
imap <A-s> <Esc>dsi
imap <A-v> <Esc>dvi
imap <A-V> <Esc>dVi
imap <A-y> <Esc>yyi
imap <A-c> <Esc>yypi
imap <A-C> <Esc>yyPi
imap <A-p> <Esc>pa
imap <A-P> <Esc>Pa
imap <A-u> <Esc>ui
imap <A-U> <Esc>Ui
imap <A-x> <Esc>xi
imap <A-X> <Esc>Xi
imap <A-z> <Esc>zi
imap <A-Z> <Esc>Zi
imap <BS> <A-z>
imap <A-> <Esc><CR>i
inoremap <A-]> <Esc>mz>>`za
inoremap <A-[> <Esc>mz<<`za

" Adding folds {{{2
imap <A-f> <Esc>A{<Right>{{<CR><CR>" }<Right>}}<Up>
imap <A-f>0 <Esc>A{<Right>{{<CR><CR>" }<Right>}}<Up>
imap <A-f>1 <Esc>A{<Right>{{1<CR><CR>" }<Right>}}<Up>
imap <A-f>2 <Esc>A{<Right>{{2<CR><CR>" }<Right>}}<Up>
imap <A-f>3 <Esc>A{<Right>{{3<CR><CR>" }<Right>}}<Up>
imap <A-f>4 <Esc>A{<Right>{{4<CR><CR>" }<Right>}}<Up>
imap <A-f>5 <Esc>A{<Right>{{5<CR><CR>" }<Right>}}<Up>

" Returning to normal mode {{{2
nnoremap <A-q> <Esc>l
inoremap <A-q> <Esc>l
vnoremap <A-q> <Esc>l
cnoremap <A-q> <Esc>l
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
" }}}
" Getting values {{{2
map <leader>gc :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
			\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
			\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
" }}}
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
" Vim Plug: Install other plugins {{{2
let &rtp .= "," . expand("~/Documents/VimPlugins/vim-filetree")

call plug#begin('~/.config/nvim/autoload/')
" Debugging
Plug 'puremourning/vimspector'

" Show syntax errors
Plug 'dense-analysis/ale'

" Autocompletion
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'

" Autocompletion sources
Plug 'ncm2/ncm2-bufword' " Words in buffer
Plug 'ncm2/ncm2-clang' " C languages
Plug 'ncm2/ncm2-jedi' " Python
Plug 'ObserverOfTime/ncm2-jc2', {'for': ['java', 'jsp']} " Java
Plug 'artur-shaik/vim-javacomplete2', {'for': ['java', 'jsp']} " Java

" Highlight hex codes with the corresponding color
Plug 'ap/vim-css-color'

" Multiple cursors
Plug 'terryma/vim-multiple-cursors'

" Status line
Plug 'vim-airline/vim-airline'

" Snippets
Plug 'sirver/UltiSnips'
Plug 'honza/vim-snippets'

" Undo tree
Plug 'simnalamburt/vim-mundo'

" File overview
Plug 'vim-scripts/taglist.vim'
call plug#end()
" }}}
" Vim-WM: Managing windows {{{2
let &rtp .= "," . expand("~/Documents/VimPlugins/vim-wm")

"Enable windows
call windows#WindowManagerEnable()

" Set special colors
let g:wm_sidebar_color = g:colors.sidebar
let g:wm_window_color = g:colors.bg

" Set keybindings
nnoremap <silent> <nowait> <C-w>c :WindowClose<CR>
nnoremap <silent> <nowait> <C-w>r :WindowRender<CR>

nnoremap <silent> <nowait> <A-j> :WindowMoveDown<CR>
nnoremap <silent> <nowait> <A-k> :WindowMoveUp<CR>
nnoremap <silent> <nowait> <A-h> :WindowMoveLeft<CR>
nnoremap <silent> <nowait> <A-l> :WindowMoveRight<CR>

nnoremap <silent> <nowait> <A-S-j> :WindowSplitDown<CR>
nnoremap <silent> <nowait> <A-S-k> :WindowSplitUp<CR>
nnoremap <silent> <nowait> <A-S-h> :WindowSplitLeft<CR>
nnoremap <silent> <nowait> <A-S-l> :WindowSplitRight<CR>

nnoremap <silent> <nowait> = :WindowResizeHorizontal 0.015<CR>
nnoremap <silent> <nowait> - :WindowResizeHorizontal -0.015<CR>
nnoremap <silent> <nowait> + :WindowResizeVertical 0.025<CR>
nnoremap <silent> <nowait> _ :WindowResizeVertical -0.025<CR>

nnoremap <silent> <nowait> <C-w>S :SidebarToggleOpen<CR>
nnoremap <silent> <nowait> <C-w>s :SidebarToggleFocus<CR>

" Create sidebars
call add(g:wm_sidebar.bars, {"name":"filetree", "command":"call filetree#Initialize()"})
call add(g:wm_sidebar.bars, {"name":"taglist", "command":"Tlist"})
call add(g:wm_sidebar.bars, {"name":"mundo", "command":"MundoToggle"})

" Custom sidebar keybindings
nnoremap <silent> <F1> :SidebarOpen filetree<CR>
nnoremap <silent> <F2> :SidebarOpen taglist<CR>
nnoremap <silent> <F3> :SidebarOpen mundo<CR>
" }}}
" ALE: Error checking {{{2
let g:ale_sign_column_always = 1
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'

nnoremap <silent> <leader>e :ALENextWrap<CR>

" Change highlighting colors of errors and warnings
highlight def link ALEError Error 
highlight def link ALEWarning Warning
exec "highlight Todo ctermbg=" . g:colors.bg.cterm . " ctermfg=" . g:colors.bg.cterm

" Automatically update while typing in insert mode
" autocmd CursorMovedI * call feedkeys("i")
" }}}
" NCM2: Autocompletion {{{2
" Load autocompletion sources
set completeopt=noinsert,menuone,noselect

" Enable ncm2 by default in each new buffer
let ncm2_enabled = {}

let ncm2_enabled.1 = 1
call ncm2#enable_for_buffer()

autocmd BufNew * let ncm2_enabled[bufnr('.')] = 1
autocmd BufNew * call ncm2#enable_for_buffer()

" Let leader+s+a toggle ncm2
nnoremap <silent> <leader>sa :if ncm2_enabled[bufnr('.')] \| call ncm2#disable_for_buffer() \| else \| call ncm2#enable_for_buffer() \| endif
			\:let ncm2_enabled[bufnr('.')] = !ncm2_enabled[bufnr('.')]

	inoremap <expr> <A-j> pumvisible() ? "<C-n>" : "<Down>"
	inoremap <expr> <A-k> pumvisible() ? "<C-p>" : "<Up>"

	let g:ncm2#complete_length = 1
	" }}}
	" UltiSnips: Custom snippets {{{2
	let g:UltiSnipsExpandTrigger = "<Tab>"
	let g:UltiSnipsJumpForwardTrigger = "<Tab>"
	let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
	let g:UltiSnipsListSnippets = "<F2>"

	" Add snippets to autocomplete
	let ncm2_ultisnips_source = {
				\ 'name': 'Snippets',
				\ 'complete_length': 1,
				\ 'matcher': 'prefix',
				\ 'mark': 'S',
				\ 'priority': 9,
				\ 'on_complete': {c -> ncm2#complete(c,
				\       c.startccol, [])}
				\ }
	call ncm2#register_source(ncm2_ultisnips_source)

	autocmd BufEnter * call g:UltisnipsAutocomplete()

	let g:filetype_snippets = {}
	function! g:UltisnipsAutocomplete()
		let name_split = split(@%, "\\.")
		if @% == "" || len(name_split) == 1
			let extension = ""
		else
			let extension = name_split[-1]
		endif


		if has_key(g:filetype_snippets, extension)
			let snippet_list = g:filetype_snippets

		else
			call UltiSnips#SnippetsInCurrentScope(1)
			let output = g:current_ulti_dict_info
			let snippet_names = keys(output)
			let snippet_list = []
			for q in snippet_names
				let dict = {"word":q, "menu":output[q].description}
				call add(snippet_list, dict)
			endfor
			let g:filetype_snippets[extension] = snippet_list
		endif

		call ncm2#override_source('Snippets', {'on_complete': {c -> ncm2#complete(c, c.startccol, snippet_list)}})
	endfunction
	" }}}
	" Multiple Cursors: Edit multiple locations simultaneously {{{2
	" Set custom mappings
	let g:multi_cursor_use_default_mappings = 0
	let g:multi_cursor_start_key = '<leader>ms'
	let g:multi_cursor_select_all_word_key = '<leader>ma'
	let g:multi_cursor_start_word_key = '<leader>mw'
	let g:multi_cursor_select_all_key = '<leader>mA'
	let g:multi_cursor_next_key = '<leader>mn'
	let g:multi_cursor_prev_key = '<leader>mp'
	let g:multi_cursor_quit_key = '<Esc>'
	" }}}
	" Vimspector: Debugging {{{2
	let g:vimspector_install_gadgets = [ 'debugpy' ]

	nmap <leader>vv <Plug>VimspectorContinue
	nmap <leader>vs <Plug>VimspectorStop
	nmap <leader>vr <Plug>VimspectorRestart
	nmap <leader>vp <Plug>VimspectorPause
	nmap <leader>vb <Plug>VimspectorToggleBreakpoint
	nmap <leader>vc <Plug>VimspectorToggleConditionalBreakpoint
	nmap <leader>vf <Plug>VimspectorAddFunctionBreakpoint
	nmap <leader>vo <Plug>VimspectorStepOver
	nmap <leader>vi <Plug>VimspectorStepInto
	nmap <leader>ve <Plug>VimspectorStepOut
	nmap <leader>vu <Plug>VimspectorRunToCursor
	" }}}
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
	" Java Imports {{{2
	noremap <F5> :call JavaInsertImport()<CR>
	function! JavaInsertImport()
		exe "normal mz"
		let cur_class = expand("<cword>")
		try
			if search('^\s*import\s.*\.' . cur_class . '\s*;') > 0
				throw getline('.') . ": import already exist!"
			endif
			wincmd }
			wincmd P
			1
			if search('^\s*public.*\s\%(class\|interface\)\s\+' . cur_class) > 0
				1
				if search('^\s*package\s') > 0
					yank y
				else
					throw "Package definition not found!"
				endif
			else
				throw cur_class . ": class not found!"
			endif
			wincmd p
			normal! G
			" insert after last import or in first line
			if search('^\s*import\s', 'b') > 0
				put y
			else
				1
				put! y
			endif
			substitute/^\s*package/import/g
			substitute/\s\+/ /g
			exe "normal! 2ER." . cur_class . ";\<Esc>lD"
		catch /.*/
			echoerr v:exception
		finally
			" wipe preview window (from buffer list)
			silent! wincmd P
			if &previewwindow
				bwipeout
			endif
			exe "normal! `z"
		endtry
	endfunction
	" }}}
	" }}}
	" GUI Options {{{1
	if exists("g:neovide") && g:neovide
		set guifont=FiraCode\ Nerdfont:h13
		let g:neovide_cursor_animation_length = 0
	endif
	" }}}
	" Set status to loaded {{{1
	let already_loaded = 1
	" }}}
