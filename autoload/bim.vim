scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

let s:HANDLE_KEYS = []
for lhs in split('!"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{}~', '\zs')
  call add(s:HANDLE_KEYS, {'lhs': lhs})
endfor
call add(s:HANDLE_KEYS, {'lhs': '<BS>', 'char': '\<BS>'})
call add(s:HANDLE_KEYS, {'lhs': '<C-h>', 'char': '\<C-h>'})
call add(s:HANDLE_KEYS, {'lhs': '<Space>', 'char': ' '})
call add(s:HANDLE_KEYS, {'lhs': '<Bar>', 'char': '\|'})
call add(s:HANDLE_KEYS, {'lhs': '<C-[>', 'char': '\<C-[>'})
call add(s:HANDLE_KEYS, {'lhs': '<C-m>', 'char': '\<C-m>'})

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
  for key in s:HANDLE_KEYS
    let lhs = key['lhs']
    let rhs = printf('bim#_handle("%s")', get(key, 'char', lhs))
    execute 'lnoremap' '<expr>' lhs rhs
  endfor
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

function! bim#_handle(key)
  let bim = exists('b:bim') ? b:bim : bim#engine#new()
  for k in keys(s:HANDLERS)
    if k ==# a:key
      return s:HANDLERS[k](bim, a:key)
    endif
  endfor
  return bim#handler#else(bim, a:key)
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

