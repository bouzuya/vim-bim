scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

function! bim#option#get(name)
  if !exists('g:bim')
    let g:bim = {
          \ 'dict_path': '~/SKK-JISYO.S.utf8'
          \ 'user_dict_path': '~/.vim-bim-jisyo'
          \ }
  endif
  return get(g:bim, a:name, '')
endfunction

function! bim#option#get_path(name)
  let path = bim#option#get(a:name . '_path')
  return expand(path)
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

