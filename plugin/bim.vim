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

function! s:is_enabled()
  return &l:iminsert == 1
endfunction

function! s:enable()
  setlocal iminsert=1
  let b:bim = bim#new()
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
  if a:key == ' '
    if strchars(bim.raw()) == 0
      return ' '
    endif
    call bim.convert()
    let cand = bim.candidate()
    call s:echo(bim)
  elseif a:key ==# "\<C-[>"
    let b:bim = bim#new()
    return a:key
  elseif a:key ==# "\<C-h>" || a:key ==# "\<BS>"
    if strchars(bim.raw()) > 0
      call bim.remove_last()
      call s:echo(bim)
      return ''
    else
      return a:key
    endif
  elseif a:key ==# ':'
    if strchars(bim.raw()) == 0
      return ':'
    endif
    call bim.start_okuri()
    call s:echo(bim)
    return ''
  elseif a:key ==# ';' || a:key ==# "\<C-m>"
    let before = bim.fixed()
    call bim.fix()
    let after = bim.fixed()
    if strchars(after) == 0
      return a:key
    elseif before !=# after
      call s:echo(bim)
      return ''
    else
      let b:bim = bim#new()
      return after
    endif
  elseif a:key ==# 'l'
    let before = bim.fixed()
    call bim.fix_raw()
    let after = bim.fixed()
    if strchars(after) == 0
      return a:key
    elseif before !=# after
      call s:echo(bim)
      return ''
    else
      let b:bim = bim#new()
      return after
    endif
  elseif a:key ==# 'q'
    let before = bim.fixed()
    call bim.fix_katakana()
    let after = bim.fixed()
    if strchars(after) == 0
      return a:key
    elseif before !=# after
      call s:echo(bim)
      return ''
    else
      let b:bim = bim#new()
      return after
    endif
  else
    call bim.input(a:key)
    call s:echo(bim)
  endif
  return ''
endfunction

function! s:proc2(arg)
  return {'result': ''}
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
    let n = 7
    let pages = s:paging(cand, n)
    let k = bim.kanji()
    let idx = is_conv ? index(cand, bim.kanji()) : -1
    let l2 = printf('(%d/%d)', (idx / n + 1), len(pages))
    let l2 .= '[' . join(map(get(pages, idx / n, []), 'printf((v:val ==# k ? ''*%s*'' : '' %s ''), v:val)'), '') . ']'
    redraw | echon l1 . "\n" . l2
  finally
    let &more = save_more
  endtry
endfunction

function! s:paging(list, n)
  if empty(a:list)
    return [[]]
  endif

  let pages = []
  for i in range(0, len(a:list) - 1, a:n)
    call add(pages, a:list[i : (i + a:n - 1)])
  endfor
  return pages
endfunction

command! BimIsEnabled
      \ call s:is_enabled()

command! BimEnable
      \ call s:enable()

command! BimDisable
      \ call s:disable()

command! BimToggle
      \ call s:toggle()

" autocmd VimLeave * call bim#dict#save()

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

