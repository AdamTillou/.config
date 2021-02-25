" ==============================================================================
" Filename:     mappings.vim
" Description:  Custom key mappings for all modes
" Author:       Adam Tillou
" ==============================================================================

function! mappings#Initialize()
	" Basic mappings
	" Movement mappings {{{1
	" Set hjkl movements to not quit other mappings when going off an edge
	noremap <expr> h col(".")==1 ? "" : "h"
	noremap <expr> l col(".")==col("$") ? "" : "l"
	noremap <expr> j line(".")==line("$") ? "" : "j"
	noremap <expr> k line(".")==1 ? "" : "k"

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

	" Map { and } to go forward and backward through changes
	nnoremap { g;
	nnoremap } g,

	" Insert mode movement
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
	imap <A-b> <Esc>bi
	imap <A-B> <Esc>Bi
	" }}}
	" Text modification mappings {{{1
	noremap z "_X
	nnoremap <silent> X "_d/\%#.\s*\S*\zs<CR>
	nnoremap <silent> Z "_d/\ze\S*\s*\%#<CR>
	inoremap <expr> <A-x> col('.') < col('$') ? '<Esc>l"_xi' : ''
	inoremap <expr> <A-z> col('.') > 1 ? '<Esc>"_xi' : ''
	inoremap <expr> <BS> col('.') > 1 ? '<Esc>"_xi' : ''
	inoremap <expr> <A-X> col('.') < col('$') ? '<Esc>l"_d/\%#.\s*\S*\zs<CR>i' : ''
	inoremap <expr> <A-Z> col('.') > 1 ? '<Esc>l"_d/\ze\S*\s*\%#<CR>i' : ''

	" Map v to operate on entire words
	onoremap v iw
	onoremap V iW

	" Map z and x to operate to the beginning and end of the line
	onoremap z 0
	onoremap x $

	" Map deleteing and yanking functions
	noremap d "_d
	nnoremap D "_dd
	nnoremap dd 0"_d$

	nnoremap C "_cc
	nnoremap c "_c

	noremap s :YankCycle<CR>d
	noremap S :YankCycle<CR>dd
	nnoremap ss :YankCycle<CR>^d$

	noremap y :YankCycle<CR>y
	noremap Y :YankCycle<CR>yy
	nnoremap yy :YankCycle<CR>mz^y$`z

	" Map g+key to add to the register
	nnoremap gaY "zyy:let @0 .= (@0[len(@0)-1] == "\n" ? "" : "\n") . @z<CR>
	nnoremap gay "zyy:let @0 .= (@0[len(@0)-1] == "\n" ? "" : "\n") . @z<CR>
	vnoremap gay "zy:let @0 .= (@0[len(@0)-1] == "\n" ? "" : "\n") . @z<CR>

	nnoremap gaS "zdd:let @0 .= (@0[len(@0)-1] == "\n" ? "" : "\n") . @z<CR>
	nnoremap gas "zdd:let @0 .= (@0[len(@0)-1] == "\n" ? "" : "\n") . @z<CR>
	vnoremap gas "zd:let @0 .= (@0[len(@0)-1] == "\n" ? "" : "\n") . @z<CR>

	" Map g+key to use the system register
	noremap gy "+y
	noremap gY "+yy

	noremap gs "+d
	noremap gS "+dd

	nnoremap yp :call functions#YankGet('p')<CR>
	nnoremap yP :call functions#YankGet('P')<CR>
	nnoremap ygp :call functions#YankGet('gp')<CR>
	nnoremap ygP :call functions#YankGet('gP')<CR>

	nnoremap sp "+p
	nnoremap sP "+P
	nnoremap sgp "+gp
	nnoremap sgP "+gP

	" Paste from insert mode
	inoremap <expr> <A-p> stridx(@", "\n") == -1 ? '<Esc>pa' : '<Exc>pA'
	inoremap <expr> <A-P> stridx(@", "\n") == -1 ? '<Esc>mzp`za' : '<Exc>pA'
	" }}}
	" Buffer related mappings 	{{{1
	noremap ( :bp!<CR>
	noremap ) :bn!<CR>

	noremap <C-h> <C-w>h
	noremap <C-j> <C-w>j
	noremap <C-k> <C-w>k
	noremap <C-l> <C-w>l
	" }}}
	" File related mappings {{{1
	" Map Ctrl+S to save
	noremap <silent> <C-s> <Esc>:silent w<CR>

	" Map Ctrl+X to save and exit vim
	noremap <silent> <C-x> <Esc>:wa<CR>:qa!<CR>

	" Map Ctrl+Z to force quit vim
	noremap <silent> <C-z> <Esc>:qa!<CR>

	" Map Ctrl+R to reload the config file
	noremap <silent> <C-r> :exec "source " . g:init#config . "/init.vim"<CR>
	" }}}
	" Useful mappings {{{1
	" Map gq to macros and q to esc
	noremap q <Nop>
	noremap Q <Nop>
	noremap gq q

	" Map <Tab> to different functions based on the context
	imap <expr> <Tab> TabMapping()
	function! TabMapping() " {{{2
		" Check if a complete option is selected
		if pumvisible()
			return ""
		endif

		" Check if in table mode
		if exists("b:table_mode_active") && b:table_mode_active
			return '|'
		endif

		" Return tab as default
		return "	"
	endfunction
	" }}}

	" Make F1 not bring up help menu
	noremap <F1> <Nop>
	noremap <M-F1> <Nop>

	" Disable comment spreading
	inoremap <expr> <CR> (col(".") == 1 ? "<Right><Left>" : "<Left><Right>") . "<CR>-<C-u>"
	noremap <CR> o-<C-u><Esc>
	noremap o o-<C-u>
	noremap O O-<C-u>

	" Map Alt+q to esc
	noremap <A-q> <Esc>l
	noremap! <A-q> <Esc>l
	noremap <A-Q> <Esc>l
	noremap! <A-Q> <Esc>l

	" Map U to redo
	noremap U <C-r>

	" Map regular i and a to go before/after visual selections
	vnoremap <nowait> i I
	vnoremap <nowait> a A

	" Map gf to format the file
	noremap gf mzgg=G`z

	" Map -/=/_/+ to increment/decrement numbers in visual mode
	vnoremap - <Esc><C-x>gv
	vnoremap = <Esc><C-a>gv
	vnoremap _ g<C-x>gv
	vnoremap + g<C-a>gv
	vnoremap g- I0<Esc>gvg<C-x>gv
	vnoremap g= I0<Esc>gvg<C-a>gv

	" Map g= / g- to increment/decrement a number in normal mode
	nnoremap g- <C-x>
	nnoremap g= <C-a>

	" Easier indenting
	nnoremap > a<--><Esc>>>$?<--><CR>da<h
	nnoremap < a<--><Esc><<$?<--><CR>da<h
	vnoremap > >gv
	vnoremap < <gv
	inoremap <A-a> <--><Esc><<$?<--><CR>da<i
	inoremap <A-d> <--><Esc>>>?<--><CR>da<i

	" Map space to toggle the current fold
	nnoremap <Space> za

	" Map M to merge two lines since J is already mapped
	nnoremap M J

	" Map gm to go to the middle of the line
	nnoremap <silent> gm :call cursor(line("."), col("$") / 2)<CR>

	" Map gz to fold actions
	nnoremap gz z
	nnoremap gzO 100zo
	nnoremap gzC 100zc
	nnoremap gzj ]z$l
	nnoremap gzk [z$l
	vnoremap gzj <Esc>]z$lmzgv`z
	vnoremap gzk <Esc>[z$lmzgv`z

	" Map Alt Enter to open a new line
	inoremap <A-> <Esc>o

	" }}}
endfunction
