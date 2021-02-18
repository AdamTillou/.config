" ==============================================================================
" Filename:     note.vim
" Description:  Scripts for extra functionality in note files
" Author:       Adam Tillou
" ==============================================================================

" Settings {{{1
" Set basic preferences
setlocal tabstop=2
setlocal shiftwidth=2
setlocal nowrap
setlocal nolist
set conceallevel=1
set concealcursor=nvic

" Setup autocommands
autocmd BufWriteCmd *.noteview call noteview#Write()

" Prevent the cursor from going onto the end characters of the file
autocmd CursorMoved *.noteview silent! norm! /\d*\%#\d*$
" }}}
" Highlighting {{{1
" Set up syntax groups to conceal the list index numbers
syntax match FoldNumber /^\s*[▾▸]\zs./ conceal cchar= 

" Parse syntax groups
syntax match noteTopic /#[^#].*/ containedin=noteTopicLine
syntax match noteTopic /#$/ containedin=noteTopicLine
syntax match noteSection /##[^#].*/ containedin=noteSectionLine
syntax match noteSection /##$/ containedin=noteSectionLine

syntax match Normal /./

syntax match noteTitle /\~\~\~.*\~\~\~/
syntax match noteDefinition /^\s*\([▾▸].\)\?\s*[^:]*:\ze.*/ contains=FoldNumber
syntax match noteTopicLine /^\s*\([▾▸].\)\?\s*#[^#].*/ contains=FoldNumber,noteTopic
syntax match noteTopicLine /^\s*\([▾▸].\)\?\s*#$/ contains=FoldNumber,noteTopic
syntax match noteSectionLine /^\s*\([▾▸].\)\?\s*##[^#].*/ contains=FoldNumber,noteSection
syntax match noteSectionLine /^\s*\([▾▸].\)\?\s*##$/ contains=FoldNumber,noteSection

" Set different effects for each group
call g:HL('noteTitle', g:colors.purple, '', 'bold,underline')
call g:HL('noteTopicLine', g:colors.blue, '', 'bold')
call g:HL('noteTopic', g:colors.blue, '', 'bold,underline')
call g:HL('noteSectionLine', g:colors.cyan, '', 'bold')
call g:HL('noteSection', g:colors.cyan, '', 'bold,italic')
call g:HL('noteDefinition', '', '', 'bold')
" }}}
" Mappings {{{1
nnoremap <silent> <buffer> gzM :call noteview#CloseAllFolds()<CR>
nnoremap <silent> <buffer> gzR :call noteview#OpenAllFolds()<CR>
nnoremap <silent> <buffer> gzh :call noteview#CloseParentFold(line('.'))<CR>
nnoremap <silent> <buffer> gzl :if noteview#GetLineStatus(getline('.')) == 'closed' | call noteview#OpenFold(line('.')) | execute 'norm! j^' | endif<CR>
nnoremap <silent> <buffer> <Space> :call noteview#ToggleFold(line('.'))<CR>
nnoremap <silent> <buffer> g<Space> :call noteview#FullyToggleFold(line('.'))<CR>

" Only works in a gui
nnoremap <silent> <buffer> <S-Space> :call noteview#FullyToggleFold(line('.'))<CR>

" Easy bullet mapping
inoremap <silent> ` •

" Set mappings to avoid messing up the file  hi
onoremap <buffer> <expr> x noteview#GetLineStatus(getline('.')) == 'none' ? '$' : '/<C-v><CR>'
onoremap <buffer> <expr> gl noteview#GetLineStatus(getline('.')) == 'none' ? '$' : '/<C-v><CR>'
onoremap <buffer> <expr> $ noteview#GetLineStatus(getline('.')) == 'none' ? '$' : '/<C-v><CR>'

nnoremap <buffer> <expr> A noteview#GetLineStatus(getline('.')) == 'none' ? '$a' : '/<C-v><CR>a'
nnoremap <buffer> <expr> I noteview#GetLineStatus(getline('.')) == 'none' ? '^i' : '0/[▸▾]<CR>la'

nnoremap <buffer> <expr> dd noteview#GetLineStatus(getline('.')) == 'none' ? '^d$' : '0/[▸▾]<CR>2ld/<C-v><CR>'
nnoremap <buffer> <expr> cc noteview#GetLineStatus(getline('.')) == 'none' ? '^c$' : '0/[▸▾]<CR>2lc/<C-v><CR>'
inoremap <buffer> <expr> <A-x> getline('.')[col('.')-1] != '' ? '<Esc>lxi' : ''
nnoremap <buffer> <silent> x d/\%#[^<C-v><Esc>^▸^▾]\?\zs<CR>
nnoremap <buffer> <silent> z d/[^<C-v><Esc>^▸^▾]\?\%#<CR>
nnoremap <buffer> <silent> X d/\%#\([^<C-v><Esc>]\s*[^ ^	^<C-v><Esc>]*\)\?\zs<CR>
nnoremap <buffer> <silent> Z d/\ze\([^ ^	^▸^▾]*\s*\)\?\%#<CR>
" }}}

function! noteview#Write() " {{{1
	" If the current buffer is not the view buffer, cancel, because a write all
	" is being executed
	if  bufname(0) != bufname()
		return
	endif

	" Remember the document as it is
	let cursor_location = [line('.'), col('.')]
	norm! gg"zyG
	let current_document = @z
	let current_buffer = bufnr()

	" Open all of the folds
	call noteview#OpenAllFolds()

	" Remove the extra tab from lines that don't have a fold indicator
	silent! v/^\s*[▸▾]/s/^\t//

	" Delete all of the fold indicators
	silent! %s/^\t*\zs *[▸▾].\s*//

	" If there are any spaces in indentation, remove them
	silent! %s/^\t*\zs \+\ze\t*//g

	" Copy the new buffer text, now in a plain text format
	norm! gg"zyG
	let origional_document = @z

	" Go to the origional document and replace it with the text
	execute b:note_buffer . 'buffer!'
	1,$delete
	norm! "zp
	1delete

	" Write the file
	write

	" Restore the origional preview
	execute current_buffer . 'buffer!'
	let @z = current_document
	1,$delete
	norm! "zp
	1delete
	call cursor(cursor_location)
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
		call add(fold_lines, getline(check_line))
		let check_line += 1
	endwhile

	" If no lines were indented
	if check_line == a:line + 1
		echo 'No lines to fold'

		" Remove the fold indicator if it used to be a fold
		if current_status == 'open'
			execute a:line . 's/^\t*\zs\s*▾\s*/\t/'
			execute a:line . 's/\d\+$//'
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
		call setline(a:line, indent_text . spaces . '▸' . nr2char(folds_index + 1) . content_text)
	endif

	" Delete the folded lines
	let first_line = a:line + 1
	let last_line = a:line + len(fold_lines)
	execute printf('%d,%d delete', first_line, last_line)

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
		call append(a:line, fold_lines)

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
	while noteview#GetLineIndent(getline('.')) > 1
		norm! k
	endwhile

	" Remember the cursor position
	mark z

	" Each run of the loop closes one line
	norm! G
	while line('.') > 2
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
		let number = char2nr(char) - 1
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
