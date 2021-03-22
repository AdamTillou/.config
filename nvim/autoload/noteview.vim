" ==============================================================================
" Filename:     note.vim
" Description:  Scripts for extra functionality in note files
" Author:       Adam Tillou
" ==============================================================================

function! noteview#Settings() " {{{1
	" Settings {{{2
	" Set basic preferences
	setlocal tabstop=2
	setlocal shiftwidth=2
	setlocal nowrap
	setlocal nolist
	setlocal spell
	setlocal conceallevel=1
	setlocal concealcursor=nvic

	" Setup autocommands
	autocmd BufWriteCmd *.noteview call noteview#Write()
	autocmd InsertLeave *.noteview call noteview#ReformatTables()
	" }}}
	" Highlighting {{{2
	" Parse syntax groups
	syntax match noteTopic /#[^#].*/ containedin=noteTopicLine
	syntax match noteTopic /#$/ containedin=noteTopicLine
	syntax match noteSection /##[^#].*/ containedin=noteSectionLine
	syntax match noteSection /##$/ containedin=noteSectionLine

	syntax match Normal /./

	" Set up syntax groups to conceal the list index numbers
	syntax match noteIndicator /[▾▸]\zs./ conceal cchar= 

	syntax match noteLine /^.*/ contains=noteIndicator
	syntax match noteTitle /\~\~\~.*\~\~\~/
	syntax match noteDefinition /^\s*\([▾▸].\)\?\s*[^:]*:\ze.*/ contains=noteIndicator
	syntax match noteTopicLine /^\s*\([▾▸].\)\?\s*#[^#].*/ contains=noteIndicator,noteTopic
	syntax match noteTopicLine /^\s*\([▾▸].\)\?\s*#$/ contains=noteIndicator,noteTopic
	syntax match noteSectionLine /^\s*\([▾▸].\)\?\s*##[^#].*/ contains=noteIndicator,noteSection
	syntax match noteSectionLine /^\s*\([▾▸].\)\?\s*##$/ contains=noteIndicator,noteSection

	" Set different effects for each group
	" let title_color = {"gui": "#FFD75F", "cterm": "221"}
	" let topic_color = {"gui": "#5FAFD7", "cterm": "74"}
	" let section_color = {"gui": "#FF87AF", "cterm": "211"}
	let title_color = g:colors.fg
	let topic_color = g:colors.fg
	let section_color = g:colors.fg
	call g:HL('noteTitle', title_color, '', 'bold,underline')
	call g:HL('noteTopicLine', topic_color, '', 'bold')
	call g:HL('noteTopic', topic_color, '', 'bold,underline')
	call g:HL('noteSectionLine', section_color, '', 'bold')
	call g:HL('noteSection', section_color, '', 'bold,italic')
	call g:HL('noteDefinition', '', '', 'bold')
	" }}}
	" Mappings {{{2
	nnoremap <silent> <buffer> gzM :call noteview#CloseAllFolds()<CR>
	nnoremap <silent> <buffer> gzR :call noteview#OpenAllFolds()<CR>
	nnoremap <silent> <buffer> gzh :call noteview#CloseParentFold(line('.'))<CR>
	nnoremap <silent> <buffer> <Space> :call noteview#ToggleFold(line('.'))<CR>
	nnoremap <silent> <buffer> g<Space> :call noteview#FullyToggleFold(line('.'))<CR>
	nnoremap <silent> <buffer> gZ z
	inoremap <buffer> <A-i>vv \vec{v}
	inoremap <buffer> <A-i>vu \vec{u}
	inoremap <buffer> <A-i>vi \vec{i}
	inoremap <buffer> <A-i>vj \vec{j}
	inoremap <buffer> <A-i>v< ⟨⟩<Left>
	inoremap <buffer> <A-i>* \cdot 
	inoremap <buffer> <A-i>, ,\enspace 
	noremap <silent> <Tab> <Esc>/│ .<CR>2lvt│h
	noremap <silent> <S-Tab> <Esc>?│ .<CR>n2lvt│h
	noremap <silent> t<CR> yyp:s/[^│^ ^	]/ /g<CR>^2lvt│h
	" }}}
endfunction
" }}}

function! noteview#NoteToNoteview() " {{{1
	" Return if not a proper noteview buffer
	if !exists('b:view_buffer')
		if exists('b:note_buffer')
			execute b:note_buffer . 'buffer'
		else
			return
		endif
	endif
	let note_buffer = bufnr()
	let view_buffer = b:view_buffer

	" Get the text of the note buffer
	let note_text = nvim_buf_get_lines(note_buffer, 0, -1, 0)

	" Go to the view buffer and set the lines
	execute view_buffer . 'buffer'
	1,$delete _
	call nvim_buf_set_lines(view_buffer, 0, 1, 0, note_text)

	" Add an extra tab to the beginning of each line
	if substitute(getline(1), '\s*\~\~\~.*\~\~\~', '', 'g') == '' && getline(1) != ''
		2,$s/^/\t/
	else
		1,$s/^/\t/
	endif

	" Format tables
	call noteview#FormatTables()

	" Close all of the folds
	call noteview#CloseAllFolds()

	" Remove the last line if it is blank
	if substitute(getline('$'), '\s*', '', '') == ''
		$delete _
	endif

	" Go to the beginning of the document
	call cursor(1, 1)
endfunction " }}}
function! noteview#NoteviewToNote() " {{{1
	" Return if not a proper noteview buffer
	if !exists('b:note_buffer')
		if exists('b:view_buffer')
			execute b:view_buffer . 'buffer'
		else
			return
		endif
	endif
	let note_buffer = b:note_buffer

	" Remember how the noteview buffer was before writing
	let noteview_buffer = bufnr()
	let noteview_cursor = [line('.'), col('.')]
	let noteview_layout = nvim_buf_get_lines(0, 0, -1, 0)

	" Open all of the folds
	call noteview#OpenAllFolds()

	" Get the text of the fully expanded noteview buffer
	let noteview_text = nvim_buf_get_lines(noteview_buffer, 0, -1, 0)

	" Restore the noteview buffer to how it was previously
	execute noteview_buffer . 'buffer'
	1,$delete _
	call nvim_buf_set_lines(0, 0, 1, 0, noteview_layout)
	call cursor(noteview_cursor)

	" Go to the note buffer and add the lines of the expanded noteview buffer
	execute note_buffer . 'buffer'
	1,$delete _
	call nvim_buf_set_lines(note_buffer, 0, 1, 0, noteview_text)

	" Remove the extra tab from lines that don't have a fold indicator
	silent! v/^\s*[▸▾]/s/^\t//

	" Delete all of the fold indicators
	silent! %s/^\t*\zs *[▸▾].\s*//

	" If there are any spaces in indentation, remove them
	silent! %s/^\t*\zs \+\ze\t*//g

	" Remove image filler lines if there are any
	silent! %s/^\s*<<imgline>>\n//g

	" Unformat tables
	call noteview#UnformatTables()
endfunction
" }}}

function! noteview#Write() " {{{1
	" Simplify the noteview buffer into the note buffer
	call noteview#NoteviewToNote()

	" Write the note buffer
	write

	" Return to the noteview buffer
	execute b:view_buffer . 'buffer'

	" Reformat tables
	call noteview#ReformatTables()
endfunction
" }}}

function! noteview#CloseFold(line) " {{{1
	" Initialize some variables
	let current_text = getline(a:line)
	let current_status = noteview#GetLineStatus(current_text)
	let cursor_location = [line('.'), col('.')]

	" Return if trying to fold the heading
	if a:line == 1 && substitute(current_text, '\~\~\~', '', '') != current_text
		echo 'Cannot fold the heading'
		return
	endif

	" Exit the function if the lines are already closed
	if current_status == 'closed'
		echo 'Line already closed'
		return
	endif

	" Gather the list of lines contained in the fold
	let current_indent = noteview#GetLineIndent(current_text)
	let check_line = a:line + 1
	let fold_lines = []

	while check_line <= line('$') && noteview#GetLineIndent(getline(check_line)) > current_indent
		let check_line_text = getline(check_line)
		" Do not add the line if it is a filler image line
		if check_line_text == '' || substitute(check_line_text, '^\s*<<imgline>>', '', '') != ''
			call add(fold_lines, check_line_text)
		endif

		let check_line += 1
	endwhile

	" If no lines were indented
	if check_line == a:line + 1
		echo 'No lines to fold'

		" Remove the fold indicator if it used to be a fold
		if current_status == 'open'
			silent! execute a:line . 's/^\t*\zs\s*▾./\t/'
		endif

		return
	endif

	if current_status == 'open'
		" If there is already a set value for the line
		let folds_index = noteview#GetLineNumber(current_text)
		let b:folds[folds_index] = fold_lines

		" Replace the open t  riangle with a closed one
		execute a:line . 's/▾/▸/'
		let g:num = 4

	else
		" If it is necessary to create a new item in the list of folds
		call add(b:folds, fold_lines)
		let folds_index = len(b:folds) - 1

		" Add the index of the new list item to the beginning of the line, hidden
		let indent_text = substitute(current_text, '^\s*\zs.*', '', '')[0:-2]
		let content_text = substitute(current_text, '^\s*\ze.*', '', '')
		let spaces = repeat(' ', &shiftwidth - 2)
		call setline(a:line, indent_text . spaces . '▸' . nr2char(folds_index + 10000) . content_text)
	endif

	" Delete the folded lines
	let first_line = a:line + 1
	let last_line = check_line - 1
	execute printf('%d,%d delete _', first_line, last_line)

	" Return to the origional cursor position
	call cursor(cursor_location)
endfunction
" }}}
function! noteview#OpenFold(line) " {{{1
	let current_text = getline(a:line)
	let current_status = noteview#GetLineStatus(current_text)
	let cursor_location = [line('.'), col('.')]

	if current_status == 'closed'
		" If there is already a set value for the line
		let fold_index = noteview#GetLineNumber(current_text)
		let fold_lines = b:folds[fold_index]

		" Add the folded lines
		let insert_position = a:line
		for q in fold_lines
			call append(insert_position, [q])
			let insert_position += 1

			" If it is an image, add filler lines
			let image_regexp = '^\(\s*\).*<<\(img\|tex\) \(path\|formula\)="\([^"]\+\)" height=\(\d\+\)>>.*$'
			let potential_height = substitute(q, image_regexp, '\5', '')
			if potential_height != q
				let indent_string = substitute(q, image_regexp, '\1', '')
				call append(insert_position, repeat([indent_string . '<<imgline>>'], potential_height - 1))
				let insert_position += potential_height - 1
			endif
		endfor

		" Replace the closed triangle with an open one
		execute a:line . 's/▸/▾/'

		" Return to the origional cursor position
		call cursor(cursor_location)

	elseif current_status == 'open'
		echo 'Already open'
	else
		echo 'No folded lines detected'
	endif
endfunction
" }}}
function! noteview#ToggleFold(line) " {{{1
	let current_text = getline(a:line)
	let current_status = noteview#GetLineStatus(current_text)

	if current_status == 'closed'
		call noteview#OpenFold(a:line)
	else
		call noteview#CloseFold(a:line)
	endif
endfunction
" }}}

function! noteview#FullyCloseFold(line) " {{{1
	" First, open out all lines
	call noteview#FullyOpenFold(a:line)

	" Figure out the last line in the fold
	let fold_indent = noteview#GetLineIndent(getline(a:line))
	let last_line = a:line + 1
	while noteview#GetLineIndent(getline(last_line)) > fold_indent
		let last_line += 1
	endwhile

	" Close all of the lines
	for i in range(1, last_line - a:line)
		let opposite_line = last_line - i
		silent! call noteview#CloseFold(opposite_line)
	endfor
endfunction
" }}}
function! noteview#FullyOpenFold(line) " {{{1
	" Open the current fold
	silent! call noteview#OpenFold(a:line)

	" Open all of the lines until the end of the fold
	let fold_indent = noteview#GetLineIndent(getline(a:line))
	let open_line = a:line + 1
	while noteview#GetLineIndent(getline(open_line)) > fold_indent
		silent! call noteview#OpenFold(open_line)
		let open_line += 1
	endwhile
endfunction
" }}}
function! noteview#FullyToggleFold(line) " {{{1
	let current_text = getline(a:line)
	let current_status = noteview#GetLineStatus(current_text)

	if current_status == 'closed'
		call noteview#FullyOpenFold(a:line)
	else
		call noteview#FullyCloseFold(a:line)
	endif
endfunction
" }}}

function! noteview#CloseAllFolds() " {{{1
	" Find the highest parent of the cursor position
	while noteview#GetLineIndent(getline('.')) > 1 && line('.') > 1
		norm! k
	endwhile

	" Remember the cursor position
	mark z

	" Each run of the loop closes one line
	norm! G
	while line('.') > 1
		norm! k
		silent! call noteview#CloseFold(line('.'))
	endwhile

	" Return to the cursor position
	silent! norm! `z
	silent! delmark z
endfunction
" }}}
function! noteview#OpenAllFolds() " {{{1
	" Remember the cursor position
	mark z

	" Each run of the loop closes one line
	norm! gg
	silent! call noteview#OpenFold(line('.'))
	while line('.') < line('$')
		norm! j
		silent! call noteview#OpenFold(line('.'))
	endwhile

	" Return to the cursor position
	norm! `z
	delmark z
endfunction
" }}}

function! noteview#GetParentLine(line) " {{{1
	let start_indent = noteview#GetLineIndent(getline(a:line))
	let check_line = a:line - 1
	while noteview#GetLineIndent(getline(check_line)) >= start_indent
		let check_line -= 1
	endwhile

	return check_line
endfunction
" }}}
function! noteview#CloseParentFold(line) " {{{1
	let parent_line = noteview#GetParentLine(a:line)
	call noteview#CloseFold(parent_line)
	call cursor(parent_line, 1)
	norm! ^
endfunction
" }}}

function! noteview#GetLineStatus(string) " {{{1
	if a:string == ''
		return 'none'
	elseif substitute(a:string, '^\s*▸.*$', '', '') == ''
		return 'closed'
	elseif substitute(a:string, '^\s*▾.*$', '', '') == ''
		return 'open'
	else
		return 'none'
	endif
endfunction
" }}}
function! noteview#GetLineNumber(string) " {{{1
	let char = substitute(a:string, '^\s*[▾▸]\(.\).*$', '\1', '')

	if char == a:string
		" If the line does not match an open or closed line
		return -1

	else
		let number = char2nr(char) - 10000
		return number
	endif
endfunction
" }}}
function! noteview#GetLineIndent(string) " {{{1
	let line_status = noteview#GetLineStatus(a:string)
	let tabs_to_spaces = substitute(a:string, '\t', repeat(' ', &tabstop), 'g')
	let space_count = len(substitute(tabs_to_spaces, '^\s*\zs\S.*$', '', ''))

	" Add 1 to the tab count if there is a fold, because the fold icon will
	" remove one of the tabs that should be there
	if line_status == 'none'
		return space_count
	else
		return space_count + 2
	endif
endfunction
" }}}

function! noteview#FormatTables() " {{{1
	" Remove the extra indent
	silent! %s/^\t*\zs\t|/|/

	" Format all of the tables
	silent! g/<<table>>/call noteview#FormatTable(line('.') + 1)

	" Remove the table tags
	silent! g/<<table>>/delete _
endfunction
" }}}
function! noteview#UnformatTables() " {{{1
	" Add table tags
	silent! %s/^\s*\zs┌.*/<<table>>/

	" Replace table characters with pipes
	silent! g/^\s*╞/delete _
	silent! g/^\s*└/delete _
	silent! g/^\s*│/s/^\s*\zs│ \+/| /
	silent! g/^\s*|/s/ \+│$/ |/
	silent! g/^\s*|/s/ \+│ / | /g
	silent! g/^\s*|/s/^/\t/
endfunction
" }}}
function! noteview#ReformatTables() " {{{1
	let line_is_in_table = substitute(getline('.'), '^\s*│', '', '') != getline('.')

	if line_is_in_table
		norm! 
		let cursor_location = [line('.'), col('.')]
		call noteview#UnformatTables()
		call noteview#FormatTables()
		call cursor(cursor_location)
		norm! a
	endif
endfunction
" }}}
function! noteview#FormatTable(table_start) " {{{1
	call cursor(a:table_start, 1)
	let table_columns = len(substitute(getline('.'), '[^|]', '', 'g')) - 1
	let indent_string = substitute(getline('.'), '^\s*\zs.*', '', '')
	call append(a:table_start - 1, [indent_string . repeat('|', table_columns + 1)])
	call append(a:table_start + 1, [indent_string . repeat('|', table_columns + 1)])

	" Get the last line in the table, and insert lines at the beginning and end
	call cursor(a:table_start, 1)
	while getline('.') != '' && substitute(getline('.'), '^\s*|.*|$', '', '') == ''
		norm! ^r│j
	endwhile
	let table_end = line('.')
	call append(table_end - 1, [indent_string . '│' . repeat('|', table_columns)])

	for i in range(1, table_columns)
		" Get the maximum column of the first row
		call cursor(a:table_start, 1)
		let max_col = 0
		while line('.') < table_end
			norm! 0f|
			let display_col = strdisplaywidth(getline('.')[0:col('.')])
			if display_col > max_col
				let max_col = display_col
			endif
			norm! j
		endwhile

		" Format the first row of the table
		call cursor(a:table_start, 1)
		while line('.') <= table_end
			norm! 0f|
			let spaces_to_insert = max_col - strdisplaywidth(getline('.')[0:col('.')])
			execute 'norm! i' . repeat(' ', spaces_to_insert) . ''
			norm! j
		endwhile

		" Replace the & signs with vertical lines
		call cursor(a:table_start, 1)
		while line('.') <= table_end
			norm! 0f|
			norm! r│
			norm! j
		endwhile
	endfor

	" Format the beginning and end lines as edges
	execute a:table_start . 's/ /─/g'
	execute a:table_start . 's/^\s*\zs│/┌/'
	execute a:table_start . 's/│$/┐/'
	execute a:table_start . 's/│/┬/g'

	execute string(a:table_start + 2) . 's/ /═/g'
	execute string(a:table_start + 2) . 's/^\s*\zs│/╞/'
	execute string(a:table_start + 2) . 's/│$/╡/'
	execute string(a:table_start + 2) . 's/│/╪/g'

	execute table_end . 's/ /─/g'
	execute table_end . 's/^\s*\zs│/└/'
	execute table_end . 's/│$/┘/'
	execute table_end . 's/│/┴/g'
endfunction
" }}}
