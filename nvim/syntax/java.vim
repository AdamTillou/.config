" ==============================================================================
" Filename:     java.vim
" Description:  Syntax for java
" Author:       Adam Tillou
" ==============================================================================

" Syntax regex {{{1
" Import statements
syn match javaImport '\S*;'
syn match javaClassVariable '[a-zA-Z0-9_]\+\>'

" Special characters
syn match javaSpecialCharacter '[,.;:]'
syn match javaOperator '[!/=+-]'
syn match javaOperator '\*'
syn match javaBracket '[\[\]<>(){}]'

" Keywords
syn keyword javaKeyword final super this return break continue new
syn keyword javaConditionalKeyword if else for while switch case default try catch throw
syn keyword javaMethodType public private protected synchronized static abstract extends implements

" References
syn keyword javaPrimitiveReference void boolean short int long float char
syn keyword javaKeyword import nextgroup=javaImport skipwhite
syn match javaClassReference '\<\u[a-zA-Z0-9_]*\>\ze[^.]'
syn match javaClassCall '\<\u[a-zA-Z0-9_.]*\.' nextgroup=javaMethodCall,javaClassVariable
syn match javaMethodCall '\.\?[a-zA-Z0-9_]\+\s*\ze('
syn match javaVariable '\<\l[a-zA-Z0-9_]*\>\s*\ze[^(]' nextgroup=javaMethodCall

" Objects
syn match javaNumber '\<\d\+\>'
syn keyword javaConstant null
syn keyword javaBoolean true false
syn region javaString start="'" skip="\\'" end="'" contains=javaNumber
syn region javaString start='"' skip='\"' end='"' contains=javaNumber

" Miscellaneous
syn region javaComment start='//' end='$'
syn region javaComment start='/\*' end='\*/'
syn match javaClassDecl '\<class\s\+\u[a-zA-Z0-9_]\+\>'

" Syntax styles {{{1
call g:HL('Normal', '', '', '')

call g:HL('javaSpecialCharacter', g:colors.white, '', '')
call g:HL('javaOperator', g:colors.purple, '', 'bold')
call g:HL('javaBracket', g:colors.white, '', '')

call g:HL('javaKeyword', g:colors.red, '', 'bold')
call g:HL('javaConditionalKeyword', g:colors.yellow, '', 'bold')
call g:HL('javaMethodType', g:colors.red, '', 'bold')

call g:HL('javaPrimitiveReference', g:colors.yellow, '', 'bold')
call g:HL('javaClassReference', g:colors.yellow, '', 'bold')
call g:HL('javaMethodCall', g:colors.blue, '', '')
call g:HL('javaClassCall', g:colors.purple, '', 'bold')
call g:HL('javaClassVariable', g:colors.white, '', '')
call g:HL('javaVariable', g:colors.white, '', '')

call g:HL('javaNumber', g:colors.blue, '', '')
call g:HL('javaConstant', g:colors.cyan, '', '')
call g:HL('javaBoolean', g:colors.cyan, '', '')
call g:HL('javaString', g:colors.green, '', '')

call g:HL('javaClassDecl', g:colors.purple, '', 'bold')
call g:HL('javaComment', g:colors.grey3, '', '')
call g:HL('javaImport', g:colors.white, '', '')
