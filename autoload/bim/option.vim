scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

function! bim#option#get(name)
  if !exists('g:bim')
    let g:bim = {}
  endif
  return get(g:bim, a:name, '')
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

