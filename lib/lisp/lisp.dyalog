#!/usr/bin/env rundyalog
⍝ An interpreter for a small subset of Scheme,
⍝ loosely following the structure of the metacircular evaluator from SICP
⍝ https://www.youtube.com/watch?v=0m6hoOelZH8
⍝
⍝ Runs on Dyalog v14.0
⍝
⍝ Lisp   APL
⍝ ----   ---
⍝ 123    123
⍝ atom   'atom'
⍝ (x y)  (x y)
⍝ 'x     ('quote' x)
⍝
⍝ Procedures are represented as 4-vectors of
⍝   'closure' environment parameters body
⍝
⍝ Environments are two-column tables of names and values.


⍝ Parser

⍝ Parser functions take as arguments:
⍝   ⍺ ⍝ the input string
⍝   ⍵ ⍝ the current parse position in ⍺
⍝ and return a triplet of:
⍝   0 position AST      ⍝ on success
⍝   1 position message  ⍝ on failure

ws←⎕ucs 9 10 13 32 ⍝ whitespace characters '\t\r\n '

parse←{
  ⍵≥≢⍺:1⍵'unexpected eof'
  ⍺[⍵]∊ws:⍺∇⍵+1
  ⍺[⍵]≡'(':⍺parseList⍵+1
  ⍺[⍵]∊⎕d:⍺parseNum⍵
  ⍺[⍵]≡'''':⍺parseQuote⍵
  ⍺parseAtom⍵
}

parseList←{ ⍝ parse the inside of a list and consume the ')'
  ⍵≥≢⍺:1⍵'unexpected eof'
  ⍺[⍵]≡')':0(⍵+1)⍬
  (e p h)←⍺parse⍵
  e≠0:e p h
  (e p t)←⍺∇p
  e≠0:e p t
  0p((⊂h),t)
}

parseNum←{
  l←20 ⍝ 1 + the maximum length of a numeric literal
  n←+/∧\⎕d∊⍨l↑⍵↓⍺ ⍝ actual length of the literal
  n≡l:1⍵'numeric literal too long'
  0(⍵+n)(⍎n↑⍵↓⍺)
}

parseAtom←{
  la←20 ⍝ 1 + the maximum length of an atom
  na←ws,⎕d,'()''' ⍝ non-atom characters
  l←+/∧\~na∊⍨la↑⍵↓⍺
  l≡la:1⍵'atom too long'
  0(⍵+l)(l↑⍵↓⍺)
}

parseQuote←{
  (e p r)←⍺parse⍵+1
  e≠0:e p r
  e p('quote'r)
}

⍝ Evaluator

isAtom←{(0≡10|⎕dr⍵)∧1≡≢⍴⍵}
isNum←{(1 3 5 7∊⍨10|⎕dr⍵)∧0≡≢⍴⍵}

eval←{ ⍝ ⍺: environment, ⍵: expression
  isNum⍵:⍵
  isAtom⍵:⊃⍺[⍺[;0]⍳⊂⍵;1]
  0≡≢⍵:⍬
  'quote'≡⊃⍵:⊃⍵[1]
  'lambda'≡⊃⍵:('closure'⍺),1↓⍵
  'cond'≡⊃⍵:⍺evcond 1↓⍵
  (⍺∇⊃⍵)apply(⊂⍺)∇¨1↓⍵
}

apply←{ ⍝ ⍺: procedure, ⍵: arguments
  'closure'≡⊃⍺:(((⊃⍺[2]),[.5]⍵)⍪⊃⍺[1])eval⊃⍺[3]
  ⍎(⊃⍺),'⍵'
}

evcond←{ ⍝ ⍺: environment, ⍵: clauses
  0≡≢⍵:⍬
  'else'≡⊃⊃⍵:⍺eval⊃1↓⊃⍵
  0≢⍺eval⊃⊃⍵:⍺∇1↓⍵
  ⍺eval⊃1↓⊃⍵
}

⍝ Initial environment
env0←⍉⍪ (,'+')  (,⊂'+/')
env0⍪←  (,'-')  (,⊂'-/')
env0⍪←  (,'*')  (,⊂'×/')
env0⍪←  'write' (,⊂'⎕←')

exec←{
  ⍵{
    (e p x)←⍺parse⍵ ⍝ e: error code, p: position, x: AST
    (e≠0)∧x≡'unexpected eof':⍬
    e≠0:x
    r←env0 eval x
    ⍺∇p
  }0
}
