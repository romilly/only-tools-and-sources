#!/usr/bin/env rundyalog
huffman←import'huffman.dyalog'

expected ←⊂'a' '000'
expected,←⊂'e' '001'
expected,←⊂'t' '0100'
expected,←⊂'h' '0101'
expected,←⊂'i' '0110'
expected,←⊂'s' '0111'
expected,←⊂'n' '1000'
expected,←⊂'m' '1001'
expected,←⊂'x' '10100'
expected,←⊂'p' '10101'
expected,←⊂'l' '10110'
expected,←⊂'o' '10111'
expected,←⊂'u' '11000'
expected,←⊂'r' '11001'
expected,←⊂'f' '1101'
expected,←⊂' ' '111'
expected←↑expected

⊢code←huffman.init'this is an example of a huffman tree'
{code≢expected:⎕off 1}0
'OK'
