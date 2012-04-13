scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

let s:entry = {}

function! bim#dict#entry#parse(entry_string)
  let list = matchlist(a:entry_string, '^\(\S+\)\s/\(.*\)/$')
  if len(list) != 2
    throw 'bim:'
  endif

  let keyword = list[0]
  let words = split(list[1], '/')
  call map(words, 'substitute(v:val, ''^\([^;]*\)'', ''\1'', '''')')
  return bim#dict#entry#new(keyword, words)
endfunction

" bim#dict#entry#new({keyword}[, {words}])
function! bim#dict#entry#new(keyword, ...)
  if strchars(a:keyword) == 0
    throw 'bim:'
  endif
  let words = get(a:000, 0, [])
  let obj = copy(s:entry)
  let obj._keyword = a:keyword
  let obj._words = words
  return obj
endfunction

function! s:entry.keyword()
  return self._keyword
endfunction

function! s:entry.words()
  return self._words
endfunction

function! s:entry.has_word(word)
  return index(self._words, a:word) != -1
endfunction

" insert_word({word}[, {idx}])
function! s:entry.insert_word(word, ...)
  let idx = get(a:000, 0, 0)
  call insert(self._words, a:word, idx)
endfunction

function! s:entry.add_word(word)
  call add(self._words, a:word)
endfunction

function! s:entry.to_string()
  return printf('%s /%s/', self._keyword, join(self._words, '/'))
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

