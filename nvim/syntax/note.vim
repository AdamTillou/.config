" ==============================================================================
" Filename:     note.vim
" Description:  Syntax for notes
" Author:       Adam Tillou
" ==============================================================================

" Set basic preferences
setlocal foldmethod=indent
setlocal foldlevel=0
setlocal tabstop=4
setlocal shiftwidth=4
setlocal wrap

" Bullet mapping
noremap <silent> ` <Esc>mz:s/^\s*\zs[^•^	]/• &/<CR>:s/^\s*\zs• //<CR>

" Parse syntax groups
syn match noteTitle '^\s*\~\~\~.*\~\~\~'
syn match noteTopic '^\s*\*.*'
syn match noteSection '^\s*>.*'
syn match noteDefinition '^\s*.*\S:\ze '

" Set different effects for each group
call g:HL('noteTitle', '', '', 'bold,underline')
call g:HL('noteTopic', '', '', 'bold,underline')
call g:HL('noteSection', '', '', 'bold,italic')

call g:HL('noteDefinition', '', '', 'bold')
