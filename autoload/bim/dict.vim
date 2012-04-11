scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

let s:dicts = []

function! s:loaded(path)
  let path = expand(a:path)
  for dict in s:dicts
    if path ==# dict.name
      return 1
    endif
  endfor
  return 0
endfunction

function! s:load(path, priority)
  let path = expand(a:path)
  let dict = readfile(path)
  call filter(dict, 'v:val !~# ''^\s*;''')
  return {'name': path, 'priority': a:priority, 'dict': dict}
endfunction

function! bim#dict#search(keyword)
  let results = []
  for dict in s:dicts
    let pattern = '^\V' . escape(a:keyword, '\') . '\m\s'
    let line = matchstr(dict['dict'], pattern)
    let wordstr = substitute(line, '^\S*\s*/\(.*\)/$', '\1', '')
    let words = split(wordstr, '/')
    call map(words, 'substitute(v:val, ''^\([^;]*\)'', ''\1'', '''')')
    call extend(results, words)
  endfor
  return results
endfunction

function! bim#dict#clear()
  let s:dicts = {}
endfunction

" load({path}[, {priority})
" 1(low) > 10(high)
function! bim#dict#load(path, ...)
  let priority = get(a:000, 0, 6)
  if !s:loaded(a:path)
    call add(s:dicts, s:load(a:path, priority))
    call sort(s:dicts, function('bim#dict#priority_comparetor'))
  endif
endfunction

function! bim#dict#priority_comparetor(d1, d2)
  let p1 = a:d1.priority
  let p2 = a:d2.priority
  return p1 == p2 ? 0 p1 > p2 ? 1 : -1
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

