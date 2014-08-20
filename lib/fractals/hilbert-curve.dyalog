#!/usr/bin/env rundyalog
tiles←import'../tiles.dyalog'

H←{
  ⍵=0:1 1⍴1
  A←⍉a←∇⍵-1
  B←⌽b←1,0⍴⍨¯2+2*⍵
  (a,B,a)⍪(b,0,B)⍪(⌽A),0,A
}

tiles.print H 5
