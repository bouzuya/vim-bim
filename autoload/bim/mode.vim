scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

let s:d = {}

function! bim#mode#new(name, handlers, default)
  let obj = copy(s:d)
  call obj._init(a:name, a:handlers, a:default)
  return obj
endfunction

function! s:d._init(name, handlers, default)
  let self._name = a:name
  let self._handlers = a:handlers
  let self._default = a:default
endfunction

function! s:d.name()
  return self._name
endfunction

function! s:d.handle(engine, key)
  return get(self._handlers, a:key, self._default)(a:engine, a:key)
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

