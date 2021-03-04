" ==============================================================================
" Filename:     plugins.vim
" Description:  Configuration for various plugins
" Author:       Adam Tillou
" ==============================================================================

function! plugins#Initialize()
	" Language support plugins
	call plugins#SetupDeoplete()
	call plugins#SetupUltiSnips()
	call plugins#SetupALE()
	call plugins#SetupVimspector()

	" Miscellaneous plugins
	call plugins#SetupWM()
	call plugins#SetupMultipleCursors()
	call plugins#SetupMarkdownPreview()

	" Seperate plugins
	call plugins#SetupIris()
endfunction 
" Language support plugins
function! plugins#SetupDeoplete() " {{{1
	let g:deoplete#enable_at_startup = 1
	call deoplete#custom#option("auto_complete_delay", 0)
endfunction " }}}
function! plugins#SetupUltiSnips() " {{{1
	let g:UltiSnipsExpandTrigger = "<C-l>"
	let g:UltiSnipsJumpForwardTrigger = "<C-l>"
	let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
endfunction " }}}
function! plugins#SetupALE() " {{{1
	let g:ale_linters = {'python':['flake8']}

	let g:ale_sign_error = ' ✹'
	let g:ale_sign_warning = ' ✹'
	"let g:ale_sign_error = ' ✗'

	hi def link ALEError Error
	hi def link ALEErrorSign Error
	hi def link ALEStyleError StyleError
	hi def link ALEStyleErrorSign StyleError

	hi def link ALEWarning Warning
	hi def link ALEWarningSign Warning
	hi def link ALEStyleWarning Warning
	hi def link ALEStyleWarningSign Warning
endfunction " }}}
function! plugins#SetupVimspector() " {{{1
	let g:vimspector_install_gadgets = [ "debugpy", "vscode-cpp" ]

	let g:plugins#vimspector_templates = [ "python" ]
	let g:plugins#vimspector_active = 0

	" Get the vimspector keyboard shortcuts from the leader menu
	for q in g:leader#mappings
		if q.name == "Vimspector"
			let g:plugins#vimspector_keys = q.command
			break
		endif
	endfor
endfunction

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
		nnoremap q :call leader#SelectMenu("normal", "Vimspector menu", g:plugins#vimspector_keys)<CR>
		nmap Q <Plug>VimspectorStepInto
		call vimspector#Launch()

	else " When deactivating vimspector
		nmap q <Nop>"
		nmap Q <Nop>"
		call vimspector#Reset()
	endif
endfunction " }}}
" }}}

" Miscellaneous plugins
function! plugins#SetupWM() " {{{1
	autocmd! VimEnter * call tiler#TabEnable()

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
	let g:tiler#sidebars = {"filer":"FilerOpen", "taglist":"Tlist", "mundo":"MundoToggle"}

	" Custom colors
	let g:tiler#colors#sidebar = g:colors.sidebar
	let g:tiler#colors#window = g:colors.bg
	let g:tiler#colors#current = g:colors.bg

	" Custom sidebar keybindings
	nnoremap <silent> <A-1> :SidebarOpen filer<CR>
	nnoremap <silent> <A-2> :SidebarOpen taglist<CR>
	nnoremap <silent> <A-3> :SidebarOpen mundo<CR>
endfunction " }}}
function! plugins#SetupMultipleCursors() " {{{1
	" Set custom mappings
	let g:multi_cursor_use_default_mappings = 0
	let g:multi_cursor_start_key = "<Plug>multicursor_s"
	let g:multi_cursor_select_all_word_key = "<Plug>multicursor_a"
	let g:multi_cursor_start_word_key = "<Plug>multicursor_w"
	let g:multi_cursor_select_all_key = "<Plug>multicursor_A"
	let g:multi_cursor_next_key = "<Plug>multicursor_n"
	let g:multi_cursor_prev_key = "<Plug>multicursor_p"
	let g:multi_cursor_quit_key = "<Esc>"
endfunction " }}}
function! plugins#SetupMarkdownPreview() " {{{1
	let g:mkdp_browser = 'surf'
	let g:mkdp_auto_close = 0
	let g:mkdp_page_title = '「${name}」'
	let g:mkdp_filetypes = ['markdown']
	let g:mkdp_highlight_css = '/home/adam/.config/nvim/files/markdown-preview.css'
endfunction
" }}}

" Seperate plugins
function! plugins#SetupIris() " {{{1
	let g:iris_name  = "Adam"
	let g:iris_mail = "adam.tillou@gmail.com"
endfunction
" }}}
