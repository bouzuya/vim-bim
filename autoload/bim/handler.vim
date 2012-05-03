scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

function! bim#handler#ctrl_j(bim, key)
  let b = a:bim
  return "\<C-R>=bim#disable()\<C-m>"
endfunction

function! bim#handler#space(bim, key)
  let b = a:bim
  if strchars(b.raw()) == 0
    return a:key
  endif
  return b.mode('convert').handle(b, a:key)
endfunction

function! bim#handler#slash(bim, key)
  let b = a:bim
  if strchars(b.raw()) == 0
    return a:key
  endif
  return b.mode('direct').handle(b, a:key)
endfunction

function! bim#handler#escape(bim, key)
  call s:set_bim(bim#engine#new())
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
    call s:set_bim(bim#engine#new())
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
    call s:set_bim(bim#engine#new())
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
    call s:set_bim(bim#engine#new())
    return after
  endif
  return ''
endfunction

function! bim#handler#else(bim, key)
  let b = a:bim
  if a:key !~# '^[[:cntrl:]]$'
    call b.input(a:key)
  endif
  call s:echo(b)
  return ''
endfunction

function! bim#handler#c_q(bim, key)
  let b = a:bim
  call b.fix_katakana()
  call b.mode('default')
  call s:echo(b)
  return ''
endfunction

function! bim#handler#c_h(bim, key)
  let b = a:bim
  call b.pager().prev_item()
  call s:echo(b)
  return ''
endfunction

function! bim#handler#c_j(bim, key)
  let b = a:bim
  call b.pager().next_page()
  call s:echo(b)
  return ''
endfunction

function! bim#handler#c_k(bim, key)
  let b = a:bim
  call b.pager().prev_page()
  call s:echo(b)
  return ''
endfunction

function! bim#handler#c_l(bim, key)
  let b = a:bim
  call b.pager().next_item()
  call s:echo(b)
  return ''
endfunction

function! bim#handler#c_space(bim, key)
  let b = a:bim
  call b.pager().next_item()
  call s:echo(b)
  return ''
endfunction

function! bim#handler#c_slash(bim, key)
  let b = a:bim
  return b.mode('direct').handle(b, a:key)
endfunction
function! bim#handler#c_semicolon(bim, key)
  let b = a:bim
  call b.fix()
  call b.mode('default')
  call s:echo(b)
  return ''
endfunction

function! bim#handler#c_else(bim, key)
  call s:echo(a:bim)
  return ''
endfunction

function! bim#handler#d_space(bim, key)
  let b = a:bim
  return b.mode('convert').handle(b, a:key)
endfunction

function! bim#handler#d_slash(bim, key)
  let b = a:bim
  call b.pager().next_item()
  call s:echo(b)
  return ''
endfunction

function! s:echo(bim)
  let save_more = &more
  try
    set nomore
    let b = a:bim
    let p = b.pager()
    let i = p.item()
    let conv = strchars(i) > 0 ? i : b.yomigana()
    let fmt = b.is_okuri() ? '%s[%s]%s| [%s]%s|' : '%s[%s|%s] [%s|]%s'
    let msg = ''
    let msg .= printf(fmt, b.fixed(), conv, b.okurigana(), b.yomi(), b.okuri())
    let msg .= "\n"
    let msg .= printf('(%d/%d)', p.pageidx() + 1, p.pagenum())
    let msg .= '[' . join(map(p.page(), 'printf((v:val ==# i ? ''*%s*'' : '' %s ''), v:val)'), '') . ']'
    redraw | echon msg
  finally
    let &more = save_more
  endtry
endfunction

function! s:set_bim(bim)
  let b:bim = a:bim
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

