scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

let s:HANDLERS = {
      \ ' ': function('bim#handler#space'),
      \ "\<C-[>": function('bim#handler#escape'),
      \ "\<C-h>": function('bim#handler#backspace'),
      \ "\<BS>": function('bim#handler#backspace'),
      \ ':': function('bim#handler#colon'),
      \ ';': function('bim#handler#semicolon'),
      \ "\<C-m>": function('bim#handler#semicolon'),
      \ 'l': function('bim#handler#l'),
      \ 'q': function('bim#handler#q')
      \ }

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
endfunction

function! bim#disable()
  setlocal iminsert=0
  unlet! b:bim
  execute 'lmapclear' '<buffer>'
endfunction

function! bim#toggle()
  if bim#is_enabled()
    call bim#disable()
  else
    call bim#enable()
  endif
endfunction

function! bim#_handle(nr)
  let key = nr2char(a:nr)
  let bim = exists('b:bim') ? b:bim : bim#engine#new()
  return get(s:HANDLERS, key, function('bim#handler#else'))(bim, key)
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

