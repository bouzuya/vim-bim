function! bim#table#romaji2hiragana()
  let table = {}
  let table['a'] = {'fixed': "\u3042"}
  let table['b'] = {'mapping': {'mapping': {}}}
  let table['b']['mapping']['a'] = {'fixed': "\u3070"}
  let table['b']['mapping']['i'] = {'fixed': "\u3073"}
  let table['b']['mapping']['u'] = {'fixed': "\u3076"}
  let table['b']['mapping']['e'] = {'fixed': "\u3079"}
  let table['b']['mapping']['o'] = {'fixed': "\u307C"}
  let table['d'] = {'mapping': {}}
  let table['d']['mapping']['a'] = {'fixed': "\u3060"}
  let table['d']['mapping']['i'] = {'fixed': "\u3062"}
  let table['d']['mapping']['u'] = {'fixed': "\u3065"}
  let table['d']['mapping']['e'] = {'fixed': "\u3067"}
  let table['d']['mapping']['o'] = {'fixed': "\u3069"}
  let table['e'] = {'fixed': "\u3048"}
  let table['f'] = {'mapping': {}}
  let table['f']['mapping']['a'] = {'fixed': "\u3075\u3041"}
  let table['f']['mapping']['i'] = {'fixed': "\u3075\u3043"}
  let table['f']['mapping']['u'] = {'fixed': "\u3075"}
  let table['f']['mapping']['e'] = {'fixed': "\u3075\u3047"}
  let table['f']['mapping']['o'] = {'fixed': "\u3075\u3049"}
  let table['g'] = {'mapping': {}}
  let table['g']['mapping']['a'] = {'fixed': "\u304C"}
  let table['g']['mapping']['i'] = {'fixed': "\u304E"}
  let table['g']['mapping']['u'] = {'fixed': "\u3050"}
  let table['g']['mapping']['e'] = {'fixed': "\u3052"}
  let table['g']['mapping']['o'] = {'fixed': "\u3054"}
  let table['h'] = {'mapping': {}}
  let table['h']['mapping']['a'] = {'fixed': "\u306F"}
  let table['h']['mapping']['i'] = {'fixed': "\u3072"}
  let table['h']['mapping']['u'] = {'fixed': "\u3075"}
  let table['h']['mapping']['e'] = {'fixed': "\u3078"}
  let table['h']['mapping']['o'] = {'fixed': "\u307B"}
  let table['i'] = {'fixed': "\u3044"}
  let table['j'] = {'mapping': {}}
  let table['j']['mapping']['a'] = {'fixed': "\u3058\u3083"}
  let table['j']['mapping']['i'] = {'fixed': "\u3058"}
  let table['j']['mapping']['u'] = {'fixed': "\u3058\u3085"}
  let table['j']['mapping']['e'] = {'fixed': "\u3058\u3047"}
  let table['j']['mapping']['o'] = {'fixed': "\u3058\u3087"}
  let table['k'] = {'mapping': {}}
  let table['k']['mapping']['a'] = {'fixed': "\u304B"}
  let table['k']['mapping']['i'] = {'fixed': "\u304D"}
  let table['k']['mapping']['u'] = {'fixed': "\u304F"}
  let table['k']['mapping']['e'] = {'fixed': "\u3051"}
  let table['k']['mapping']['o'] = {'fixed': "\u3053"}
  let table['l'] = {'mapping': {}}
  let table['l']['mapping']['a'] = {'fixed': "\u3041"}
  let table['l']['mapping']['i'] = {'fixed': "\u3043"}
  let table['l']['mapping']['u'] = {'fixed': "\u3045"}
  let table['l']['mapping']['e'] = {'fixed': "\u3047"}
  let table['l']['mapping']['o'] = {'fixed': "\u3049"}
  let table['m'] = {'mapping': {}}
  let table['m']['mapping']['a'] = {'fixed': "\u307E"}
  let table['m']['mapping']['i'] = {'fixed': "\u307F"}
  let table['m']['mapping']['u'] = {'fixed': "\u3080"}
  let table['m']['mapping']['e'] = {'fixed': "\u3081"}
  let table['m']['mapping']['o'] = {'fixed': "\u3082"}
  let table['n'] = {'mapping': {}}
  let table['n']['mapping']['a'] = {'fixed': "\u306A"}
  let table['n']['mapping']['i'] = {'fixed': "\u306B"}
  let table['n']['mapping']['u'] = {'fixed': "\u306C"}
  let table['n']['mapping']['e'] = {'fixed': "\u306D"}
  let table['n']['mapping']['o'] = {'fixed': "\u306E"}
  let table['n']['mapping']['n'] = {'fixed': "\u3093"} " nn
  let table['o'] = {'fixed': "\u304A"}
  let table['p'] = {'mapping': {}}
  let table['p']['mapping']['a'] = {'fixed': "\u3071"}
  let table['p']['mapping']['i'] = {'fixed': "\u3074"}
  let table['p']['mapping']['u'] = {'fixed': "\u3077"}
  let table['p']['mapping']['e'] = {'fixed': "\u307A"}
  let table['p']['mapping']['o'] = {'fixed': "\u307D"}
  let table['r'] = {'mapping': {}}
  let table['r']['mapping']['a'] = {'fixed': "\u3089"}
  let table['r']['mapping']['i'] = {'fixed': "\u308A"}
  let table['r']['mapping']['u'] = {'fixed': "\u308B"}
  let table['r']['mapping']['e'] = {'fixed': "\u308C"}
  let table['r']['mapping']['o'] = {'fixed': "\u308D"}
  let table['s'] = {'mapping': {}}
  let table['s']['mapping']['a'] = {'fixed': "\u3055"}
  let table['s']['mapping']['i'] = {'fixed': "\u3057"}
  let table['s']['mapping']['u'] = {'fixed': "\u3059"}
  let table['s']['mapping']['e'] = {'fixed': "\u305B"}
  let table['s']['mapping']['o'] = {'fixed': "\u305D"}
  let table['t'] = {'mapping': {}}
  let table['t']['mapping']['a'] = {'fixed': "\u305F"}
  let table['t']['mapping']['i'] = {'fixed': "\u3061"}
  let table['t']['mapping']['u'] = {'fixed': "\u3064"}
  let table['t']['mapping']['e'] = {'fixed': "\u3066"}
  let table['t']['mapping']['o'] = {'fixed': "\u3068"}
  let table['u'] = {'fixed': "\u3046"}
  let table['v'] = {'mapping': {}}
  let table['v']['mapping']['a'] = {'fixed': "\u3094\u3041"}
  let table['v']['mapping']['i'] = {'fixed': "\u3094\u3043"}
  let table['v']['mapping']['u'] = {'fixed': "\u3094"}
  let table['v']['mapping']['e'] = {'fixed': "\u3094\u3047"}
  let table['v']['mapping']['o'] = {'fixed': "\u3094\u3049"}
  let table['w'] = {'mapping': {}}
  let table['w']['mapping']['a'] = {'fixed': "\u308F"}
  let table['w']['mapping']['i'] = {'fixed': "\u3046\u3043"}
  let table['w']['mapping']['u'] = {'fixed': "\u3046"}
  let table['w']['mapping']['e'] = {'fixed': "\u3046\u3047"}
  let table['w']['mapping']['o'] = {'fixed': "\u3092"}
  let table['x'] = {'mapping': {}}
  let table['x']['mapping']['a'] = {'fixed': "\u3041"}
  let table['x']['mapping']['i'] = {'fixed': "\u3043"}
  let table['x']['mapping']['u'] = {'fixed': "\u3045"}
  let table['x']['mapping']['e'] = {'fixed': "\u3047"}
  let table['x']['mapping']['o'] = {'fixed': "\u3049"}
  let table['y'] = {'mapping': {}}
  let table['y']['mapping']['a'] = {'fixed': "\u3084"}
  let table['y']['mapping']['i'] = {'fixed': "\u3044"}
  let table['y']['mapping']['u'] = {'fixed': "\u3086"}
  let table['y']['mapping']['e'] = {'fixed': "\u3044\u3047"}
  let table['y']['mapping']['o'] = {'fixed': "\u3088"}
  let table['z'] = {'mapping': {}}
  let table['z']['mapping']['a'] = {'fixed': "\u3056"}
  let table['z']['mapping']['i'] = {'fixed': "\u3058"}
  let table['z']['mapping']['u'] = {'fixed': "\u305A"}
  let table['z']['mapping']['e'] = {'fixed': "\u305C"}
  let table['z']['mapping']['o'] = {'fixed': "\u305E"}
  " sign
  " let table['!'] = {'fixed': "\u"}
  " let table['"'] = {'fixed': "\u"}
  " let table['#'] = {'fixed': "\u"}
  " let table['$'] = {'fixed': "\u"}
  " let table['%'] = {'fixed': "\u"}
  " let table['&'] = {'fixed': "\u"}
  " let table[''''] = {'fixed': "\u"}
  " let table['('] = {'fixed': "\u"}
  " let table[')'] = {'fixed': "\u"}

  let table['['] = {'fixed': "\u300C"}
  let table[']'] = {'fixed': "\u300D"}
  let table['/'] = {'fixed': '/'}
  let table['-'] = {'fixed': "\u30FC"}
  let table['~'] = {'fixed': "\u301C"}
  let table[','] = {'fixed': "\u3001"}
  let table['.'] = {'fixed': "\u3002"}

  " sign
  let table['z']['mapping']['h'] = {'fixed': "\u2190"}
  let table['z']['mapping']['j'] = {'fixed': "\u2193"}
  let table['z']['mapping']['k'] = {'fixed': "\u2191"}
  let table['z']['mapping']['l'] = {'fixed': "\u2192"}
  let table['z']['mapping']['['] = {'fixed': "\u300E"}
  let table['z']['mapping'][']'] = {'fixed': "\u300F"}
  let table['z']['mapping']['/'] = {'fixed': "\u30FB"}
  let table['z']['mapping']['-'] = {'fixed': "\u301C"}
  let table['z']['mapping']['.'] = {'fixed': "\u2026"}
  " c & q is free.
  " sokuon
  let table['b']['mapping']['b'] = {'fixed': "\u3063", 'mapping': table['b']['mapping']}
  let table['d']['mapping']['d'] = {'fixed': "\u3063", 'mapping': table['d']['mapping']}
  let table['f']['mapping']['f'] = {'fixed': "\u3063", 'mapping': table['f']['mapping']}
  let table['g']['mapping']['g'] = {'fixed': "\u3063", 'mapping': table['g']['mapping']}
  let table['h']['mapping']['h'] = {'fixed': "\u3063", 'mapping': table['h']['mapping']}
  let table['j']['mapping']['j'] = {'fixed': "\u3063", 'mapping': table['j']['mapping']}
  let table['k']['mapping']['k'] = {'fixed': "\u3063", 'mapping': table['k']['mapping']}
  let table['l']['mapping']['l'] = {'fixed': "\u3063", 'mapping': table['l']['mapping']}
  let table['m']['mapping']['m'] = {'fixed': "\u3063", 'mapping': table['m']['mapping']}
  let table['p']['mapping']['p'] = {'fixed': "\u3063", 'mapping': table['p']['mapping']}
  let table['r']['mapping']['r'] = {'fixed': "\u3063", 'mapping': table['r']['mapping']}
  let table['s']['mapping']['s'] = {'fixed': "\u3063", 'mapping': table['s']['mapping']}
  let table['t']['mapping']['t'] = {'fixed': "\u3063", 'mapping': table['t']['mapping']}
  let table['v']['mapping']['v'] = {'fixed': "\u3063", 'mapping': table['v']['mapping']}
  let table['w']['mapping']['w'] = {'fixed': "\u3063", 'mapping': table['w']['mapping']}
  let table['x']['mapping']['x'] = {'fixed': "\u3063", 'mapping': table['x']['mapping']}
  let table['y']['mapping']['y'] = {'fixed': "\u3063", 'mapping': table['y']['mapping']}
  let table['z']['mapping']['z'] = {'fixed': "\u3063", 'mapping': table['z']['mapping']}

  " youon
  let table['b']['mapping']['y'] = {'mapping': {'a': {'fixed': "\u3073\u3083"}, 'u': {'fixed': "\u3073\u3085"}, 'o': {'fixed': "\u3073\u3087"}}}
  let table['d']['mapping']['y'] = {'mapping': {'a': {'fixed': "\u3062\u3083"}, 'u': {'fixed': "\u3062\u3085"}, 'o': {'fixed': "\u3062\u3087"}}}
  let table['f']['mapping']['y'] = {'mapping': {'a': {'fixed': "\u3075\u3083"}, 'u': {'fixed': "\u3075\u3085"}, 'o': {'fixed': "\u3075\u3087"}}}
  let table['g']['mapping']['y'] = {'mapping': {'a': {'fixed': "\u304E\u3083"}, 'u': {'fixed': "\u304E\u3085"}, 'o': {'fixed': "\u304E\u3087"}}}
  let table['h']['mapping']['y'] = {'mapping': {'a': {'fixed': "\u3072\u3083"}, 'u': {'fixed': "\u3072\u3085"}, 'o': {'fixed': "\u3072\u3087"}}}
  let table['j']['mapping']['y'] = {'mapping': {'a': {'fixed': "\u3058\u3083"}, 'u': {'fixed': "\u3058\u3085"}, 'o': {'fixed': "\u3058\u3087"}}}
  let table['k']['mapping']['y'] = {'mapping': {'a': {'fixed': "\u304D\u3083"}, 'u': {'fixed': "\u304D\u3085"}, 'o': {'fixed': "\u304D\u3087"}}}
  " let table['l']['mapping']['y'] = {'mapping': {'a': {'fixed': "\u3083"}, 'u': {'fixed': "\u3085"}, 'o': {'fixed': "\u3087"}}}
  let table['m']['mapping']['y'] = {'mapping': {'a': {'fixed': "\u307F\u3083"}, 'u': {'fixed': "\u307F\u3085"}, 'o': {'fixed': "\u307F\u3087"}}}
  let table['n']['mapping']['y'] = {'mapping': {'a': {'fixed': "\u306B\u3083"}, 'u': {'fixed': "\u306B\u3085"}, 'o': {'fixed': "\u306B\u3087"}}}
  let table['r']['mapping']['y'] = {'mapping': {'a': {'fixed': "\u308A\u3083"}, 'u': {'fixed': "\u308A\u3085"}, 'o': {'fixed': "\u308A\u3087"}}}
  let table['s']['mapping']['y'] = {'mapping': {'a': {'fixed': "\u3057\u3083"}, 'u': {'fixed': "\u3057\u3085"}, 'o': {'fixed': "\u3057\u3087"}}}
  let table['t']['mapping']['y'] = {'mapping': {'a': {'fixed': "\u3061\u3083"}, 'u': {'fixed': "\u3061\u3085"}, 'o': {'fixed': "\u3061\u3087"}}}
  let table['v']['mapping']['y'] = {'mapping': {'a': {'fixed': "\u3094\u3083"}, 'u': {'fixed': "\u3094\u3085"}, 'o': {'fixed': "\u3094\u3087"}}}
  let table['w']['mapping']['y'] = {'mapping': {'a': {'fixed': "\u3046\u3083"}, 'u': {'fixed': "\u3046\u3085"}, 'o': {'fixed': "\u3046\u3087"}}}
  let table['x']['mapping']['y'] = {'mapping': {'a': {'fixed': "\u3083"}, 'u': {'fixed': "\u3085"}, 'o': {'fixed': "\u3087"}}}
  let table['z']['mapping']['y'] = {'mapping': {'a': {'fixed': "\u3058\u3083"}, 'u': {'fixed': "\u3058\u3085"}, 'o': {'fixed': "\u3058\u3087"}}}
  " n + shiin
  let table['n']['mapping']['b'] = {'fixed': "\u3093", 'mapping': table['b']['mapping']}
  let table['n']['mapping']['d'] = {'fixed': "\u3093", 'mapping': table['d']['mapping']}
  let table['n']['mapping']['f'] = {'fixed': "\u3093", 'mapping': table['f']['mapping']}
  let table['n']['mapping']['g'] = {'fixed': "\u3093", 'mapping': table['g']['mapping']}
  let table['n']['mapping']['h'] = {'fixed': "\u3093", 'mapping': table['h']['mapping']}
  let table['n']['mapping']['j'] = {'fixed': "\u3093", 'mapping': table['j']['mapping']}
  let table['n']['mapping']['k'] = {'fixed': "\u3093", 'mapping': table['k']['mapping']}
  let table['n']['mapping']['l'] = {'fixed': "\u3093", 'mapping': table['l']['mapping']}
  let table['n']['mapping']['m'] = {'fixed': "\u3093", 'mapping': table['m']['mapping']}
  let table['n']['mapping']['p'] = {'fixed': "\u3093", 'mapping': table['p']['mapping']}
  let table['n']['mapping']['r'] = {'fixed': "\u3093", 'mapping': table['r']['mapping']}
  let table['n']['mapping']['s'] = {'fixed': "\u3093", 'mapping': table['s']['mapping']}
  let table['n']['mapping']['t'] = {'fixed': "\u3093", 'mapping': table['t']['mapping']}
  let table['n']['mapping']['v'] = {'fixed': "\u3093", 'mapping': table['v']['mapping']}
  let table['n']['mapping']['w'] = {'fixed': "\u3093", 'mapping': table['w']['mapping']}
  let table['n']['mapping']['x'] = {'fixed': "\u3093", 'mapping': table['x']['mapping']}
  let table['n']['mapping']['z'] = {'fixed': "\u3093", 'mapping': table['z']['mapping']}
  return table
endfunction

function! bim#table#hiragana2katakana()
  let table = {}
  let table["\u3041"] = "\u30A1"
  let table["\u3042"] = "\u30A2"
  let table["\u3043"] = "\u30A3"
  let table["\u3044"] = "\u30A4"
  let table["\u3045"] = "\u30A5"
  let table["\u3046"] = "\u30A6"
  let table["\u3047"] = "\u30A7"
  let table["\u3048"] = "\u30A8"
  let table["\u3049"] = "\u30A9"
  let table["\u304A"] = "\u30AA"
  let table["\u304B"] = "\u30AB"
  let table["\u304C"] = "\u30AC"
  let table["\u304D"] = "\u30AD"
  let table["\u304E"] = "\u30AE"
  let table["\u304F"] = "\u30AF"
  let table["\u3050"] = "\u30B0"
  let table["\u3051"] = "\u30B1"
  let table["\u3052"] = "\u30B2"
  let table["\u3053"] = "\u30B3"
  let table["\u3054"] = "\u30B4"
  let table["\u3055"] = "\u30B5"
  let table["\u3056"] = "\u30B6"
  let table["\u3057"] = "\u30B7"
  let table["\u3058"] = "\u30B8"
  let table["\u3059"] = "\u30B9"
  let table["\u305A"] = "\u30BA"
  let table["\u305B"] = "\u30BB"
  let table["\u305C"] = "\u30BC"
  let table["\u305D"] = "\u30BD"
  let table["\u305E"] = "\u30BE"
  let table["\u305F"] = "\u30BF"
  let table["\u3060"] = "\u30C0"
  let table["\u3061"] = "\u30C1"
  let table["\u3062"] = "\u30C2"
  let table["\u3063"] = "\u30C3"
  let table["\u3064"] = "\u30C4"
  let table["\u3065"] = "\u30C5"
  let table["\u3066"] = "\u30C6"
  let table["\u3067"] = "\u30C7"
  let table["\u3068"] = "\u30C8"
  let table["\u3069"] = "\u30C9"
  let table["\u306A"] = "\u30CA"
  let table["\u306B"] = "\u30CB"
  let table["\u306C"] = "\u30CC"
  let table["\u306D"] = "\u30CD"
  let table["\u306E"] = "\u30CE"
  let table["\u306F"] = "\u30CF"
  let table["\u3070"] = "\u30D0"
  let table["\u3071"] = "\u30D1"
  let table["\u3072"] = "\u30D2"
  let table["\u3073"] = "\u30D3"
  let table["\u3074"] = "\u30D4"
  let table["\u3075"] = "\u30D5"
  let table["\u3076"] = "\u30D6"
  let table["\u3077"] = "\u30D7"
  let table["\u3078"] = "\u30D8"
  let table["\u3079"] = "\u30D9"
  let table["\u307A"] = "\u30DA"
  let table["\u307B"] = "\u30DB"
  let table["\u307C"] = "\u30DC"
  let table["\u307D"] = "\u30DD"
  let table["\u307E"] = "\u30DE"
  let table["\u307F"] = "\u30DF"
  let table["\u3080"] = "\u30E0"
  let table["\u3081"] = "\u30E1"
  let table["\u3082"] = "\u30E2"
  let table["\u3083"] = "\u30E3"
  let table["\u3084"] = "\u30E4"
  let table["\u3085"] = "\u30E5"
  let table["\u3086"] = "\u30E6"
  let table["\u3087"] = "\u30E7"
  let table["\u3088"] = "\u30E8"
  let table["\u3089"] = "\u30E9"
  let table["\u308A"] = "\u30EA"
  let table["\u308B"] = "\u30EB"
  let table["\u308C"] = "\u30EC"
  let table["\u308D"] = "\u30ED"
  let table["\u308E"] = "\u30EE"
  let table["\u308F"] = "\u30EF"
  let table["\u3090"] = "\u30F0"
  let table["\u3091"] = "\u30F1"
  let table["\u3092"] = "\u30F2"
  let table["\u3093"] = "\u30F3"
  let table["\u3094"] = "\u30F4"
  let table["\u3095"] = "\u30F5"
  let table["\u3096"] = "\u30F6"
  let table["\u30FC"] = "\u30FC"
  let table["\u309D"] = "\u30FD"
  let table["\u309E"] = "\u30FE"
  return table
endfunction

