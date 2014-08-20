#!/usr/bin/env rundyalog
tiles←import'../tiles.dyalog'
f←{⍵=0:1 1⍴1 ⋄ a←∇⍵-1 ⋄ (a,a)⍪a,(⍴a)⍴0}
tiles.print f 6
