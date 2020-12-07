"=============================================================================
" FILE: RUNTIME/autoload/ncm2_jc2/autoload/ncm2_jc2.vim
" AUTHOR:  Observer of Time <chronobserver@disroot.org>
" License: MIT license
"=============================================================================

if get(s:, 'loaded', 0)
  finish
endif
let s:loaded = 1

" Complete for local syntax {{{1
function! ncm2_jc2#local_on_complete(ctx) abort
  let base = a:ctx['base']
  let start = javacomplete#complete#complete#Complete(1, base, 0)
  if getline(line('.') - 1) =~? '^\s*@Override\s*$'
    let matches = javacomplete#complete#complete#CompleteAfterOverride()
  else
    let matches = javacomplete#complete#complete#Complete(0, base, 1)
  endif
  
  let local_matches = []
  for q in matches
    if has_key(q, "kind") && q.kind != "m"
      call add(local_matches, q)
    endif
  endfor
  
  call ncm2#complete(a:ctx, start + 1, local_matches)
endfunction

" Complete for java syntax {{{1
function! ncm2_jc2#java_on_complete(ctx) abort
  let base = a:ctx['base']
  let start = javacomplete#complete#complete#Complete(1, base, 0)
  if getline(line('.') - 1) =~? '^\s*@Override\s*$'
    let matches = javacomplete#complete#complete#CompleteAfterOverride()
  else
    let matches = javacomplete#complete#complete#Complete(0, base, 1)
  endif
  
  let java_matches = []
  for q in matches
    if !has_key(q, "kind") || q.kind == "m"
      if has_key(q, "word") && substitute(q.word[0], "\\u", "UPPER", "g") != "UPPER"
        call add(java_matches, q)
      endif
    endif
  endfor
  
  call ncm2#complete(a:ctx, start + 1, java_matches)
endfunction

" Call both sources {{{1
function! ncm2_jc2#init() abort
  call  ncm2#register_source({
        \ 'name': 'javacomplete2_local',
        \ 'mark': 'V',
        \ 'priority': 9,
        \ 'word_pattern': '[@\w_]+',
        \ 'complete_pattern': ['->\s*', '::', '\.',
        \                      '@Override\n\s*'],
        \ 'scope': ['java', 'jsp'],
        \ 'on_complete': 'ncm2_jc2#local_on_complete',
        \ })

  call  ncm2#register_source({
        \ 'name': 'javacomplete2_java',
        \ 'mark': 'J',
        \ 'priority': 8,
        \ 'word_pattern': '[@\w_]+',
        \ 'complete_pattern': ['->\s*', '::', '\.',
        \                      '@Override\n\s*'],
        \ 'scope': ['java', 'jsp'],
        \ 'matcher': 'prefix',
        \ 'on_complete': 'ncm2_jc2#java_on_complete',
        \ })
endfunction

