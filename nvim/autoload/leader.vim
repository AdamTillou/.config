" ==============================================================================
" Filename:     leader.vim
" Description:  A custom menu full of actions for the leader key
" Author:       Adam Tillou
" ==============================================================================

function! leader#Initialize()
	let g:leader#mappings = [
				\ {'letter':'s', 'name':'Setting', 'command':[
				\ 	{'letter':'f', 'name':'Fold Method', 'command':[
				\ 		{'letter':'i', 'name':'Indent', 'command':':setlocal foldmethod=indent<CR>'},
				\ 		{'letter':'b', 'name':'Marker', 'command':':setlocal foldmethod=marker<CR>'},
				\ 		{'letter':'m', 'name':'Manual', 'command':':setlocal foldmethod=manual<CR>'},
				\ 		{'letter':'s', 'name':'Syntax', 'command':':setlocal foldmethod=syntax<CR>'},
				\ 	]},
				\ 	{'letter':'h', 'name':'Show Hidden', 'command':':set list!<CR>'},
				\ 	{'letter':'i', 'name':'Detect Indent', 'command':':DetectIndent<CR>'},
				\ ]},
				\ {'letter':'i', 'name':'Insert', 'ncommand':[
				\ 		{'letter':'l', 'name':'Line: │', 'command':'i│<Esc>l'},
				\ 		{'letter':'h', 'name':'Hashtag Heading: │', 'command':'i#<Esc>yl79pyypO# <Esc>yl77pi##<Esc>03lR'},
				\ ]},
				\ {'letter':'c', 'name':'Command', 'command':[
				\ 		{'letter':'s', 'name':'Substitute', 'ncommand':':%s///g<Left><Left><Left>', 'vcommand':':s/\%V//g<Left><Left><Left>'},
				\ ]},
				\ {'letter':'m', 'name':'Multi Cursor', 'command':[
				\ 		{'letter':'s', 'name':'Start', 'command':'<Plug>multicursor_s'},
				\ 		{'letter':'w', 'name':'Start Word', 'command':'<Plug>multicursor_w'},
				\ 		{'letter':'a', 'name':'Select All Words', 'command':'<Plug>multicursor_a'},
				\ 		{'letter':'g', 'name':'Select All', 'command':'<Plug>multicursor_A'},
				\ 		{'letter':'n', 'name':'Previous', 'command':'<Plug>multicursor_n'},
				\ 		{'letter':'p', 'name':'Previous', 'command':'<Plug>multicursor_p'},
				\ ]},
				\ {'letter':'v', 'name':'Vimspector', 'command':[
				\ 		{'letter':'v', 'name':'Start/Stop', 'command':':call plugins#VimspectorToggle()<CR>'},
				\ 		{'letter':'x', 'name':'Configure', 'command':':call plugins#VimspectorConfigEdit()<CR>'},
				\ 		{'letter':'l', 'name':'Step Into', 'command':'<Plug>VimspectorStepInto'},
				\ 		{'letter':'h', 'name':'Step Out', 'command':'<Plug>VimspectorStepOut'},
				\ 		{'letter':'j', 'name':'Step Over', 'command':'<Plug>VimspectorStepOver'},
				\ 		{'letter':'p', 'name':'Pause', 'command':'<Plug>VimspectorPause'},
				\ 		{'letter':'q', 'name':'Continue', 'command':'<Plug>VimspectorContinue'},
				\ 		{'letter':'t', 'name':'Run To Cursor', 'command':'<Plug>VimspectorRunToCursor'},
				\ 		{'letter':'r', 'name':'Restart', 'command':'<Plug>VimspectorRestart'},
				\ 		{'letter':'b', 'name':'Breakpoint', 'command':'<Plug>VimspectorToggleBreakpoint'},
				\ 		{'letter':'f', 'name':'Function Breakpoint', 'command':'<Plug>VimspectorAddFunctionBreakpoint'},
				\ 		{'letter':'c', 'name':'Conditional Breakpoint', 'command':'<Plug>VimspectorToggleConditionalBreakpoint'},
				\ ]},
				\ {'letter':'f', 'name':'Format', 'command':'\mzgg=G`z'},
				\ ]

	nnoremap <silent> <nowait> <leader> :call leader#SelectMenu('normal', 'Leader menu', g:leader#mappings)<CR>
	vnoremap <silent> <nowait> <leader> :<BS><BS><BS><BS><BS>call leader#SelectMenu('visual', 'Leader menu', g:leader#mappings)<CR>
endfunction

function! leader#SelectMenu(mode, title, options) " {{{1
	" Conver the dictionary of selection options to a string containing each
	" option name separated by a newline character for the confirm command
	let options_string = ''
	let options_list = []
	for q in a:options
		if has_key(q, 'command') || (a:mode == 'normal' && has_key(q, 'ncommand')) || (a:mode == 'visual' && has_key(q, 'vcommand'))
			call add(options_list, q)

			" Add the correct letter to the beginning of the string if it isn't already
			if toupper(q.letter) != toupper(q.name[0])
				let options_string .= toupper(q.letter) . ' '
			endif
			" Capitalize the first letter of the option name
			let options_string .= toupper(q.name[0]) . q.name[1:-1]
			" Add a newline character to signify the end of the option
			let options_string .= "\n"
		endif
	endfor
	" Remove the last newline character
	let options_string = options_string[0:-2]

	" Call the confirm menu, and save the input in the selection variable
	let selection = confirm(a:title, options_string)
	redraw!
	if selection == 0
		echo 'Exited without running any mapping'
		return
	else
		let option = options_list[selection - 1]
	endif

	" Set the command variable to the value of the correct command
	if a:mode == 'normal' && has_key(option, 'ncommand')
		let command = option.ncommand
	elseif a:mode == 'visual' && has_key(option, 'vcommand')
		let command = option.vcommand
	elseif has_key(option, 'command')
		let command = option.command
	else
		return
	endif

	" Execute the command if it is a string, or call the function again if it is
	" a list
	if type(command) == type('')
		if command[0] == '\'
			exec a:mode[0] . 'noremap \ ' . command[1:-1]
		else
			exec a:mode[0] . 'map \ ' . command
		endif

		if a:mode == 'visual'
			norm! gv
		endif

		call feedkeys('\')

	elseif type(command) == type([])
		call leader#SelectMenu(a:mode, toupper(option.name[0]) . option.name[1:-1] . ' menu', command)
	endif
endfunction " }}}
