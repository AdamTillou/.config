" ==============================================================================
" Filename:     note.vim
" Description:  Scripts for extra functionality in note files
" Author:       Adam Tillou
" ==============================================================================

if !exists('b:view_buffer')
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

	" Convert the note text into a formatted view buffer
	call noteview#NoteToNoteview()
	
	" Create a timer in order to enter the view buffer immediately after vim
	" finishes loading the note file
	call timer_start(1, 'EnterViewBuffer')
	function! EnterViewBuffer(timer)
		call timer_stop(a:timer)
		execute b:view_buffer . 'buffer'
		call noteview#Settings()
	endfunction
endif
