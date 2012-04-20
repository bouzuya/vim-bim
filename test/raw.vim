scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

function! s:test1()
  let raw = bim#table#raw#get_instance()
  call raw.clear()
  call raw.add('a', '"\u3042"')
  let result = raw.search('a')
  call bim#assert#are_equal("\u3042", get(result, 'kana', ''))
  call bim#assert#are_equal('', get(result, 'rest', ''))
endfunction

function! s:test2()
  let raw = bim#table#raw#get_instance()
  call raw.clear()
  call raw.add('a', '"\u3042"')
  call raw.add('ka', '"\u304B"')
  let result = raw.search('ka')
  call bim#assert#are_equal("\u304B", get(result, 'kana', ''))
  call bim#assert#are_equal('', get(result, 'rest', ''))
endfunction

function! s:test3()
  let raw = bim#table#raw#get_instance()
  call raw.clear()
  call raw.add('a', '"\u3042"')
  call raw.add('ka', '"\u304B"')
  call raw.add('n', '"\u3093"')
  call raw.add('na', '"\u306A"')
  call raw.add('nn', '"\u3093"')
  let result = raw.search('kan')
  call bim#assert#are_equal("\u304B", get(result, 'kana', ''))
  call bim#assert#are_equal('n', get(result, 'rest', ''))
  let result = raw.search('kan', 1)
  call bim#assert#are_equal("\u304B\u3093", get(result, 'kana', ''))
  call bim#assert#are_equal('', get(result, 'rest', ''))
  call bim#assert#are_equal(1, 2)
endfunction

function! s:test()
  call s:test1()
  call s:test2()
  call s:test3()
endfunction

call s:test()

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

