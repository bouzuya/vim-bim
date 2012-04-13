scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

let s:ROMAJI2HIRAGANA = bim#table#romaji2hiragana()
let s:HIRAGANA2KATAKANA = bim#table#hiragana2katakana()
let s:bim = {}

function! s:bim.raw()
  return self._raw
endfunction

function! s:bim.yomi()
  let index = self._okuri_index - 1
  return index > 0 ? self._raw[:index] : self._raw
endfunction

function! s:bim.okuri()
  return self.is_okuri() ? self._raw[self._okuri_index:] : ''
endfunction

function! s:bim.yomigana()
  return self._romaji2hiragana(self.yomi())
endfunction

function! s:bim.okurigana()
  return self._romaji2hiragana(self.okuri())
endfunction

function! s:bim.kanji()
  return self._kanji
endfunction

function! s:bim.is_okuri()
  return self._okuri_index != -1
endfunction

function! s:bim.candidate()
  let keyword = self.yomigana() . self.okuri()[0]
  return bim#dict#search(keyword)
endfunction

function! s:bim.input(key)
  if a:key !~# '^[-[:alnum:]]$'
    throw 'bim:bim.input():'
  endif
  let self._raw .= a:key
endfunction

function! s:bim.convert()
  let cand = self.candidate()
  if empty(cand)
    let self._kanji = ''
    return
  endif
  let index = index(cand, self.kanji())
  let self._kanji = get(cand, index + 1, cand[0])
endfunction

function! s:bim.start_okuri()
  if self._okuri_index != -1
    throw 'bim:bim.start_okuri():'
  endif
  if strchars(self._raw) == 0
    throw 'bim:bim.start_okuri():'
  endif
  let self._okuri_index = strchars(self._raw)
endfunction

function! s:bim._romaji2hiragana(romaji)
  let h = ''
  let m = self._romaji2hiragana_table
  for key in split(a:romaji, '\zs')
    let m = get(m, key, {})
    let h .= get(m, 'fixed', '')
    let m = get(m, 'mapping', self._romaji2hiragana_table)
  endfor
  return h
endfunction

function! bim#new()
  let obj = copy(s:bim)
  let obj._okuri_index = -1
  let obj._raw = ''
  let obj._kanji = ''
  let obj._romaji2hiragana_table = s:ROMAJI2HIRAGANA
  return obj
endfunction

function! bim#hiragana2katakana(hiragana)
  let katakana = ''
  for h in split(a:hiragana, '\zs')
    let katakana .= get(s:HIRAGANA2KATAKANA, h, '')
  endfor
  return katakana
endfunction

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions

