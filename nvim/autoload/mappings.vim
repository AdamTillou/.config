function! mappings#Initialize()
	" Basic mappings
	" Movement mappings {{{1
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

	" Map { and } to go forward and backward through changes
	nnoremap { g;
	nnoremap } g,
	" }}}
	" Text modification mappings {{{1
	noremap x "_x
	noremap z "_X
	noremap <expr> X col('.')==col('$') ? '' : '"_de'
	noremap <expr> Z col('.')==1 ? '' : '"_db'

	noremap d "_d
	noremap D "_dd
	nnoremap dd ^"_d$

	noremap c "_c
	noremap C "_cc

	noremap s d
	noremap S dd
	nnoremap ss ^d$

	noremap Y yy
	nnoremap yy mz^y$`z
	
	" Map g+key to add to the register
	nnoremap gaY "zyy:let @0 .= "\n" . @z<CR>:let @" = @0<CR>
	vnoremap gay "zy:let @0 .= "\n" . @z<CR>:let @" = @0<CR>
	
	nnoremap gaS "zdd:let @0 .= "\n" . @z<CR>:let @" = @0<CR>
	vnoremap gas "zd:let @0 .= "\n" . @z<CR>:let @" = @0<CR>

	" Map g+key to use the system register
	noremap gy "+y
	noremap gY "+yy

	noremap gs "+d
	noremap gS "+dd

	noremap gp "+p
	noremap gP "+P

	" Map v to operate on entire words
	onoremap v iw
	onoremap V iW

	" Map z and x to operate to the beginning and end of the line
	onoremap z 0
	onoremap x $
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
	noremap <silent> <C-s> <Esc>:w<CR>

	" Map Ctrl+X to exit
	noremap <silent> <C-x> <Esc>:wa<CR>:qa!<CR>

	" Map Ctrl+R to reload the config file
	noremap <silent> <C-r> :exec "source " . g:config_path . "/init.vim"<CR>
	" }}}
	" Useful mappings {{{1
	" Map gq to macros and q to esc
	noremap q <Esc>
	noremap gq q

	" Make F1 not bring up help menu
	noremap <F1> <Nop>
	noremap <M-F1> <Nop>

	" Disable comment spreading
	inoremap <expr> <CR> (col(".") == 1 ? "<Right><Left>" : "<Left><Right>") . "<CR>-<C-u>"
	noremap <CR> o-<C-u><Esc>
	noremap o o-<C-u>
	noremap O O-<C-u>

	" Map <Esc> to stay on the same character
	inoremap <expr> <Esc> col('.')==1 ? '<Esc>' : '<Esc>l'

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
	nnoremap > mz>>`zl
	nnoremap <expr> < indent(line(".")) > 0 ? "mz<<`zh" : ""
	vnoremap > >gv
	vnoremap < <gv

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
	" }}}

	" Insert mode mappings
	" Movement mappings {{{1
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
	imap <expr> <Tab> pumvisible() ? "<C-y>" : "<Tab>"
	" }}}
	" Text modification mappings {{{1
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
	" }}}
	" Adding folds {{{1
	imap <A-f> <Esc>A{<Right>{{<CR><CR>" }<Right>}}<Up>
	imap <A-f>0 <Esc>A{<Right>{{<CR><CR>" }<Right>}}<Up>
	imap <A-f>1 <Esc>A{<Right>{{1<CR><CR>" }<Right>}}<Up>
	imap <A-f>2 <Esc>A{<Right>{{2<CR><CR>" }<Right>}}<Up>
	imap <A-f>3 <Esc>A{<Right>{{3<CR><CR>" }<Right>}}<Up>
	imap <A-f>4 <Esc>A{<Right>{{4<CR><CR>" }<Right>}}<Up>
	imap <A-f>5 <Esc>A{<Right>{{5<CR><CR>" }<Right>}}<Up>
	" }}}

	" Leader mappings
	" Settings mappings {{{1
	" Set the folding method
	nnoremap <leader>sfi :setlocal foldmethod=indent<CR>
	nnoremap <leader>sfb :setlocal foldmethod=marker<CR>
	nnoremap <leader>sfm :setlocal foldmethod=manual<CR>
	nnoremap <leader>sfs :setlocal foldmethod=syntax<CR>

	" Toggle showing special characters
	nnoremap <leader>sl :setlocal list!<CR>
	
	" Toggle autocompletion
	nnoremap <leader>sa :call plugins#NCM2Toggle()
	
	" Set sidebar color
	nnoremap <leader>sc :let g:wm#sidebar_color = g:colors.sidebar<CR>:let g:wm#window_color = g:colors.bg<CR>
	" }}}
	" Getting values {{{1
	nnoremap <leader>gc :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
				\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
				\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
	" }}}
	" Inserting text {{{1
	" Map leader+i+l to insert a better horizontal line
	nnoremap <leader>il i│<Esc>l

	" Map leader+i+# to insert a comment heading
	nnoremap <leader>i# i#<Esc>yl79pyypO# <Esc>yl77pi##<Esc>03lR
	" }}}
	" Useful commands {{{1
	" Map leader+;+s to run the substitute command
	nnoremap <leader>cs :%s///g<Left><Left><Left>
	vnoremap <leader>cs :s/\%V//g<Left><Left><Left>
	vnoremap / /\%V
	" }}}
	" Misc {{{1
	" Map leader+f to format the file
	nnoremap <leader>f mzgg=G`z
	" }}}
endfunction
