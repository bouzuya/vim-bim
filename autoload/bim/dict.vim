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
  let dict = filereadable(path) ? readfile(path) : []
  call filter(dict, 'v:val !~# ''^\s*;''')
  return {'name': path, 'priority': a:priority, 'dict': dict}
endfunction

function! s:load_once(path, priority)
  if !s:loaded(a:path)
    call add(s:dicts, s:load(a:path, a:priority))
    call sort(s:dicts, function('bim#dict#priority_comparetor'))
  endif
endfunction

function! s:user_dict()
  for dict in s:dicts
    if dict.priority == 0
      return dict
    endif
  endfor
  throw 'bim:'
endfunction

function! bim#dict#add_word(keyword, word)
  let entry = printf('%s /%s/', a:keyword, a:word)
  let dict = s:user_dict()
  call insert(dict.dict, entry, 0)
endfunction

function! bim#dict#search(keyword)
  let results = []
  for dict in s:dicts
    let pattern = '^\V' . escape(a:keyword, '\') . '\m\s'
    let entry = matchstr(dict['dict'], pattern)
    let wordstr = substitute(entry, '^\S*\s*/\(.*\)/$', '\1', '')
    let words = split(wordstr, '/')
    call map(words, 'substitute(v:val, ''^\([^;]*\)'', ''\1'', '''')')
    for word in words
      if index(results, word) == -1
        call add(results, word)
      endif
    endfor
  endfor
  return results
endfunction

function! bim#dict#clear()
  let s:dicts = {}
endfunction

" load({path}[, {priority})
" 1(high) > 10(low)
function! bim#dict#load(path, ...)
  let priority = get(a:000, 0, 6)
  if priority < 1 || 10 < priority
    throw 'bim:bim#dict#load():'
  endif
  call s:load_once(a:path, priority)
endfunction

function! bim#dict#load_user_dict(path)
  call s:load_once(a:path, 0)
endfunction

function! bim#dict#priority_comparetor(d1, d2)
  let p1 = a:d1.priority
  let p2 = a:d2.priority
  return (p1 == p2 ? 0 : (p1 > p2 ? 1 : -1))
endfunction

function! bim#dict#save()
  let dict = s:user_dict()
  if filewritable(dict.name)
    call writefile(dict.dict, dict.name)
  endif
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

