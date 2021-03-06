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

function! s:d.fixed()
  return self._fixed
endfunction

function! s:d.is_okuri()
  return self._raw.is_okuri()
endfunction

function! s:d._keyword()
  let name = self.mode().name()
  if name ==# 'direct'
    let keyword = self.yomi()
  else
    let keyword = self.yomigana() . self.okuri()[0]
  endif
  return keyword
endfunction

function! s:d.candidate()
  return bim#dict#search(self._keyword())
endfunction

function! s:d.input(key)
  call self._raw.input(a:key)
  let self._pager = self._new_pager()
endfunction

function! s:d.remove_last()
  call self._raw.input_backspace()
  let self._pager = self._new_pager()
endfunction

function! s:d.convert()
  call self.pager().next_item()
endfunction

function! s:d.pager()
  return self._pager
endfunction

function! s:d.start_okuri()
  call self._raw.input_okuri()
endfunction

function! s:d.fix()
  let result = ''
  let conv = self.pager().item()
  if strchars(conv) == 0
    let result = self.yomigana() . self.okurigana()
  else
    call bim#dict#add_word(self._keyword(), conv)
    let result = conv . self.okurigana()
  endif
  call self._fix(result)
endfunction

function! s:d.fix_katakana()
  call self._fix(bim#engine#hiragana2katakana(self.yomigana()) . self.okurigana())
endfunction

function! s:d.fix_raw()
  call self._fix(self.yomi() . self.okurigana())
endfunction

" getter/setter
" mode([{name}])
function! s:d.mode(...)
  let name = get(a:000, 0, '')
  if strchars(name) == 0
    return self._mode
  endif
  let self._mode = get(self._modes, name, self._default_mode)
  " TODO:
  let self._pager = self._new_pager()
  return self._mode
endfunction

function! s:d._fix(s)
  let self._fixed .= a:s
  let self._raw = bim#raw#new()
  let self._pager = self._new_pager()
endfunction

function! s:d._new_pager()
  return bim#pager#new(self.candidate(), 7, -1)
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
        \ '/': function('bim#handler#slash'),
        \ 'l': function('bim#handler#l'),
        \ 'q': function('bim#handler#q'),
        \ ':': function('bim#handler#colon'),
        \ ';': function('bim#handler#semicolon'),
        \ }, function('bim#handler#else'))
  let convert_mode = bim#mode#new('convert', {
        \ ' ': function('bim#handler#c_space'),
        \ '/': function('bim#handler#c_slash'),
        \ 'h': function('bim#handler#c_h'),
        \ 'j': function('bim#handler#c_j'),
        \ 'k': function('bim#handler#c_k'),
        \ 'l': function('bim#handler#c_l'),
        \ 'q': function('bim#handler#c_q'),
        \ ';': function('bim#handler#c_semicolon')
        \ }, function('bim#handler#c_else'))
  let direct_mode = bim#mode#new('direct', {
        \ ' ': function('bim#handler#d_space'),
        \ '/': function('bim#handler#d_slash'),
        \ 'h': function('bim#handler#c_h'),
        \ 'j': function('bim#handler#c_j'),
        \ 'k': function('bim#handler#c_k'),
        \ 'l': function('bim#handler#c_l'),
        \ 'q': function('bim#handler#c_q'),
        \ ';': function('bim#handler#c_semicolon')
        \ }, function('bim#handler#c_else'))
  let modes = {
        \ 'default': default_mode,
        \ 'convert': convert_mode,
        \ 'direct': direct_mode
        \ }
  call extend(self, {
        \ '_raw': bim#raw#new(),
        \ '_fixed': '',
        \ '_modes': modes,
        \ '_mode': default_mode,
        \ '_default_mode': default_mode
        \ })
  let self._pager = self._new_pager()
endfunction

let &cpoptions = s:save_cpoptions
unlet! s:save_cpoptions

