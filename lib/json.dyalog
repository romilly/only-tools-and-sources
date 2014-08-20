⍝ a JSON parser
⍝
⍝ usage:
⍝   json←import'json'
⍝   json.parse'{"abc": [123, true, null, [], {}]}'
⍝
⍝ JSON objects are represented as namespaces.  The parser fails if some key is not a valid APL identifier.

⍝ TD:token type definitions
TD ←⊂'[ \t\n\r]+'                                           'W' ⍝ whitespace
TD,←⊂'-?(0|[1-9]\d*)(\.\d+)?([eE][+\-]?\d+)?'               'N' ⍝ number
TD,←⊂'"([^"\\\x00-\x1f]|\\(["\\/bfnrt]|u[0-9a-fA-F]{4}))*"' 'S' ⍝ string
TD,←⊂'[,:\[\]\{\}]|null|true|false'                         'X' ⍝ self
TD,←⊂'.+'                                                   'E' ⍝ error
TD,←⊂'$'                                                    '$' ⍝ eof
TR TN←↓⍉↑TD ⍝ TN:names TR:regexes

parse←{
  err←{(i m)←⍵ ⋄ ('JSON error at position ',(⍕o[i]),': ',m)⎕signal 500}

  (t o v)←↓⍉↑TR⎕s{TN[⍵.PatternNum](⍵.Offsets[0])⍵.Match}⍠('Mode' 'D')('DotAll'1)⊢⍵ ⍝ types offsets values
  (t o v)←(⊂t≠'W')/¨t o v ⍝ ignore whitespace
  ((t='X')/t)←⊃¨(t='X')/v ⍝ for "self" tokens, type=value
  'E'∊t:err(t⍳'E')'invalid token'

  ⍝ for parseXXX functions  ⍵:tokenIndex  result:(tokenIndex value)

  parseObject←{
    t[⍵]≢'S':err⍵'object keys must be strings'
    (i k)←parseString⍵
    t[i]≢':':err i'expected :'
    (j v)←parseValue i+1
    0≡≢'^[A-Z_a-zÀ-ÖØ-Ýß-öø-üþ∆⍙Ⓐ-Ⓩ][A-Z_a-zÀ-ÖØ-Ýß-öø-üþ∆⍙Ⓐ-Ⓩ0-9]*$'⎕s''⍠'Mode' 'D'⊢k:err⍵'object keys are restricted to valid APL identifiers'
    _1←⍎'⍺.',k,'←v'
    t[j]≡'}':(j+1)⍺
    t[j]≢',':err j'expected , or }'
    ⍺∇j+1
  }

  parseArray←{
    (i x)←parseValue⍵
    t[i]≡']':(i+1)(⍺,⊂x)
    t[i]≢',':err⍵'expected , or ]'
    (⍺,⊂x)∇i+1
  }

  parseValue←{
    t[⍵]≡'S':parseString⍵
    t[⍵]≡'N':parseNumber⍵
    t[⍵]≡'{':{t[⍵+1]≡'}':(⍵+2)(⎕ns⍬) ⋄ (⎕ns⍬)parseObject⍵+1}⍵
    t[⍵]≡'[':{t[⍵+1]≡']':(⍵+2)⍬ ⋄ ⍬parseArray⍵+1}⍵
    t[⍵]∊'tfn':(⍵+1)(1 0 ⎕null['tfn'⍳t[⍵]])
    err⍵'unexpected token'
  }

  parseString←{
    (⍵+1),⊂'\\(["\\/bfnrt]|u[0-9a-fA-F]{4})'⎕r{
      'u'≡1⊃⍵.Match:⎕ucs 16⊥(⎕d,'abcdef')⍳'.+'⎕r'\l0'⊢2↓⍵.Match
      ⎕ucs 34 92 47 8 12 10 13 9['"\/bfnrt'⍳1⊃⍵.Match]
    }1↓¯1↓⍵⊃v
  }

  parseNumber←{
    (⍵+1),⍎'\+' '-'⎕r'' '¯'⊢⍵⊃v
  }

  (i x)←parseValue 0
  i≢¯1+≢t:err i'json document must contain a single value'
  x
}
