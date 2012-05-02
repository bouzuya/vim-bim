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
  return self._raw.raw()
endfunction

function! s:d.yomi()
  return self._raw.yomi()
endfunction

function! s:d.okuri()
  return self._raw.okuri()
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
  return self._raw.is_okuri()
endfunction

function! s:d.candidate()
  let keyword = self.yomigana() . self.okuri()[0]
  return bim#dict#search(keyword)
endfunction

function! s:d.input(key)
  call self._raw.input(a:key)
endfunction

function! s:d.remove_last()
  let b = self._raw.is_okuri()
  call self._raw.input_backspace()
  let a = self._raw.is_okuri()
  if b != a
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
  call self._raw.input_okuri()
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

" getter/setter
" mode([{name}])
function! s:d.mode(...)
  let name = get(a:000, 0, '')
  if strchars(name) == 0
    return self._mode
  endif
  let self._mode = get(self._modes, name, self._default_mode)
  return self._mode
endfunction

function! s:d._fix(s)
  let self._fixed .= a:s
  let self._raw = bim#raw#new()
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
  let default_mode = bim#mode#new('default', {
        \ "\<C-h>": function('bim#handler#backspace'),
        \ "\<C-j>": function('bim#handler#ctrl_j'),
        \ "\<C-m>": function('bim#handler#semicolon'),
        \ "\<C-[>": function('bim#handler#escape'),
        \ ' ': function('bim#handler#space'),
        \ ':': function('bim#handler#colon'),
        \ ';': function('bim#handler#semicolon'),
        \ 'l': function('bim#handler#l'),
        \ 'q': function('bim#handler#q')
        \ }, function('bim#handler#else'))
  let convert_mode = bim#mode#new('convert', {
        \ ' ': function('bim#handler#c_space'),
        \ 'h': function('bim#handler#c_h'),
        \ 'j': function('bim#handler#c_j'),
        \ 'k': function('bim#handler#c_k'),
        \ 'l': function('bim#handler#c_l'),
        \ ';': function('bim#handler#c_semicolon')
        \ }, function('bim#handler#else'))
  let modes = {
        \ 'default': default_mode,
        \ 'convert': convert_mode
        \ }
  call extend(self, {
        \ '_raw': bim#raw#new(),
        \ '_kanji': '',
        \ '_fixed': '',
        \ '_modes': modes,
        \ '_mode': default_mode,
        \ '_default_mode': default_mode
        \ })
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

