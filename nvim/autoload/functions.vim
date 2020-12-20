function! functions#Initialize()
	" Map H to open the help menu, but in a floating window
	command! -nargs=1 H call functions#Help(0, "<args>")
	command! -nargs=1 HG call functions#Help(1, "<args>")
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
" Open help menu in floating window {{{1
function! functions#Help(grep, term)
	let origional_name = @%
	exec (a:grep ? "helpgrep " : "help ") . a:term
	let help_line = line(".")
	let help_path = expand("%:p")

	if @% == origional_name
		return 0
	else
		bdelete
	endif

	call functions#FloatingWindow()
	exec "e " . help_path
	call cursor(help_line, 0)
	noremap <buffer> <Esc> :bd!<CR>:q<CR>
	noremap <buffer> <C-q> :bd!<CR>:q<CR>
endfunction
" }}}
" Show animation when switching tabs {{{1
function! functions#TabScroll(dir)
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
" Get a list of lines of the current window {{{1
function! functions#GetDisplayedLines()
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
