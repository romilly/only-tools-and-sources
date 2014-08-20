#!/usr/bin/env rundyalog
tiles←import'../tiles.dyalog'
rule←30 ⋄ n←50 ⋄ t←⌽rule⊤⍨8⍴2
tiles.print↑⌽{⍵,⍨⊂t[2⊥¨3,/0,0,⍨⊃⍵]}⍣n⊂z,1,z←n⍴0
