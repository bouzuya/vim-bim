scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

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
      \ call bim#enable()

command! BimDisable
      \ call bim#disable()

command! BimToggle
      \ call bim#toggle()

command! BimAddWord
      \ call s:add_word()

autocmd VimLeave * call bim#dict#save()

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

