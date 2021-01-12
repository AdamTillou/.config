" ==============================================================================
" Filename:     note.vim
" Description:  Syntax for notes
" Author:       Adam Tillou
" ==============================================================================

" Set fold settings
setlocal foldmethod=indent
setlocal foldlevel=0

" Parse syntax groups
syn match noteTopicText '.*'
syn match noteSectionText '.*'

syn match Normal '.*'

syn match noteTitle '\~\~\~.*\~\~\~'
syn match noteTopicIcon '^# ' nextgroup=noteTopicText
syn match noteSectionIcon '^\* ' nextgroup=noteSectionText
syn match noteDefinition '^\s*.*\S:\ze '

" Set different effects for each group
call g:HL('noteTopicIcon', '', '', 'bold')
call g:HL('noteSectionIcon', '', '', 'bold')

call g:HL('noteTitle', '', '', 'bold,underline,italic')
call g:HL('noteTopicText', '', '', 'bold,underline')
call g:HL('noteSectionText', '', '', 'bold,italic')

call g:HL('noteDefinition', '', '', 'bold')
