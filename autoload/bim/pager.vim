scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

let s:pager = {}

function! bim#pager#new(list, ipp, idx)
  let obj = copy(s:pager)
  call obj._init(a:list, a:ipp, a:idx)
  return obj
endfunction

function! s:pager.next_item()
  if empty(self._list)
    return
  endif

  let self._idx += 1
  if self._idx >= len(self._list)
    let self._idx = 0
  endif
endfunction

function! s:pager.prev_item()
  if empty(self._list)
    return
  endif

  let self._idx -= 1
  if self._idx < 0
    let self._idx = len(self._list) - 1
  endif
endfunction

function! s:pager.next_page()
  if empty(self._list)
    return
  endif

  let self._idx += self._ipp
  let l = len(self._list)
  if self._idx >= l
    let v = (l + self._ipp) / self._ipp * self._ipp
    let self._idx = self._idx < v ? l - 1 : self._idx % self._ipp
  endif
endfunction

function! s:pager.prev_page()
  if empty(self._list)
    return
  endif

  let self._idx -= self._ipp
  if self._idx < 0
    let l = len(self._list)
    let v = (l + self._ipp) / self._ipp * self._ipp
    let self._idx = v + self._idx >= l ? l - 1 : v + self._idx
  endif
endfunction

function! s:pager.items()
  return self._list
endfunction

function! s:pager.itemnum()
  return len(self._list)
endfunction

function! s:pager.idx()
  return self._idx
endfunction

function! s:pager.item()
  if self._idx < 0
    return ''
  endif
  return get(self._list, self._idx, '')
endfunction

function! s:pager.pages()
  let l = self._list
  let n = self._ipp
  if empty(l)
    return [[]]
  endif

  let pages = []
  for i in range(0, len(l) - 1, n)
    call add(pages, l[i : (i + n - 1)])
  endfor
  return pages
endfunction

function! s:pager.pagenum()
  return len(self.pages())
endfunction

function! s:pager.pageidx()
  return self._idx / self._ipp
endfunction

function! s:pager.page()
  return get(self.pages(), self.pageidx(), [])
endfunction

function! s:pager._init(list, ipp, idx)
  let self._list = copy(a:list)
  let self._ipp = a:ipp
  let self._idx = a:idx
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

