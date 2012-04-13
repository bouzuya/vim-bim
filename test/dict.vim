scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

function! s:test1()
  call bim#dict#clear_all_entries()
  call bim#dict#add_word('かんじ', '漢字')
  call bim#assert#contains('漢字', bim#dict#search('かんじ'))
  call bim#dict#add_word('かんじ', '幹事')
  let result = bim#dict#search('かんじ')
  call bim#assert#contains('漢字', result)
  call bim#assert#contains('幹事', result)
endfunction

let s:test2_data_path = fnamemodify(expand('<sfile>:p') . '.data', ':p')
function! s:test2()
  call bim#dict#clear_all_entries()
  call bim#dict#load(s:test2_data_path)
  call bim#assert#contains('漢字', bim#dict#search('かんじ'))
  let result = bim#dict#search('かんじ')
  call bim#assert#contains('漢字', result)
  call bim#assert#contains('幹事', result)
  call bim#assert#contains('感じ', bim#dict#search('かんj'))
endfunction

function! s:test()
  call s:test1()
  call s:test2()
endfunction

call s:test()

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

