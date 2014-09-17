#!/usr/bin/env rundyalog
lisp←import'lisp.dyalog'

s ←'((lambda (cons car cdr)'
s,←'   (write (car (cons 123 456))))'
s,←' (lambda (x y) (lambda (i) (cond (i y) (else x))))'
s,←' (lambda (xy) (xy 0))'
s,←' (lambda (xy) (xy 1)))'
lisp.exec s  ⍝ should print 123

⍝ Y combinator ("\" is an alias for "lambda")
Y←'(\(f)((\(x)(x x))(\(x)(f(\(y)((x x)y))))))'
F←'(\(f)(\(n)(cond((= n 0)1)(else(* n(f(- n 1)))))))'
lisp.exec'(write ((',Y,F,')4))' ⍝ should print 24
