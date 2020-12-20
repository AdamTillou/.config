function! plugins#Initialize()

	" Functions to set up various plugins
	call plugins#SetupVimspector()
	call plugins#SetupMultipleCursors()
	call plugins#SetupUltiSnips()
	call plugins#SetupALE()
	call plugins#SetupWM()
	call plugins#SetupDeoplete()
endfunction 

function! plugins#SetupALE() " {{{1
	let g:ale_sign_column_always = 1
	let g:ale_sign_error = '>'
	let g:ale_sign_warning = '-'

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
function! plugins#SetupDeoplete() " {{{1
	let g:deoplete#enable_at_startup = 1
endfunction " }}}
function! plugins#SetupUltiSnips() " {{{1
	let g:UltiSnipsExpandTrigger = "<Tab>"
	let g:UltiSnipsJumpForwardTrigger = "<Tab>"
	let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
	let g:UltiSnipsListSnippets = "<F2>"

endfunction " }}}
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
	let g:multi_cursor_start_key = '<leader>ms'
	let g:multi_cursor_select_all_word_key = '<leader>ma'
	let g:multi_cursor_start_word_key = '<leader>mw'
	let g:multi_cursor_select_all_key = '<leader>mA'
	let g:multi_cursor_next_key = '<leader>mn'
	let g:multi_cursor_prev_key = '<leader>mp'
	let g:multi_cursor_quit_key = '<Esc>'
endfunction " }}}
function! plugins#SetupVimspector() " {{{1
	let g:vimspector_install_gadgets = [ 'debugpy' ]

	nmap <leader>vv <Plug>VimspectorContinue
	nmap <leader>vs <Plug>VimspectorStop
	nmap <leader>vr <Plug>VimspectorRestart
	nmap <leader>vp <Plug>VimspectorPause
	nmap <leader>vb <Plug>VimspectorToggleBreakpoint
	nmap <leader>vc <Plug>VimspectorToggleConditionalBreakpoint
	nmap <leader>vf <Plug>VimspectorAddFunctionBreakpoint
	nmap <leader>vo <Plug>VimspectorStepOver
	nmap <leader>vi <Plug>VimspectorStepInto
	nmap <leader>ve <Plug>VimspectorStepOut
	nmap <leader>vu <Plug>VimspectorRunToCursor
endfunction " }}}
