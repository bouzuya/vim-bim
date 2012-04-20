scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

let s:instance = {}
let s:raw = {}

function! bim#table#raw#get_instance()
  if empty(s:instance)
    let obj = copy(s:raw)
    let obj._table = {}
    let s:instance = obj
  endif
  return s:instance
endfunction

function! s:raw.clear()
  call filter(self._table, 0)
endfunction

function! s:raw.add_file(file)
  let lines = readfile(a:file)
  for line in lines
    let list = matchlist(line, '^\(\S\+\)\s\+\(.\+\)$')
    if empty(list)
      continue
    endif
    let [s, expr; _] = list[1:]
    call self.add(s, expr)
  endfor
endfunction

function! s:raw.add(raw, expr)
  let node = self._table
  for c in split(a:raw, '\zs')
    let node['mapping'] = get(node, 'mapping', {})
    let node['mapping'][c] = get(node['mapping'], c, {})
    let node = node['mapping'][c]
  endfor
  let node['expr'] = a:expr
endfunction

" raw2kana({raw}[, {proc_last}])
function! s:raw.search(raw, ...)
  let proc_last = get(a:000, 0, 0)
  let root = self._table
  let prev = root
  let cont = 0
  let pc = ''
  let cm = {}
  let ce = ''''''
  let kana = ''
  let rest = ''
  let list = matchlist(a:raw, '^\(.\)\(.*\)$')
  while !empty(list)
    let [c, s; _] = list[1:]

    let pm = get(prev, 'mapping', {})
    let pe = get(prev, 'expr', '''''')
    let curr = get(pm, c, {})
    let cm = get(curr, 'mapping', {})
    let ce = get(curr, 'expr', '''''')

    if empty(curr)
      let kana .= eval(pe)
      let rest = ''
      let prev = root
      continue
    endif

    if empty(cm)
      let kana .= eval(ce)
      let rest = ''
      let prev = root
    else
      let rest .= c
      let prev = curr
    endif

    if !cont && pc == c
      let cont = 1
      let s = c . s
    else
      let cont = 0
    endif
    let pc = c

    let list = matchlist(s, '^\(.\)\(.*\)$')
  endwhile
  if proc_last && !empty(cm) && strchars(ce) > 0
    let kana .= eval(ce)
    let rest = ''
  endif
  return {'kana': kana, 'rest': rest}
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

