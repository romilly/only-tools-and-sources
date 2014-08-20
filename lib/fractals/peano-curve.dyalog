#!/usr/bin/env rundyalog
tiles←import'../tiles.dyalog'

P←{
  ⍵=0:⍺
  A←⌽⍺
  V←⌽v←1,0⍴⍨¯1+≢⍺
  H←⌽h←1,0⍴⍨¯1+1⊃⍴⍺
  (⊃⍪/(⍺,v,A,0,⍺)(h,0,H,0,h)(A,0,⍺,0,A)(H,0,h,0,H)(⍺,0,A,V,⍺))∇⍵-1
}

tiles.print(2 5⍴1 1 1 0 1 1 0 1 1 1)P 3
