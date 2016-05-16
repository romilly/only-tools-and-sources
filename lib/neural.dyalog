#!/usr/bin/env rundyalog
⍝ artificial neural network from http://iamtrask.github.io/2015/07/12/basic-python-network/
⎕rl←1                                ⍝ deterministic PRNG
S←{÷1+*-⍵} ⋄ Sd←{v×1-v←S⍵}           ⍝ sigmoid function and its derivative
scan←{0≡≢⍵:⍬⋄h←⍺ ⍺⍺⊃⍵⋄(⊂h),h⍺⍺∇∇1↓⍵} ⍝ left-to-right scan with initial value ⍺
scan1←{(⊂⍺),⍺ ⍺⍺scan⍵}               ⍝ ditto, prepending initial value to result
n←4 4 1                              ⍝ number of neurons in each layer, including input and output
w←1-2×?(2,/n)⍴¨0                     ⍝ weights, randomly initialised between -1 and 1
t←{                                  ⍝ training function
   l←⍺(S+.×)scan1 w                  ⍝ run forward
   w+←(⍉¨¯1↓l)+.×¨1↓⌽((Sd⊃⌽l)×⍵-⊃⌽l){(1⊃⍵)×⍺+.×⍉⊃⍵}scan1⌽↓⍉↑w(Sd ¯1↓l) ⍝ backpropagation, modify weights
   ⊃⌽l                               ⍝ last layer is the output
}
i←1,↑(0 0 1)(0 1 1)(1 0 1)(1 1 1) ⋄ o←⍪0 1 1 0  ⍝ training inputs and outputs; "1," for bias
{}{i t o}⍣1e4⊢0                      ⍝ train it
(⍉⍪'input' 'expected' 'actual')⍪i o(⊃⌽1,i(S+.×)scan1 w) ⍝ test
