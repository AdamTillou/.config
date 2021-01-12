" ==============================================================================
" Filename:     functions.vim
" Description:  Miscellaneous useful functions
" Author:       Adam Tillou
" ==============================================================================

function! functions#Initialize()
	" Create a command to show how many matches of a pattern are in a file
	command -nargs=1 GetMatches let g:regex_list = functions#GetMatches(<args>) | echo string(len(g:regex_list)) 'matches found, check g:regex_list for full list'
endfunction

" Get the character under the cursor {{{1
function! functions#Getchar()
	return strcharpart(strpart(getline('.'), col('.') - 1), 0, 1)
endfun
" }}}

" Open a floating window in the center of the screen {{{1
function! functions#FloatingWindow()
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

	let opts.row += 1
	let opts.height -= 2
	let opts.col += 2
	let opts.width -= 4

	call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
	nnoremap <buffer> <Esc> :q<CR>:q<CR>

	au BufWipeout <buffer> exe 'bw '. s:buf
endfunction
" }}}
" Open a buffer that is the result of a command in a new window {{{1
function! functions#OpenInFloatingWindow(command)
	let origional_buffer = bufnr()
	let origional_window = win_getid()

	exec a:command

	let cmd_cursor = [line('.'), col('.')]
	let cmd_buffer = bufnr()
	let cmd_window = win_getid()

	if bufnr() == origional_buffer
		return 0
	endif

	call functions#FloatingWindow()
	let floating_window = win_getid()
	exec cmd_buffer . 'buffer'
	call cursor(cmd_cursor[0], cmd_cursor[1])

	call nvim_win_close(cmd_window, 1)

	noremap <buffer> <Esc> :bd!<CR>:q<CR>
	noremap <buffer> <C-q> :bd!<CR>:q<CR>
endfunction
" }}}

" Java Imports {{{1
function! functions#JavaInsertImport()
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

" Add values of a regex to a list, g:regex_list {{{1
function! functions#GetMatches(text, pattern)
	let g:regex_list = []
	let regex_length = 0

	call substitute(a:text, a:pattern, '\=functions#AddToRegexList(submatch(0))', 'g')

	return g:regex_list
endfunction

function! functions#AddToRegexList(value)
	call add(g:regex_list, a:value)
	return ''
endfunction
" }}}
