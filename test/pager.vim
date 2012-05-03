scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

function! s:test1()
  let p = bim#pager#new(['A', 'B', 'C', 'D', 'E'], 3, 1)
  call bim#assert#are_equal(2, p.pagenum())
  call bim#assert#are_equal(0, p.pageidx())
  call bim#assert#are_equal(string(['A', 'B', 'C']), string(p.page()))
  call bim#assert#are_equal(1, p.idx())
  call bim#assert#are_equal('B', p.item())
endfunction

function! s:test2()
  let p = bim#pager#new(['A', 'B', 'C', 'D', 'E'], 3, 1)
  call p.next_item()
  call bim#assert#are_equal(2, p.pagenum())
  call bim#assert#are_equal(0, p.pageidx())
  call bim#assert#are_equal(string(['A', 'B', 'C']), string(p.page()))
  call bim#assert#are_equal(2, p.idx())
  call bim#assert#are_equal('C', p.item())
endfunction

function! s:test3()
  let p = bim#pager#new(['A', 'B', 'C', 'D', 'E'], 3, 1)
  call p.next_item()
  call p.next_item()
  call bim#assert#are_equal(2, p.pagenum())
  call bim#assert#are_equal(1, p.pageidx())
  call bim#assert#are_equal(string(['D', 'E']), string(p.page()))
  call bim#assert#are_equal(3, p.idx())
  call bim#assert#are_equal('D', p.item())
endfunction

function! s:test4()
  let p = bim#pager#new(['A', 'B', 'C', 'D', 'E'], 3, 1)
  call p.next_item()
  call p.next_item()
  call p.next_item()
  call bim#assert#are_equal(2, p.pagenum())
  call bim#assert#are_equal(1, p.pageidx())
  call bim#assert#are_equal(string(['D', 'E']), string(p.page()))
  call bim#assert#are_equal(4, p.idx())
  call bim#assert#are_equal('E', p.item())
endfunction

function! s:test5()
  let p = bim#pager#new(['A', 'B', 'C', 'D', 'E'], 3, 1)
  call p.next_item()
  call p.next_item()
  call p.next_item()
  call p.next_item()
  call bim#assert#are_equal(2, p.pagenum())
  call bim#assert#are_equal(0, p.pageidx())
  call bim#assert#are_equal(string(['A', 'B', 'C']), string(p.page()))
  call bim#assert#are_equal(0, p.idx())
  call bim#assert#are_equal('A', p.item())
endfunction

function! s:test6()
  let p = bim#pager#new(['A', 'B', 'C', 'D', 'E'], 3, 1)
  call p.prev_item()
  call bim#assert#are_equal(2, p.pagenum())
  call bim#assert#are_equal(0, p.pageidx())
  call bim#assert#are_equal(string(['A', 'B', 'C']), string(p.page()))
  call bim#assert#are_equal(0, p.idx())
  call bim#assert#are_equal('A', p.item())
endfunction

function! s:test7()
  let p = bim#pager#new(['A', 'B', 'C', 'D', 'E'], 3, 1)
  call p.prev_item()
  call p.prev_item()
  call bim#assert#are_equal(2, p.pagenum())
  call bim#assert#are_equal(1, p.pageidx())
  call bim#assert#are_equal(string(['D', 'E']), string(p.page()))
  call bim#assert#are_equal(4, p.idx())
  call bim#assert#are_equal('E', p.item())
endfunction

function! s:test8()
  let p = bim#pager#new(['A', 'B', 'C', 'D', 'E'], 3, 1)
  call p.next_page()
  call bim#assert#are_equal(2, p.pagenum())
  call bim#assert#are_equal(1, p.pageidx())
  call bim#assert#are_equal(string(['D', 'E']), string(p.page()))
  call bim#assert#are_equal(4, p.idx())
  call bim#assert#are_equal('E', p.item())
endfunction

function! s:test9()
  let p = bim#pager#new(['A', 'B', 'C', 'D', 'E'], 3, 1)
  call p.prev_page()
  call bim#assert#are_equal(2, p.pagenum())
  call bim#assert#are_equal(1, p.pageidx())
  call bim#assert#are_equal(string(['D', 'E']), string(p.page()))
  call bim#assert#are_equal(4, p.idx())
  call bim#assert#are_equal('E', p.item())
endfunction

function! s:test10()
  let p = bim#pager#new(['A', 'B', 'C', 'D', 'E'], 3, 1)
  call p.next_page()
  call p.next_page()
  call bim#assert#are_equal(2, p.pagenum())
  call bim#assert#are_equal(0, p.pageidx())
  call bim#assert#are_equal(string(['A', 'B', 'C']), string(p.page()))
  call bim#assert#are_equal(1, p.idx())
  call bim#assert#are_equal('B', p.item())
endfunction

function! s:test11()
  let p = bim#pager#new(['A', 'B', 'C', 'D', 'E'], 3, 1)
  call p.prev_page()
  call p.prev_page()
  call bim#assert#are_equal(2, p.pagenum())
  call bim#assert#are_equal(0, p.pageidx())
  call bim#assert#are_equal(string(['A', 'B', 'C']), string(p.page()))
  call bim#assert#are_equal(1, p.idx())
  call bim#assert#are_equal('B', p.item())
endfunction

function! s:test12()
  let p = bim#pager#new(['A', 'B', 'C'], 3, -1)
  call bim#assert#are_equal(1, p.pagenum())
  call bim#assert#are_equal(0, p.pageidx())
  call bim#assert#are_equal(string(['A', 'B', 'C']), string(p.page()))
  call bim#assert#are_equal(-1, p.idx())
  call bim#assert#are_equal('', p.item())
endfunction

function! s:test13()
  let p = bim#pager#new([
        \ 'A', 'B', 'C', 'D', 'E', 'F', 'G',
        \ 'H', 'I', 'J', 'K', 'L', 'M', 'N',
        \ 'O', 'P', 'Q', 'R'
        \ ], 7, 2)
  call p.next_page()
  call bim#assert#are_equal(9, p.idx())
  call bim#assert#are_equal('J', p.item())
  call p.next_page()
  call bim#assert#are_equal(16, p.idx())
  call bim#assert#are_equal('Q', p.item())
  call p.next_page()
  call bim#assert#are_equal(2, p.idx())
  call bim#assert#are_equal('C', p.item())
endfunction

function! s:test()
  call s:test1()
  call s:test2()
  call s:test3()
  call s:test4()
  call s:test5()
  call s:test6()
  call s:test7()
  call s:test8()
  call s:test9()
  call s:test10()
  call s:test11()
  call s:test12()
  call s:test13()
endfunction

call s:test()

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

