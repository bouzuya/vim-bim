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
  " call filter(lines, 'v:val !~# ''^;''')
  let e = {}
  let p =  '^\S\+'
  for l in lines
    let e[matchstr(l, p)] = l
  endfor
  return {'name': path, 'priority': a:priority, 'entries': e}
endfunction

function! s:load_once(path, priority)
  if !s:loaded(a:path)
    call add(s:dicts, s:load(a:path, a:priority))
    function! s:priority_comparetor(d1, d2)
      let p1 = a:d1.priority
      let p2 = a:d2.priority
      return (p1 == p2 ? 0 : (p1 > p2 ? 1 : -1))
    endfunction
    call sort(s:dicts, function('s:priority_comparetor'))
    delfunction s:priority_comparetor
  endif
endfunction

function! s:user_dict()
  for dict in s:dicts
    if dict.priority == 0
      return dict
    endif
  endfor
  let dict = {'name': '', 'priority': 0, 'entries': {}}
  call insert(s:dicts, dict)
  return dict
endfunction

function! bim#dict#clear_all_entries()
  let s:dicts = []
endfunction

function! bim#dict#names()
  let names = []
  for dict in s:dicts
    call add(names, dict.name)
  endfor
  return names
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
  if strchars(dict.name) > 0
    let entries = []
    for keyword in keys(dict.entries)
      let entry = dict.entries[keyword]
      call add(entries, entry.to_string())
    endfor
    if !empty(entries)
      call writefile(entries, dict.name)
    endif
  endif
endfunction

function! bim#dict#add_word(keyword, word)
  let dict = s:user_dict()
  if has_key(dict.entries, a:keyword)
    let entry_string = dict.entries[a:keyword]
    let entry = bim#dict#entry#parse(entry_string)
  else
    let entry = bim#dict#entry#new(a:keyword)
  endif
  call entry.remove_word(a:word)
  call entry.insert_word(a:word)
  let dict.entries[a:keyword] = entry.to_string()
endfunction

function! bim#dict#search(keyword)
  let results = []
  for dict in s:dicts
    if !has_key(dict.entries, a:keyword)
      continue
    endif

    let entry_string = dict.entries[a:keyword]
    let entry = bim#dict#entry#parse(entry_string)
    for word in entry.words()
      if index(results, word) == -1
        call add(results, word)
      endif
    endfor
  endfor
  return results
endfunction

function! bim#dict#load_all()
  let dict = bim#option#get_path('dict')
  call bim#dict#load(dict)
  let user_dict = bim#option#get_path('user_dict')
  call bim#dict#load(user_dict, 0)
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

