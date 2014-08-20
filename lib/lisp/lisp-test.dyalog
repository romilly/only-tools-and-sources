#!/usr/bin/env rundyalog
lisp←import'lisp.dyalog'

s ←⊂'((lambda (cons car cdr)'
s,←⊂'   (write (car (cons 123 456))))'
s,←⊂''
s,←⊂' (lambda (x y) (lambda (i) (cond (i x) (else y))))'
s,←⊂' (lambda (xy) (xy 0))'
s,←⊂' (lambda (xy) (xy 1)))'

s←⊃,/s,¨⎕ucs 10
lisp.exec s  ⍝ should print 123
