scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

function! s:test1()
  let b = bim#new()
  call b.input('k')
  call bim#assert#are_equal('k', b.raw())
  call bim#assert#are_equal('k', b.yomi())
  call bim#assert#are_equal('', b.okuri())
  call bim#assert#are_equal('', b.yomigana())
  call bim#assert#are_equal('', b.okurigana())
  call b.input('y')
  call bim#assert#are_equal('ky', b.raw())
  call bim#assert#are_equal('ky', b.yomi())
  call bim#assert#are_equal('', b.okuri())
  call bim#assert#are_equal('', b.yomigana())
  call bim#assert#are_equal('', b.okurigana())
  call b.input('a')
  call bim#assert#are_equal('kya', b.raw())
  call bim#assert#are_equal('kya', b.yomi())
  call bim#assert#are_equal('', b.okuri())
  call bim#assert#are_equal('きゃ', b.yomigana())
  call bim#assert#are_equal('', b.okurigana())
  call b.input('k')
  call bim#assert#are_equal('kyak', b.raw())
  call bim#assert#are_equal('kyak', b.yomi())
  call bim#assert#are_equal('', b.okuri())
  call bim#assert#are_equal('きゃ', b.yomigana())
  call bim#assert#are_equal('', b.okurigana())
  call b.input('u')
  call bim#assert#are_equal('kyaku', b.raw())
  call bim#assert#are_equal('kyaku', b.yomi())
  call bim#assert#are_equal('', b.okuri())
  call bim#assert#are_equal('きゃく', b.yomigana())
  call bim#assert#are_equal('', b.okurigana())
  call bim#assert#contains('客', b.candidate())
endfunction

function! s:test2()
  let b = bim#new()
  call b.input('w')
  call b.input('a')
  call b.input('s')
  call b.input('u')
  call bim#assert#are_equal(b.raw(), 'wasu')
  call bim#assert#are_equal(b.yomigana(), 'わす')
  call bim#assert#is_empty(b.candidate())
  call b.start_okuri()
  call b.input('r')
  call bim#assert#are_equal(b.raw(), 'wasur')
  call bim#assert#are_equal(b.yomi(), 'wasu')
  call bim#assert#are_equal(b.okuri(), 'r')
  call bim#assert#are_equal(b.yomigana(), 'わす')
  call bim#assert#are_equal(b.okurigana(), '')
  call bim#assert#contains('忘', b.candidate())
endfunction

function! s:test3()
  let b = bim#new()
  call b.input('a')
  call b.input('i')
  for c in b.candidate()
    call b.convert()
    call bim#assert#are_equal(c, b.kanji())
  endfor
  call b.convert()
  call bim#assert#are_equal(b.candidate()[0], b.kanji())
endfunction

function! s:test()
  call s:test1()
  call s:test2()
  call s:test3()
endfunction

call s:test()

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

