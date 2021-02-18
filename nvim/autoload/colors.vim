" ==============================================================================
" Filename:     colors.vim
" Description:  Syntax colors and styles
" Author:       Adam Tillou
" ==============================================================================

function! colors#Initialize()
	" Prepare for setting up colors
	highlight clear
	syntax on
	syntax reset
	set t_Co=256
	filetype plugin on
	set background=dark
	
	call colors#ColorVariables()
	call colors#ColorGroups()
endfunction
" }}}

" }}}

function! g:HL(group, fg, bg, attr) " {{{1
	if type(a:fg) == type({})
		exec "hi " . a:group . " guifg=" . a:fg.gui . " ctermfg=" . a:fg.cterm
	endif

	if type(a:bg) == type({})
		exec "hi " . a:group . " guibg=" . a:bg.gui . " ctermbg=" . a:bg.cterm
	endif

	let attr = (a:attr == "") ? "NONE" : a:attr
	exec "hi " . a:group . " gui=" . attr . " cterm=" . attr
endfunction " }}}
function! colors#ColorVariables() " {{{1
	let g:colors = {}
	let g:colors.fg = {"gui": "#D0D0D0", "cterm": "NONE"}
	let g:colors.white = {"gui": "#D3D7DB", "cterm": "188"}
	let g:colors.grey1 = {"gui": "#A4A8AC", "cterm": "248"}
	let g:colors.grey2 = {"gui": "#7C8084", "cterm": "244"}
	let g:colors.grey3 = {"gui": "#30343C", "cterm": "238"}
	let g:colors.black = {"gui": "#0E1216", "cterm": "233"}
	let g:colors.red = {"gui": "#D75F5F", "cterm": "167"}
	let g:colors.yellow = {"gui": "#FFD75F", "cterm": "221"}
	let g:colors.green = {"gui": "#5FFF5F", "cterm": "083"}
	let g:colors.cyan = {"gui": "#5FFFD7", "cterm": "086"}
	let g:colors.blue = {"gui": "#5FAFD7", "cterm": "074"}
	let g:colors.purple = {"gui": "#AF87D7", "cterm": "140"}

	let g:colors.sidebar = {"gui": "#222630", "cterm": "NONE"}
	let g:colors.bg = {"gui": "#293039", "cterm": "8"}
	let g:colors.active_bg = g:colors.bg
	let g:colors.popup = {"gui": "#30343C", "cterm": "239"}
endfunction " }}}
function! colors#ColorGroups() " {{{1
	" Sidebar groups
	call g:HL("Sidebar", g:colors.fg, g:colors.sidebar, "")
	call g:HL("SidebarEOB", g:colors.sidebar, g:colors.sidebar, "")
	call g:HL("SidebarFold", g:colors.grey2, g:colors.sidebar, "")
	call g:HL("SidebarSignColumn", "", g:colors.sidebar, "")
	
	" Style highlight groups
	call g:HL("Bold", g:colors.fg, g:colors.bg, "bold")
	call g:HL("Italic", g:colors.fg, g:colors.bg, "italic")
	call g:HL("Underline", g:colors.bg, g:colors.bg, "underline")

	" Default highlight groups
	call g:HL("Normal", g:colors.fg, g:colors.bg, "")
	call g:HL("NormalFloat", g:colors.fg, g:colors.bg, "")
	call g:HL("NonText", g:colors.grey2, "", "")
	call g:HL("EndOfBuffer", g:colors.grey2, "", "")
	call g:HL("MsgArea", "", "", "")

	call g:HL("Cursor", "", g:colors.grey2, "")
	call g:HL("CursorColumn", "", "", "")
	call g:HL("CursorLine", "", "", "bold")
	call g:HL("LineNr", g:colors.grey2, "", "")
	call g:HL("CursorLineNr", g:colors.fg, "", "bold")

	call g:HL("DiffAdd", g:colors.fg, "", "")
	call g:HL("DiffChange", g:colors.fg, "", "")
	call g:HL("DiffDelete", g:colors.red, "", "")
	call g:HL("DiffText", g:colors.blue, "", "")
	call g:HL("ModeMsg", g:colors.yellow, "", "")
	call g:HL("MoreMsg", g:colors.yellow, "", "")
	call g:HL("WarningMsg", g:colors.yellow, "", "italic")
	call g:HL("Question", g:colors.purple, "", "")
	call g:HL("MatchParen", g:colors.fg, g:colors.purple, "bold")

	call g:HL("Pmenu", g:colors.fg, g:colors.popup, "")
	call g:HL("PmenuSel", g:colors.black, g:colors.blue, "bold")
	call g:HL("PmenuSbar", "", "", "")
	call g:HL("PmenuThumb", "", g:colors.white, "")

	call g:HL("SpellBad", g:colors.red, "", "")
	call g:HL("SpellCap", g:colors.yellow, "", "")
	call g:HL("SpellLocal", g:colors.yellow, "", "")
	call g:HL("SpellRare", g:colors.yellow, "", "")

	call g:HL("StatusLine", g:colors.fg, g:colors.bg, "bold")
	call g:HL("StatusLineNC", g:colors.grey2, g:colors.bg, "underline")
	call g:HL("TabLine", g:colors.fg, "", "none")
	call g:HL("TabLineSel", g:colors.fg, "", "bold")
	call g:HL("TabLineFill", "", "", "none")

	call g:HL("Visual", "", g:colors.popup, "")
	call g:HL("VisualNOS", "", "", "")

	call g:HL("ColorColumn", "", "", "")
	call g:HL("Conceal", g:colors.fg, g:colors.bg, "")
	call g:HL("Directory", g:colors.blue, "", "")
	call g:HL("VertSplit", g:colors.grey2, g:colors.bg, "")
	call g:HL("Folded", g:colors.grey2, g:colors.bg, "")
	call g:HL("FoldColumn", g:colors.grey2, g:colors.bg, "")
	call g:HL("SignColumn", "", g:colors.bg, "")

	call g:HL("SpecialKey", g:colors.grey2, "", "")
	call g:HL("Title", g:colors.green, "", "")
	call g:HL("WildMenu", g:colors.fg, "", "")

	call g:HL("Comment", g:colors.grey2, "", "italic")
	call g:HL("SpecialComment", g:colors.grey2, "", "italic,bold")
	call g:HL("String", g:colors.green, "", "")
	call g:HL("Character", g:colors.green, "", "")
	call g:HL("Constant", "", "", "")
	call g:HL("Number", "", "", "")
	call g:HL("Boolean", "", "", "")
	call g:HL("Float", "", "", "")
	call g:HL("Special", g:colors.yellow, "", "bold")

	call g:HL("Conditional", g:colors.yellow, "", "bold")
	call g:HL("Repeat", g:colors.yellow, "", "bold")
	call g:HL("Label", g:colors.yellow, "", "bold")
	call g:HL("Keyword", g:colors.yellow, "", "bold")
	call g:HL("Exception", g:colors.yellow, "", "bold")

	call g:HL("Identifier", g:colors.fg, "", "")
	call g:HL("Function", g:colors.blue, "", "")
	call g:HL("Statement", g:colors.red, "", "bold")

	call g:HL("PreProc", g:colors.yellow, "", "")
	call g:HL("Include", g:colors.yellow, "", "")
	call g:HL("Define", g:colors.yellow, "", "")
	call g:HL("Macro", g:colors.yellow, "", "")
	call g:HL("PreCondit", g:colors.yellow, "", "")

	call g:HL("Type", g:colors.yellow, "", "")
	call g:HL("StorageClass", g:colors.red, "", "")
	call g:HL("Structure", g:colors.yellow, "", "")
	call g:HL("Typedef", g:colors.yellow, "", "")

	call g:HL("Operator", g:colors.purple, "", "bold")
	call g:HL("SpecialChar", g:colors.fg, "", "")
	call g:HL("Tag", g:colors.fg, "", "")
	call g:HL("Delimiter", g:colors.fg, "", "")
	call g:HL("Debug", g:colors.yellow, "", "")
	call g:HL("Underlined", g:colors.yellow, "", "")
	call g:HL("Ignore", g:colors.yellow, "", "")
	call g:HL("Todo", g:colors.yellow, "", "")

	call g:HL("Error", {"gui":"#FF0000", "cterm":196}, g:colors.bg, "italic")
	call g:HL("Warning", {"gui":"#FFFF00", "cterm":226}, g:colors.bg, "italic")
	call g:HL("StyleError", {"gui":"#FF5F00", "cterm":202}, g:colors.bg, "italic")
endfunction " }}}
