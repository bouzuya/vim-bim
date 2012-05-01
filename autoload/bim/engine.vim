scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

let s:RAW2KANA_PATH = fnamemodify(expand('<sfile>:p:h') . '/table/raw.vim.data', ':p')
let s:RAW2KANA = {}
let s:HIRAGANA2KATAKANA = bim#table#hiragana2katakana()
let s:d = {}

function! bim#engine#new()
  if empty(s:RAW2KANA)
    let s:RAW2KANA = bim#table#raw#get_instance()
    call s:RAW2KANA.add_file(s:RAW2KANA_PATH)
  endif
  let obj = copy(s:d)
  call obj._init()
  return obj
endfunction

function! bim#engine#hiragana2katakana(hiragana)
  let katakana = ''
  for h in split(a:hiragana, '\zs')
    let katakana .= get(s:HIRAGANA2KATAKANA, h, '')
  endfor
  return katakana
endfunction

function! s:d.raw()
  return self._raw
endfunction

function! s:d.yomi()
  let index = self._okuri_index - 1
  return index >= 0 ? self._raw[:index] : self._raw
endfunction

function! s:d.okuri()
  return self.is_okuri() ? self._raw[self._okuri_index:] : ''
endfunction

function! s:d.yomigana()
  return get(self._romaji2hiragana(self.yomi(), self.is_okuri()), 'hiragana', '')
endfunction

function! s:d.okurigana()
  return get(self._romaji2hiragana(self.okuri(), self.is_okuri()), 'hiragana', '')
endfunction

function! s:d.yomirest()
  return get(self._romaji2hiragana(self.yomi(), self.is_okuri()), 'rest', '')
endfunction

function! s:d.okurirest()
  return get(self._romaji2hiragana(self.okuri()), 'rest', '')
endfunction

function! s:d.kanji()
  return self._kanji
endfunction

function! s:d.fixed()
  return self._fixed
endfunction

function! s:d.is_okuri()
  return self._okuri_index != -1
endfunction

function! s:d.candidate()
  let keyword = self.yomigana() . self.okuri()[0]
  return bim#dict#search(keyword)
endfunction

function! s:d.input(key)
  let self._raw .= a:key
endfunction

function! s:d.remove_last()
  if self._okuri_index == strchars(self._raw)
    let self._okuri_index = -1
  else
    let self._raw = substitute(self._raw, '^\(.*\).$', '\1', '')
    let self._kanji = ''
  endif
endfunction

function! s:d.convert()
  let cand = self.candidate()
  if empty(cand)
    let self._kanji = ''
    return
  endif
  let index = index(cand, self.kanji())
  let self._kanji = get(cand, index + 1, cand[0])
endfunction

function! s:d.start_okuri()
  if self._okuri_index != -1
    throw 'bim:bim.start_okuri():'
  endif
  if strchars(self._raw) == 0
    throw 'bim:bim.start_okuri():'
  endif
  let self._okuri_index = strchars(self._raw)
endfunction

function! s:d.fix()
  let result = ''
  if strchars(self.kanji()) == 0
    let result = self.yomigana() . self.okurigana()
  else
    call bim#dict#add_word(self.yomigana() . self.okuri()[0], self.kanji())
    let result = self.kanji() . self.okurigana()
  endif
  call self._fix(result)
endfunction

function! s:d.fix_katakana()
  call self._fix(bim#engine#hiragana2katakana(self.yomigana()) . self.okurigana())
endfunction

function! s:d.fix_raw()
  call self._fix(self.raw())
endfunction

function! s:d._fix(s)
  let self._fixed .= a:s
  let self._okuri_index = -1
  let self._raw = ''
  let self._kanji = ''
endfunction

" _romaji2hiragana({romaji}[, {proc_last}])
function! s:d._romaji2hiragana(romaji, ...)
  let proc_last = get(a:000, 0, 0)
  let dict = s:RAW2KANA.search(a:romaji, proc_last)
  return {
        \ 'hiragana': get(dict, 'kana', ''),
        \ 'rest': get(dict, 'rest', '')
        \ }
endfunction

function! s:d._init()
  call extend(self, {
        \ '_okuri_index': -1,
        \ '_raw': '',
        \ '_kanji': '',
        \ '_fixed': ''
        \ })
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

