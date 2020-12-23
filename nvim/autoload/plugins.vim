function! plugins#Initialize()
	" Language support plugins
	call plugins#SetupDeoplete()
	call plugins#SetupUltiSnips()
	call plugins#SetupALE()
	call plugins#SetupVimspector()

	" Miscellaneous plugins
	call plugins#SetupWM()
	call plugins#SetupMultipleCursors()
endfunction 
" Language support plugins
function! plugins#SetupDeoplete() " {{{1
	let g:deoplete#enable_at_startup = 1
	call deoplete#custom#option("auto_complete_delay", 0)
endfunction " }}}
function! plugins#SetupUltiSnips() " {{{1
	let g:UltiSnipsExpandTrigger = "<C-u>"
	let g:UltiSnipsJumpForwardTrigger = "<C-u>"
	let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
	let g:UltiSnipsListSnippets = "<F2>"
endfunction " }}}
function! plugins#SetupALE() " {{{1
	let g:ale_sign_column_always = 1
	let g:ale_sign_error = ">"
	let g:ale_sign_warning = "-"

	autocmd BufNew py ALEEnableBuffer

	nnoremap <silent> <leader>e :ALENextWrap<CR>

	" Change highlighting colors of errors and warnings
	highlight def link ALEError Error 
	highlight def link ALEWarning UtterNonsense
	exec "highlight Todo ctermbg=" . g:colors.bg.cterm . " ctermfg=" . g:colors.bg.cterm

	call g:HL("ALESignColumnWithErrors", g:colors.red, "", "none")
	call g:HL("ALESignColumnWithoutErrors", g:colors.red, "", "none")


	" Automatically update when changing lines in insert mode
	let g:__curline__ = line(".")
	autocmd InsertEnter * let g:__curline__ = line(".")
	autocmd CursorMovedI * if g:__curline__ != line(".") | call feedkeys("i") | let g:__curline__ = line(".") | endif
endfunction " }}}
function! plugins#SetupVimspector() " {{{1
	let g:vimspector_install_gadgets = [ "debugpy", "vscode-cpp" ]
	
	let g:plugins#vimspector_templates = [ "python" ]
	let g:plugins#vimspector_active = 0
	
	nmap <silent> <leader>VV :call plugins#VimspectorToggle()<CR>
	nmap <silent> <leader>VC :call plugins#VimspectorConfigEdit()<CR>
	
	call plugins#VimspectorMappings()
endfunction

function! plugins#VimspectorMappings() " {{{2
	nmap <leader>vl <Plug>VimspectorStepInto
	nmap <leader>vh <Plug>VimspectorStepOut
	nmap <leader>vj <Plug>VimspectorStepOver
	
	nmap <leader>vp <Plug>VimspectorPause
	nmap <leader>vq <Plug>VimspectorContinue
	nmap <leader>vt <Plug>VimspectorRunToCursor
	nmap <leader>vr <Plug>VimspectorRestart

	nmap <leader>vb <Plug>VimspectorToggleBreakpoint
	nmap <leader>vf <Plug>VimspectorAddFunctionBreakpoint
	nmap <leader>vc <Plug>VimspectorToggleConditionalBreakpoint
endfunction " }}}
function! plugins#VimspectorConfigEdit() " {{{2
	let dir_splits = split(expand("%:p:h"), "/")
	for i in range(1, len(dir_splits))
		let test_path = "/" . join(dir_splits[0:-i], "/") . "/"
		if system("[ -f '" . test_path . ".vimspector.json' ] && echo 1")
			let root_path = test_path
		endif
	endfor

	" Edit the file if it exists
	if exists("root_path")
		exec "edit! " . root_path . ".vimspector.json"
		return
	endif

	" Ask to create the file if it doesn"t exist"
	let create_file = confirm(".vimspector.json does not exist, would you like to create it?", "&Yes\n&No")
	redraw
	if create_file != 1
		return
	endif

	" Ask the use to specify a project directory
	let root_path = input("Select project root directory: ", expand("%:p:h"))
	redraw
	if root_path == ""
		return
	elseif root_path[-1:-1] != "/"
		let root_path .= "/"
	endif
	let file_path = root_path . ".vimspector.json"

	" Ask the user which tepmlate to use
	let uppercase_templates = map(g:plugins#vimspector_templates, 'toupper(v:val[0]) . v:val[1:-1]')
	let template_num = confirm("Which template would you like to use?", "None\n" . join(uppercase_templates, "&\n"))
	redraw
	if template_num == 1
		exec "!touch '" . file_path . "'"
	else
		let template_path = g:init#config . "/files/vimspector-templates/" . tolower(g:plugins#vimspector_templates[template_num - 2])
		exec "!cp '" . template_path . "' '" . file_path . "'"
	endif

	" Get the path to the current file from the project root
	let g:program_relative_path = substitute(expand("%:p"), root_path, "", "")

	" Open the config file
	exec "edit! " . file_path
	redraw!

	" Set the program relative path
	let g:program_relative_path = substitute(g:program_relative_path, '/', '\\/', "g")
	silent! exec '%s/"program":\zs.*/ "\${workspaceRoot}\/' . g:program_relative_path . '",/'
	call cursor(1, 1)
	write
endfunction " }}}
function! plugins#VimspectorToggle() " {{{2
	let g:plugins#vimspector_active = !g:plugins#vimspector_active

	if g:plugins#vimspector_active " When activating vimspector
		nmap q <leader>v
		call vimspector#Launch()
		
	else " When deactivating vimspector
		nmap q <Nop>"
		call vimspector#Reset()
	endif
endfunction
" }}}

" Miscellaneous plugins
function! plugins#SetupWM() " {{{1
	let &rtp .= "," . expand("~/Documents/VimPlugins/vim-wm")

	"Enable windows
	call windows#WindowManagerEnable()

	" Set keybindings
	nnoremap <silent> <nowait> <C-q> :WindowClose<CR>
	nnoremap <silent> <nowait> <C-w>c :WindowClose<CR>
	nnoremap <silent> <nowait> <C-w>r :WindowRender<CR>

	nnoremap <silent> <nowait> <A-j> :WindowMoveDown<CR>
	nnoremap <silent> <nowait> <A-k> :WindowMoveUp<CR>
	nnoremap <silent> <nowait> <A-h> :WindowMoveLeft<CR>
	nnoremap <silent> <nowait> <A-l> :WindowMoveRight<CR>

	nnoremap <silent> <nowait> <A-S-j> :WindowSplitDown<CR>
	nnoremap <silent> <nowait> <A-S-k> :WindowSplitUp<CR>
	nnoremap <silent> <nowait> <A-S-h> :WindowSplitLeft<CR>
	nnoremap <silent> <nowait> <A-S-l> :WindowSplitRight<CR>

	nnoremap <silent> <nowait> = :WindowResizeHorizontal 0.015<CR>
	nnoremap <silent> <nowait> - :WindowResizeHorizontal -0.015<CR>
	nnoremap <silent> <nowait> + :WindowResizeVertical 0.025<CR>
	nnoremap <silent> <nowait> _ :WindowResizeVertical -0.025<CR>

	nnoremap <silent> <nowait> <C-w>s :SidebarToggleOpen<CR>
	nnoremap <silent> <nowait> <C-a> :SidebarToggleFocus<CR>

	" Create sidebars
	call add(g:wm#sidebar.bars, {"name":"filetree", "command":"call filetree#Initialize()"})
	call add(g:wm#sidebar.bars, {"name":"taglist", "command":"Tlist"})
	call add(g:wm#sidebar.bars, {"name":"mundo", "command":"MundoToggle"})

	" Custom sidebar keybindings
	nnoremap <silent> <leader>1 :SidebarOpen filetree<CR>
	nnoremap <silent> <leader>2 :SidebarOpen taglist<CR>
	nnoremap <silent> <leader>3 :SidebarOpen mundo<CR>
endfunction " }}}
function! plugins#SetupMultipleCursors() " {{{1
	" Set custom mappings
	let g:multi_cursor_use_default_mappings = 0
	let g:multi_cursor_start_key = "<leader>ms"
	let g:multi_cursor_select_all_word_key = "<leader>ma"
	let g:multi_cursor_start_word_key = "<leader>mw"
	let g:multi_cursor_select_all_key = "<leader>mA"
	let g:multi_cursor_next_key = "<leader>mn"
	let g:multi_cursor_prev_key = "<leader>mp"
	let g:multi_cursor_quit_key = "<Esc>"
endfunction " }}}
