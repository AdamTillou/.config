" ==============================================================================
" Filename:			superman.vim
" Description:	A red, yellow, and blue based colorscheme for vim
" Author:				Adam Tillou
" ==============================================================================

highlight clear
syntax reset
set background=dark

" Create color variables {{{1
let g:colors = {}
let g:colors.white = {"gui": "#D3D7DB", "cterm": "188"}
let g:colors.grey1 = {"gui": "#A4A8AC", "cterm": "248"}
let g:colors.grey2 = {"gui": "#7C8084", "cterm": "244"}
let g:colors.grey3 = {"gui": "#4A4E52", "cterm": "239"}
let g:colors.grey4 = {"gui": "#2C3034", "cterm": "236"}
let g:colors.black = {"gui": "#0E1216", "cterm": "233"}
let g:colors.red = {"gui": "#D75F5F", "cterm": "167"}
let g:colors.yellow = {"gui": "#FFD75F", "cterm": "221"}
let g:colors.green = {"gui": "#5FFF5F", "cterm": "083"}
let g:colors.cyan = {"gui": "#5FFFD7", "cterm": "086"}
let g:colors.blue = {"gui": "#5FAFD7", "cterm": "074"}
let g:colors.purple = {"gui": "#AF87D7", "cterm": "140"}

let g:colors.fg = {"gui": "#D0D0D0", "cterm": "188"}
let g:colors.bg = {"gui": "#1C202B", "cterm": "none"}
let g:colors.active_bg = {"gui": "#2E343C", "cterm": "none"}
let g:colors.sidebar = {"gui": "#121414", "cterm": "none"}

" Color highlighting function {{{1
function! g:HL(group, fg, bg, attr)
	if type(a:fg) == type({})
		exec "hi " . a:group . " guifg=" . a:fg.gui . " ctermfg=" . a:fg.cterm
	endif
	if type(a:bg) == type({})
		exec "hi " . a:group . " guibg=" . a:bg.gui . " ctermbg=" . a:bg.cterm
	endif
	if a:attr != ""
		exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
	endif
endfun

" Color group highlighting {{{1
call g:HL("Normal", g:colors.fg, g:colors.bg, "")
call g:HL("NonText", g:colors.grey2, "", "")

call g:HL("Cursor", "", g:colors.grey2, "")
call g:HL("CursorColumn", "", "", "")
call g:HL("CursorLine", "", g:colors.grey4, "bold")
call g:HL("LineNr", g:colors.grey2, "", "")
call g:HL("CursorLineNr", g:colors.white, g:colors.grey3, "bold")
call g:HL("EndOfBuffer", g:colors.bg, "", "")

call g:HL("DiffAdd", g:colors.white, "", "")
call g:HL("DiffChange", g:colors.white, "", "")
call g:HL("DiffDelete", g:colors.red, "", "")
call g:HL("DiffText", g:colors.blue, "", "")
call g:HL("ModeMsg", g:colors.yellow, "", "")
call g:HL("MoreMsg", g:colors.yellow, "", "")
call g:HL("WarningMsg", g:colors.yellow, "", "")
call g:HL("Question", g:colors.purple, "", "")

call g:HL("Pmenu", g:colors.white, g:colors.grey3, "")
call g:HL("PmenuSel", g:colors.black, g:colors.blue, "bold")
call g:HL("PmenuSbar", "", "", "")
call g:HL("PmenuThumb", "", g:colors.white, "")

call g:HL("SpellBad", g:colors.red, "", "")
call g:HL("SpellCap", g:colors.yellow, "", "")
call g:HL("SpellLocal", g:colors.yellow, "", "")
call g:HL("SpellRare", g:colors.yellow, "", "")

call g:HL("StatusLine", g:colors.grey1, g:colors.bg, "bold,underline")
call g:HL("StatusLineNC", g:colors.grey2, g:colors.bg, "underline")
call g:HL("TabLine", g:colors.fg, g:colors.bg, "none")
call g:HL("TabLineSel", g:colors.white, g:colors.bg, "bold")
call g:HL("TabLineFill", "", "", "none")

call g:HL("Visual", "", g:colors.grey3, "")
call g:HL("VisualNOS", "", "", "")

call g:HL("ColorColumn", "", "", "")
call g:HL("Conceal", g:colors.white, "", "")
call g:HL("Directory", g:colors.red, "", "")
call g:HL("Executable", g:colors.green, "", "")
call g:HL("VertSplit", g:colors.grey2, "", "none")
call g:HL("Folded", g:colors.grey2, g:colors.bg, "")
call g:HL("FoldColumn", g:colors.grey2, g:colors.bg, "")
call g:HL("SignColumn", g:colors.grey2, "", "")

call g:HL("SpecialKey", g:colors.grey2, "", "")
call g:HL("Title", g:colors.green, "", "")
call g:HL("WildMenu", g:colors.white, "", "")

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

call g:HL("Identifier", g:colors.white, "", "")
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
call g:HL("SpecialChar", g:colors.white, "", "")
call g:HL("Tag", g:colors.white, "", "")
call g:HL("Delimiter", g:colors.white, "", "")
call g:HL("Debug", g:colors.yellow, "", "")
call g:HL("Underlined", g:colors.yellow, "", "")
call g:HL("Ignore", g:colors.yellow, "", "")
call g:HL("Error", g:colors.white, g:colors.red, "")
call g:HL("Todo", g:colors.yellow, "", "")
