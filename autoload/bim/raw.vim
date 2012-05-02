scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

let s:d = {}

function! bim#raw#new(...)
  let obj = copy(s:d)
  call call(obj._init, a:000, obj)
  return obj
endfunction

function! s:d._init(...)
  let self._raw = ''
  let self._idx = -1
endfunction

function! s:d.raw()
  return self._raw
endfunction

function! s:d.yomi()
  let idx = self._idx - 1
  return idx >= 0 ? self._raw[:idx] : self._raw
endfunction

function! s:d.okuri()
  return self.is_okuri() ? self._raw[self._idx:] : ''
endfunction

function! s:d.is_okuri()
  return self._idx != -1
endfunction

function! s:d.input(key)
  let self._raw .= a:key
endfunction

function! s:d.input_okuri()
  let idx = strchars(self._raw)
  if idx > 0
    let self._idx = idx
  endif
endfunction

function! s:d.input_backspace()
  if self._idx == strchars(self._raw)
    let self._idx = -1
  else
    let self._raw = substitute(self._raw, '^\(.*\).$', '\1', '')
  endif
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

