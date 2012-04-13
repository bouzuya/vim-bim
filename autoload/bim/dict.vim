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
  let lines = filereadable(path) ? readfile(path) : []
  call filter(lines, 'v:val !~# ''^\s*;''')
  let entries = []
  for line in lines
    let entry = bim#dict#entry#parse(line)
    call add(entries, entry)
  endfor
  return {'name': path, 'priority': a:priority, 'entries': entries}
endfunction

function! s:load_once(path, priority)
  if !s:loaded(a:path)
    call add(s:dicts, s:load(a:path, a:priority))
    call sort(s:dicts, function('bim#dict#priority_comparetor'))
  endif
endfunction

function! s:get_entry_index(entries, keyword)
  for i in range(len(a:entries))
    let entry = a:entries[i]
    if entry.keyword() ==# a:keyword
      return i
    endif
  endfor
  return -1
endfunction

function! s:user_dict()
  for dict in s:dicts
    if dict.priority == 0
      return dict
    endif
  endfor
  let dict = {'name': '', 'priority': 0, 'entries': []}
  call insert(s:dicts, dict)
  return dict
endfunction

function! bim#dict#clear_all_entries()
  let s:dicts = []
endfunction

" bim#dict#load({path}[, {priority})
" 0(high) <= priority <= 10(low)
" 0 : user_dict
function! bim#dict#load(path, ...)
  if strchars(a:path) == 0
    throw 'bim:bim#dict#load():'
  endif
  let priority = get(a:000, 0, 6)
  if priority < 0 || 10 < priority
    throw 'bim:bim#dict#load():'
  endif
  call s:load_once(a:path, priority)
endfunction

function! bim#dict#save()
  let dict = s:user_dict()
  if filewritable(dict.name)
    call writefile(dict.dict, dict.name)
  endif
endfunction

function! bim#dict#add_word(keyword, word)
  let dict = s:user_dict()
  let index = s:get_entry_index(dict.entries, a:keyword)
  if index == -1
    let entry = bim#dict#entry#new(a:keyword)
    call insert(dict.entries, entry)
  else
    let entry = dict.entries[index]
  endif
  call entry.insert_word(a:word)
endfunction

function! bim#dict#add_words(keyword, words)
  throw 'bim:'
endfunction

function! bim#dict#add_entry(entry)
  throw 'bim:'
endfunction

function! bim#dict#add_entries(entries)
  throw 'bim:'
endfunction

function! bim#dict#search(keyword)
  let results = []
  for dict in s:dicts
    let index = s:get_entry_index(dict.entries, a:keyword)
    if index == -1
      continue
    endif

    let entry = dict.entries[index]
    for word in entry.words()
      if index(results, word) == -1
        call add(results, word)
      endif
    endfor
  endfor
  return results
endfunction

function! bim#dict#priority_comparetor(d1, d2)
  let p1 = a:d1.priority
  let p2 = a:d2.priority
  return (p1 == p2 ? 0 : (p1 > p2 ? 1 : -1))
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

