scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

function! bim#is_enabled()
  return &l:iminsert == 1
endfunction

function! bim#enable()
  setlocal iminsert=1
  let b:bim = bim#engine#new()
  call bim#dict#load_all()
  for nr in range(0x01, 0x7F)
    let lhs = printf('<Char-%d>', nr)
    let rhs = printf('bim#_handle(%d)', nr)
    execute 'lnoremap' '<expr>' lhs rhs
  endfor
  execute 'lnoremap' '<expr>' '<BS>' 'bim#_handle(8)'
  execute 'lnoremap' '<expr>' '<Char-30>' 'bim#disable()'
  return ''
endfunction

function! bim#disable()
  setlocal iminsert=0
  unlet! b:bim
  execute 'lmapclear'
  return ''
endfunction

function! bim#toggle()
  if bim#is_enabled()
    return bim#disable()
  else
    return bim#enable()
  endif
endfunction

function! bim#_handle(nr)
  let key = nr2char(a:nr)
  let bim = exists('b:bim') ? b:bim : bim#engine#new()
  return bim.mode().handle(bim, key)
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

