function! bim#assert#are_equal(expected, actual)
  if a:expected !=# a:actual
    let format = 'expected ''%s'' but actual ''%s'''
    let message = printf(format, a:expected, a:actual)
    throw 'assert:' . message
  endif
endfunction

function! bim#assert#is_empty(list)
  if !empty(a:list)
    let format = '''%s'' is not empty'
    let message = printf(format, string(a:list))
    throw 'assert:' . message
  endif
endfunction

function! bim#assert#contains(object, list)
  if index(a:list, a:object) == -1
    let format = '''%s'' does not contain ''%s'''
    let message = printf(format, a:object, string(a:list))
    throw 'assert:' . message
  endif
endfunction

