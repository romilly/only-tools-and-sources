⍝ Huffman coding
⍝
⍝ usage:
⍝   huffman←import'huffman.dyalog'
⍝   huffman.init'sample text to derive frequencies from'
init←{

  ⍝ build histogram as an inverted table of characters and their frequencies
  h←↓⍉{⍵[⍒⍵[;1];]}{⍺,⍴⍵}⌸⍵

  ⍝ compute the Huffman tree
  t←⊃{ ⍝ ⍺:trees ⍵:frequencies
    1≡≢⍵:⊃⍺
    i←⍋⍵
    (⍺[2↓i],⊂⍺[2↑i])∇⍵[2↓i],+/⍵[2↑i]
  }/h

  ⍝ encode the paths to the tree's leaves  0:left branch, 1:right branch
  (∊t),[.5]{⍬≡⍴⍵:,⊂'' ⋄ ⊃,/'01',¨¨∇¨⍵}t
}
