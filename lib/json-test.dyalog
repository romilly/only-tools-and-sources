#!/usr/bin/env rundyalog
json←import'json.dyalog'
⎕cy'dfns.dws'

(r←⎕ns'').(n m)←0 ⍝ n:total number of test cases  m:number of passed test cases

eq←{ ⍝ like ⍺≢⍵ but supports comparison between namespace references
  (⍴⍺)≢⍴⍵:0
  0≠⍴⍴⍵:∧/,⍺eq¨⍵
  (⎕nc'⍺')≢⎕nc'⍵':0
  9≠⎕nc'⍵':⍺≡⍵
  nl←⍺.⎕nl 2 9
  nl≢⍵.⎕nl 2 9:0
  0≡≢,nl:1
  (⍺.⍎¨↓nl)eq⍵.⍎¨↓nl
}

t←{ ⍝ positive test case  ⍺:json document  ⍵:expected result
  r.n+←1
  0::⍺{⎕←'Failed: ',⍺ ⋄ ⎕←⎕dmx}⍵
  x←json.parse⍺
  ~⍵eq x:⍺{⎕←'Expected '(display⍵)' but got '(display x) ⋄ ⍬}⍵
  r.m+←1
}

f←{ ⍝ negative test case  ⍵:json document
  r.n+←1
  0::r.m+←1
  _←json.parse⍵
  ⎕←'Should have failed but didn''t: ',⍵
}

ns←{ ⍝ namespace constructor
  0≡≢⍵:⎕ns⍬
  r←ns 2↓⍵
  _←⍎'r.',(⊃⍵),'←1⊃⍵'
  r
}

'1't 1
'[]'t⍬
f'['
f']'
f'[]]'
'[1]'t,1
'[1,2]'t 1 2
f'[1,]'
'[[1]]'t,⊂,1
'[[],[[]]]'t⍬(,⊂⍬)
'-12.34e1't¯12.34e1
'-12.34e+1't¯12.34e1
'-1e-2't¯1e¯2
f'1 2'
'null't⎕null
f'nulll'
'""'t''
'"x"'t,'x'
f'"x',(⎕ucs 9),'y"'
'"\u1234\t"'t⎕ucs 4660 9
('   { "asdf"  :',(⎕ucs 10),' 1234, "kjfd": [1,2,null]}  ')t ns'asdf'1234'kjfd'(1 2⎕null)

⎕←{
  r.m≡r.n:'All ',(⍕r.n),' tests passed.'
  (⍕r.n-r.m),' out of ',(⍕r.n),' tests failed.'
}⍬
