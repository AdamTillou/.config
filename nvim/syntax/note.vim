" ==============================================================================
" Filename:     note.vim
" Description:  Scripts for extra functionality in note files
" Author:       Adam Tillou
" ==============================================================================

function! note#NewFile()
	" Copy the contents of the initial file
	norm! mzgg"zyG`z

	" Create a new buffer
	let note_buffer = bufnr()
	let note_name = join(split(bufname(), '\.')[0:-2], '\.')
	enew
	execute 'file ' . note_name . '.noteview'
	let b:note_buffer = note_buffer
	call setbufvar(note_buffer, 'view_buffer', bufnr())

	" Initialize the list to store folded text
	let b:folds = []
	let b:max_id = 1

	" Paste the contents of the old file into the new file
	norm! "zpgg
	1delete

	" Add an extra tab to the beginning of each line
	2,$s/^/\t/

	" Close all lines
	call noteview#CloseAllFolds()

	" Return to the first line of the file
	call cursor(1, 1)
endfunction

if !exists('b:view_buffer')
	call note#NewFile()
endif

nnoremap ;v :execute b:view_buffer . 'buffer!'<CR>
