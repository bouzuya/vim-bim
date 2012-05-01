scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

function! bim#handler#space(bim, key)
  let b = a:bim
  if strchars(b.raw()) == 0
    return ' '
  endif
  call b.convert()
  call s:echo(b)
  return ''
endfunction

function! bim#handler#escape(bim, key)
  call s:set_bim(bim#new())
  return a:key
endfunction

function! bim#handler#backspace(bim, key)
  let b = a:bim
  if strchars(b.fixed()) > 0
    call s:echo(b)
    return ''
  elseif strchars(b.raw()) > 0
    call b.remove_last()
    call s:echo(b)
    return ''
  else
    return a:key
  endif
  throw 'bim:unreachable code'
endfunction

function! bim#handler#colon(bim, key)
  let b = a:bim
  if strchars(b.fixed()) == 0 && strchars(b.raw()) == 0
    return a:key
  endif
  if strchars(b.raw()) != 0 && !b.is_okuri()
    call b.start_okuri()
  endif
  call s:echo(b)
  return ''
endfunction

function! bim#handler#semicolon(bim, key)
  let b = a:bim
  let before = b.fixed()
  if strchars(before) == 0 && strchars(b.raw()) == 0
    return a:key
  endif
  call b.fix()
  let after = b.fixed()
  if strchars(after) == 0
    return ''
  elseif before !=# after
    call s:echo(b)
    return ''
  else
    call s:set_bim(bim#new())
    return after
  endif
  return ''
endfunction

function! bim#handler#l(bim, key)
  let b = a:bim
  let before = b.fixed()
  call b.fix_raw()
  let after = b.fixed()
  if strchars(after) == 0
    return a:key
  elseif before !=# after
    call s:echo(b)
    return ''
  else
    call s:set_bim(bim#new())
    return after
  endif
  return ''
endfunction

function! bim#handler#q(bim, key)
  let b = a:bim
  let before = b.fixed()
  call b.fix_katakana()
  let after = b.fixed()
  if strchars(after) == 0
    return a:key
  elseif before !=# after
    call s:echo(b)
    return ''
  else
    call s:set_bim(bim#new())
    return after
  endif
  return ''
endfunction

function! bim#handler#else(bim, key)
  let b = a:bim
  call b.input(a:key)
  call s:echo(b)
  return ''
endfunction

function! s:echo(bim)
  let save_more = &more
  try
    set nomore
    let bim = a:bim
    let is_conv = strchars(bim.kanji()) > 0
    let conv = is_conv ? bim.kanji() : bim.yomigana()
    let fmt = bim.is_okuri() ? '%s[%s]%s| [%s]%s|' : '%s[%s|%s] [%s|]%s'
    let l1 = printf(fmt, bim.fixed(), conv, bim.okurigana(), bim.yomi(), bim.okuri())
    let cand = bim.candidate()
    let k = bim.kanji()
    let idx = is_conv ? index(cand, k) : -1
    let pager = bim#pager#new(cand, 7, idx)
    let l2 = printf('(%d/%d)', pager.pageidx() + 1, pager.pagenum())
    let l2 .= '[' . join(map(pager.page(), 'printf((v:val ==# k ? ''*%s*'' : '' %s ''), v:val)'), '') . ']'
    redraw | echon l1 . "\n" . l2
  finally
    let &more = save_more
  endtry
endfunction

function! s:set_bim(bim)
  let b:bim = a:bim
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

