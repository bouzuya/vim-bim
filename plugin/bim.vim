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

function! s:is_enabled()
  return &l:iminsert == 1
endfunction

function! s:enable()
  setlocal iminsert=1
  let b:bim = bim#new()
  call bim#dict#load_all()
  for key in s:HANDLE_KEYS
    let lhs = key['lhs']
    let rhs = printf('<SID>proc("%s")', get(key, 'char', lhs))
    execute 'lnoremap' '<expr>' lhs rhs
  endfor
endfunction

function! s:disable()
  setlocal iminsert=0
  unlet! b:bim
  execute 'lmapclear' '<buffer>'
endfunction

function! s:toggle()
  if s:is_enabled()
    call s:disable()
  else
    call s:enable()
  endif
endfunction

function! s:proc(key)
  let bim = exists('b:bim') ? b:bim : bim#new()
  for k in keys(s:HANDLERS)
    if k ==# a:key
      return s:HANDLERS[k](bim, a:key)
    endif
  endfor
  return bim#handler#else(bim, a:key)
endfunction

function! s:add_word()
  let yomigana = input('読み仮名 ?')
  if strchars(yomigana) == 0
    return
  endif
  let okuri = input('送り仮名の先頭一文字(ローマ字) ?')
  if strchars(okuri) > 0 && okuri !~# '^[a-z]$'
    return
  endif
  let kanji = input('漢字 ?')
  if strchars(kanji) == 0
    return
  endif
  call bim#dict#add_word(yomigana . okuri, kanji)
endfunction

command! BimEnable
      \ call s:enable()

command! BimDisable
      \ call s:disable()

command! BimToggle
      \ call s:toggle()

command! BimAddWord
      \ call s:add_word()

" autocmd VimLeave * call bim#dict#save()

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

