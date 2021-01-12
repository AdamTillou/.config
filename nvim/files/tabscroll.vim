" A cute, but not very practical animation for switching tabs
" Only works with 1 window open on each tab, no folds, and does not have
" syntax highlighting at all
" To get this working with buffers and other characters figure out how to get
" a grid of characters in the terminal, and replace the contents of
" GetDisplayedLines with that

function! tabscroll#TabScroll(dir)
	let current_tab = functions#GetDisplayedLines()
	exec "tab" . a:dir
	let new_tab = functions#GetDisplayedLines()
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

" Get a list of lines in the current buffer
" Would be better if it could get the lines of the terminal
function! tabscroll#GetDisplayedLines()
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
