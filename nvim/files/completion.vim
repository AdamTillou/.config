" This file is an unfinished plugin for showing the completion info in a popup
" window beside the actual completion in deoplete. I abandoned it because I was
" unable to figure out how to return to any item in the completion menu other
" than the first. Perhaps my future self or someone more knowledgeable in the
" ways of vim can get it to work.

" Deoplete code {{{1
" Add to .../deoplete/autoload/deoplete/mappings.vim in the function
" deoplete#mappings#_complete() before the final complete() command

let g:var = string(g:deoplete#_context.candidates)
let g:first_buffer = bufnr('$')
let before_winid = win_getid()

for i in range(1, bufnr('$'))
	if bufname(i)[0:15] == "__completeinfo__"
		silent! exec i . "bdelete!"
	endif
endfor

let index = 0
for q in g:deoplete#_context.candidates
	new | silent! exec "file! __completeinfo__" . index

	call setline(1, "   " . q.word)
	call setline(2, "   " . q.menu)

	write! | close!
	let index += 1
endfor
call win_gotoid(before_winid)

" }}}

function! completion#Initialize() " {{{1
	let g:trow = screenrow()
	let g:trowh = [g:trow]
	set scrolloff=0

	set statusline=%!g:StatuslineInfo()
	set laststatus=2

	augroup completion_preview
		" Automatically show window on completions
		autocmd!
		autocmd CompleteChanged * call completion#AddWindow()

		" Remove extra window when leaving insert mode
		autocmd InsertLeave * call completion#RemoveWindow()
		autocmd CursorMovedI * call completion#RemoveWindow()
	augroup END


	" Remove extra windows when pressing any key in insert mode
	" For CursorMovedI does not register when the pmenu is active, and
	" CompleteChanged does not work to remove old windows
	let alphabet = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
	let special = ['!','@','#','$','%','^','&','*','(',')','-','=','_','+','[',']','{','}','<','>',';',':',',','.','"',"'",'/','?','`','~','|','\\']
	let actions = ['<BS>', '<CR>', '<Space>']
	let g:characters = alphabet + map(alphabet[0:-1], 'toupper(v:val)') + range(10) + special + actions
	for q in g:characters
		silent! exec 'inoremap <expr> ' . q . ' pumvisible() ? "' . q . '<Esc>a" : "' . q . '"'
	endfor
endfunction

function! g:StatuslineInfo()
	if screenrow() != g:trow
		let g:trow = screenrow()
		call add(g:trowh, g:trow)
	endif

	return screenrow()
endfunction " }}}
function! completion#RemoveWindow() " {{{1
	if exists('g:popup_winids')
		let new_winids = []

		for q in g:popup_winids
			let winnr = win_id2win(q)
			if winnr != 0
				call add(new_winids, q)
				exec winnr . 'close!'
			endif
		endfor

		let g:popup_winids = new_winids
	endif

	call deoplete#enable()

	return ''
endfunction " }}}
function! completion#AddWindow() " {{{1
	" Get the completion info
	let g:info = complete_info()

	" Detect if there is anything to display
	silent! let preview = g:info.items[g:info.selected].info
	let preview = "-"
	if g:info.selected < 0 || !exists('preview') || preview == ''
		return ''
	endif

	if !exists('g:popup_winids')
		let g:popup_winids = []
	else
		let new_winids = []
		for q in g:popup_winids
			let winnr = win_id2win(q)
			if winnr != 0
				call add(new_winids, q)
				exec winnr . 'close!'
			endif
		endfor

		let g:popup_winids = new_winids
	endif

	" Remember the current window
	let filetype = split(@%, '\\.')[-1]
	let real_window = win_getid()

	" Determine the column of the popup menu
	let g:widths = {'word':0, 'kind':0, 'menu':0}
	for q in g:info.items
		let g:widths.word = max([g:widths.word, q.abbr == '' ? len(q.word) : len(q.abbr)])
		let g:widths.kind = max([g:widths.kind, len(q.kind) - 1])
		let g:widths.menu = max([g:widths.menu, len(q.menu)])
	endfor
	let start_col = g:deoplete#_context.complete_position
	let end_col = start_col + g:widths.word + g:widths.kind + g:widths.menu + 8

	" Open the popup menu
	let options = {'relative':'editor', 'width':50, 'height':10, 'row':screenrow() + 1, 'col':end_col}
	silent! call nvim_open_win(g:first_buffer + g:info.selected + 1, v:true, options)
	set winhl=Normal:Pmenu
	set nonumber
	if !exists('g:popup_winids')
		let g:popup_winids = []
	endif
	call add(g:popup_winids, win_getid())

	" Return to the previous window
	call win_gotoid(real_window)
endfunction " }}}
