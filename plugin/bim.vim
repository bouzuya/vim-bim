scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

let s:HANDLE_KEYS = []
for lhs in split('!"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{}~', '\zs')
  call add(s:HANDLE_KEYS, {'lhs': lhs})
endfor
" call add(s:HANDLE_KEYS, {'lhs': '<BS>', 'char': "\<BS>"})
" call add(s:HANDLE_KEYS, {'lhs': '<C-h>', 'char': "\<C-h>"})
call add(s:HANDLE_KEYS, {'lhs': '<Space>', 'char': ' '})
call add(s:HANDLE_KEYS, {'lhs': '<Bar>', 'char': '\|'})
call add(s:HANDLE_KEYS, {'lhs': '<Esc>', 'char': "\<C-[>"})

function! s:is_enabled()
  return &l:iminsert == 1
endfunction

function! s:enable()
  setlocal iminsert=1

  call s:load_dict()

  let b:bim = bim#new()
  for key in s:HANDLE_KEYS
    let lhs = key['lhs']
    let rhs = printf('<SID>proc(''%s'')', get(key, 'char', lhs))
    execute 'lnoremap' '<buffer>' '<expr>' lhs rhs
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
      echomsg printf('%s is not found', keyword)
      return ''
    else
      let okuri = bim.is_okuri() ? '*' . bim.okuri() : ''
      let msg = printf('%s%s|%s|%s', bim.yomigana(), okuri, bim.kanji(), string(cand))
      redraw | echon msg
    endif
  elseif a:key ==# "\<C-[>"
    let b:bim = bim#new()
    return a:key
  elseif a:key ==# ':'
    if strchars(bim.raw()) == 0
      return ':'
    endif
    call bim.start_okuri()
    call s:echo(bim)
    return ''
  elseif a:key ==# ';'
    let result = bim.kanji()
    if strchars(result) == 0
      let result = bim.yomigana() . bim.okurigana()
    else
      call bim#dict#add_word(bim.yomigana(), result)
    endif
    let b:bim = bim#new()
    return result
  elseif a:key ==# 'l'
    let result = bim.raw()
    let b:bim = bim#new()
    return result
  elseif a:key ==# 'q'
    let h = bim.yomigana()
    let b:bim = bim#new()
    return bim#hiragana2katakana(h)
  else
    if bim.is_okuri() && strlen(bim.okuri()) > 0
      return s:proc(' ') " convert
    endif
    call bim.input(a:key)
    call s:echo(bim)
  endif
  return ''
endfunction

function! s:echo(bim)
  let bim = a:bim
  let marker = ':'
  let kana = bim.yomigana() . (bim.is_okuri() ? marker . bim.okurigana() : '')
  let roma = bim.yomi() . (bim.is_okuri() ? marker . bim.okuri() : '')
  redraw | echon printf('%s|%s', kana, roma)
endfunction

function! s:load_dict()
  let dict = bim#option#get_path('dict')
  call bim#dict#load(dict)
  let user_dict = bim#option#get_path('user_dict')
  call bim#dict#load_user_dict(user_dict)
endfunction

command! BimIsEnabled
      \ call s:is_enabled()

command! BimEnable
      \ call s:enable()

command! BimDisable
      \ call s:disable()

command! BimToggle
      \ call s:toggle()

autocmd VimLeave * call bim#dict#save()

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

