" ==============================================================================
" Filename:     vim.vim
" Description:  Mappings and settings for vim files
" Author:       Adam Tillou
" ==============================================================================

setlocal foldmethod=marker
setlocal foldlevel=0

hi def link vimLet Keyword

if exists('g:num')
	let g:num += 1
else
	let g:num = 0
endif
