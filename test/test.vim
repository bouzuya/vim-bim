scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

function! s:test()
  let dir = expand('<sfile>:p:h') . '/'
  let files = ['bim.vim', 'dict.vim', 'raw.vim']
  for file in files
    let path = fnamemodify(dir . file, ':p')
    execute 'source' path
  endfor
endfunction

if has('vim_starting')
  try
    call s:test()
    quit
  catch
    cquit
  endtry
else
  call s:test()
endif

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

