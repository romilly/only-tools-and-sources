#!/usr/bin/env rundyalog
tiles←import'../tiles.dyalog'

f←{
  ⍵=0:1 1⍴1
  a←f⍵-1
  b←a,((⍴a)⍴0),a
  ⊃⍪/b((⍴b)⍴0)b
}

tiles.print f 4
