function! plugins#Initialize()

	" Functions to set up various plugins
	call plugins#SetupAirline()
	call plugins#SetupVimspector()
	call plugins#SetupMultipleCursors()
	call plugins#SetupUltiSnips()
	call plugins#SetupNCM2()
	call plugins#SetupALE()
	call plugins#SetupWM()
endfunction 


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
	call add(g:wm_sidebar.bars, {"name":"filetree", "command":"call filetree#Initialize()"})
	call add(g:wm_sidebar.bars, {"name":"taglist", "command":"Tlist"})
	call add(g:wm_sidebar.bars, {"name":"mundo", "command":"MundoToggle"})
	" Custom sidebar keybindings
	nnoremap <silent> <F13> :SidebarOpen filetree<CR>
	nnoremap <silent> <F14> :SidebarOpen taglist<CR>
	nnoremap <silent> <F15> :SidebarOpen mundo<CR>

	nnoremap <silent> <S-F1> :SidebarOpen filetree<CR>
	nnoremap <silent> <S-F2> :SidebarOpen taglist<CR>
	nnoremap <silent> <S-F3> :SidebarOpen mundo<CR>
endfunction " }}}
function! plugins#SetupALE() " {{{1
	let g:ale_sign_column_always = 1
	let g:ale_sign_error = '>>'
	let g:ale_sign_warning = '--'

	nnoremap <silent> <leader>e :ALENextWrap<CR>

	" Change highlighting colors of errors and warnings
	highlight def link ALEError Error 
	highlight def link ALEWarning ANonexistentHighlightGroupSoWarningsDontShowUp
	exec "highlight Todo ctermbg=" . g:colors.bg.cterm . " ctermfg=" . g:colors.bg.cterm

	" Automatically update while typing in insert mode
	" autocmd CursorMovedI * call feedkeys("i")
endfunction " }}}
function! plugins#SetupNCM2() " {{{1
	" Load autocompletion sources
	set completeopt=noinsert,menuone,noselect

	" Store whether ncm2 is enabled in each buffer
	let g:ncm2_enabled = {}

	" Enable ncm2 by default in each new buffer
	let g:ncm2_enabled.1 = 1
	call ncm2#enable_for_buffer()

	autocmd BufNew * let g:ncm2_enabled[bufnr('.')] = 1
	autocmd BufNew * call ncm2#enable_for_buffer()

	" Search for autocompletion after 1 character typed
	let g:ncm2#complete_length = 1
endfunction

function! plugins#NCM2Toggle()
	if g:ncm2_enabled[bufnr('.')] 
		call ncm2#disable_for_buffer() 
	else 
		call ncm2#enable_for_buffer() 
	endif
	let g:ncm2_enabled[bufnr('.')] = !g:ncm2_enabled[bufnr('.')]
endfunction " }}}
function! plugins#SetupUltiSnips() " {{{1
	let g:UltiSnipsExpandTrigger = "<Tab>"
	let g:UltiSnipsJumpForwardTrigger = "<Tab>"
	let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
	let g:UltiSnipsListSnippets = "<F2>"

	" Add snippets to autocomplete
	let ncm2_ultisnips_source = {
				\ 'name': 'Snippets',
				\ 'complete_length': 1,
				\ 'matcher': 'prefix',
				\ 'mark': 'S',
				\ 'priority': 9,
				\ 'on_complete': {c -> ncm2#complete(c,
				\       c.startccol, [])}
				\ }
	call ncm2#register_source(ncm2_ultisnips_source)

	autocmd BufEnter * call g:UltisnipsAutocomplete()

	let g:filetype_snippets = {}
	function! g:UltisnipsAutocomplete()
		let name_split = split(@%, "\\.")
		if @% == "" || len(name_split) == 1
			let extension = ""
		else
			let extension = name_split[-1]
		endif


		if has_key(g:filetype_snippets, extension)
			let snippet_list = g:filetype_snippets

		else
			call UltiSnips#SnippetsInCurrentScope(1)
			let output = g:current_ulti_dict_info
			let snippet_names = keys(output)
			let snippet_list = []
			for q in snippet_names
				let dict = {"word":q, "menu":output[q].description}
				call add(snippet_list, dict)
			endfor
			let g:filetype_snippets[extension] = snippet_list
		endif

		call ncm2#override_source('Snippets', {'on_complete': {c -> ncm2#complete(c, c.startccol, snippet_list)}})
	endfunction
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
function! plugins#SetupAirline() " {{{1
	" Set settings
	let g:airline#extensions#tabline#enabled = 1
	let g:airline_detect_modified=1

	let g:airline_left_sep  = "◣"
	let g:airline_right_sep = "◢"

	" Automatically detect when there is a different number of errors and refresh
	autocmd User ALELintPost call plugins#DetectStatuslineRefresh() 

	" Add the statusline
	call airline#add_statusline_func("plugins#AirlineLayout")
	call airline#add_inactive_statusline_func("plugins#AirlineLayout")
endfunction

" Set the layout
function! plugins#AirlineLayout(...)
	let buffer = a:1._context.bufnr

	" Left side modules
	" Mode module
	call a:1.add_section("StatuslineColor1", " %-0{substitute(mode(), '.*', '\\U&', 'g')} ")
	call a:1.add_section("StatuslineColor2", " %t ")

	" First error module
	if ale#statusline#Count(buffer).error + ale#statusline#Count(buffer).style_error > 0
		let reg_error_msg = ale#statusline#FirstProblem(buffer, "error")
		let style_error_msg = ale#statusline#FirstProblem(buffer, "error")
		if reg_error_msg != {} && (style_error_msg == {} || style_error_msg.lnum >= reg_error_msg.lnum)
			let error_msg = reg_error_msg
		else
			let error_msg = style_error_msg
		endif
		call a:1.add_section("StatuslineFirstError", " L" . error_msg.lnum . ": " . error_msg.text)
	else
		call a:1.add_section("Statusline", "   ")
	endif

	call a:1.split()

	" Right side modules
	" Errors/warnings module
	let error_ct = "%-0{ale#statusline#Count(" . buffer . ").error + ale#statusline#Count(" . buffer . ").style_error}"
	let warning_ct = "%-0{ale#statusline#Count(" . buffer . ").warning + ale#statusline#Count(" . buffer . ").style_warning}"
	call a:1.add_section("StatuslineColor2", " %#StatuslineError# " . error_ct . "  %#StatuslineWarning# " . warning_ct . " ")

	" Line number module
	call a:1.add_section("StatuslineColor1", " %l,%c  %p%-0{'%'} ")

	" Return statement
	let g:arg = a:1._context
	return 1
endfunction

function! plugins#DetectStatuslineRefresh()
	if !exists("ale_error_count")
		let ale_error_count = {}
	endif

	if !has_key(ale_error_count, bufnr()) 
		let ale_error_count[bufnr()] = ale#statusline#Count(bufnr()).error
		AirlineRefresh
	elseif ale_error_count[bufnr()] != ale#statusline#Count(bufnr()).error
		let ale_error_count[bufnr()] = ale#statusline#Count(bufnr()).error
		AirlineRefresh
	endif
endfunction

" }}}
