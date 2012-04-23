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
    if len(cand) == 0
      let okuri = bim.is_okuri() ? ':' . bim.okuri() : ''
      echomsg printf('%s is not found', bim.yomigana() . okuri)
      return ''
    else
      call s:echo(bim)
    endif
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
    let fixed = bim.fixed()
    call bim.fix()
    if fixed ==# bim.fixed()
      let b:bim = bim#new()
    else
      let fixed = ''
    endif
    call s:echo(bim)
    return fixed
  elseif a:key ==# 'l'
    let result = bim.raw()
    let b:bim = bim#new()
    return result
  elseif a:key ==# 'q'
    let fixed = bim.fixed()
    call bim.fix_katakana()
    if fixed ==# bim.fixed()
      let b:bim = bim#new()
    else
      let fixed = ''
    endif
    call s:echo(bim)
    return fixed
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
    let o = printf('[%s]%s', (is_conv ? bim.kanji() : bim.yomigana()), bim.okurigana())
    let i = printf('[%s]%s', bim.yomi(), bim.okuri())
    let l1 = printf('%s%s|%s', bim.fixed(), o, i)
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

