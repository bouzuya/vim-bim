scriptencoding utf-8

let s:save_cpoptions = &cpoptions
set cpoptions&vim

let s:RAW2KANA_PATH = fnamemodify(expand('<sfile>:p:h') . '/bim/table/raw.vim.data', ':p')
let s:RAW2KANA = {}
let s:HIRAGANA2KATAKANA = bim#table#hiragana2katakana()
let s:bim = {}

function! s:bim.raw()
  return self._raw
endfunction

function! s:bim.yomi()
  let index = self._okuri_index - 1
  return index >= 0 ? self._raw[:index] : self._raw
endfunction

function! s:bim.okuri()
  return self.is_okuri() ? self._raw[self._okuri_index:] : ''
endfunction

function! s:bim.yomigana()
  return get(self._romaji2hiragana(self.yomi(), self.is_okuri()), 'hiragana', '')
endfunction

function! s:bim.okurigana()
  return get(self._romaji2hiragana(self.okuri(), self.is_okuri()), 'hiragana', '')
endfunction

function! s:bim.yomirest()
  return get(self._romaji2hiragana(self.yomi(), self.is_okuri()), 'rest', '')
endfunction

function! s:bim.okurirest()
  return get(self._romaji2hiragana(self.okuri()), 'rest', '')
endfunction

function! s:bim.kanji()
  return self._kanji
endfunction

function! s:bim.fixed()
  return self._fixed
endfunction

function! s:bim.is_okuri()
  return self._okuri_index != -1
endfunction

function! s:bim.candidate()
  let keyword = self.yomigana() . self.okuri()[0]
  return bim#dict#search(keyword)
endfunction

function! s:bim.input(key)
  let self._raw .= a:key
endfunction

function! s:bim.remove_last()
  if self._okuri_index == strchars(self._raw)
    let self._okuri_index = -1
  else
    let self._raw = substitute(self._raw, '^\(.*\).$', '\1', '')
    let self._kanji = ''
  endif
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

function! s:bim.fix()
  let result = ''
  if strchars(self.kanji()) == 0
    let result = self.yomigana() . self.okurigana()
  else
    call bim#dict#add_word(self.yomigana() . self.okuri()[0], self.kanji())
    let result = self.kanji() . self.okurigana()
  endif
  let self._fixed .= result
  let self._okuri_index = -1
  let self._raw = ''
  let self._kanji = ''
endfunction

" _romaji2hiragana({romaji}[, {proc_last}])
function! s:bim._romaji2hiragana(romaji, ...)
  let proc_last = get(a:000, 0, 0)
  let dict = s:RAW2KANA.search(a:romaji, proc_last)
  return {'hiragana': get(dict, 'kana', ''), 'rest': get(dict, 'rest', '')}
endfunction

function! bim#new()
  if empty(s:RAW2KANA)
    let s:RAW2KANA = bim#table#raw#get_instance()
    call s:RAW2KANA.add_file(s:RAW2KANA_PATH)
  endif

  let obj = copy(s:bim)
  let obj._okuri_index = -1
  let obj._raw = ''
  let obj._kanji = ''
  let obj._fixed = ''
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
unlet! s:save_cpoptions

