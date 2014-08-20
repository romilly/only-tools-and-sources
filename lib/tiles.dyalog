⍝ visualise a boolean matrix using block drawing Unicode characters
print←{
  m n←⌈2÷⍨⍴⍵
  ⍞←' ▘▝▀▖▌▞▛▗▚▐▜▄▙▟█'[((4⍴2)∘⊥⌽)¨,¨⊂[2 3]0 2 1 3⍉m 2 n 2⍴(2×m n)↑⍵]
}
