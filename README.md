# SObj-scheme
SObj for the Scheme Programming Language

The `Java` and the `JavaScript` version is also here:
Java: http://github.com/AiziChen/SObj-java.git
JavaScript: http://github.com/AiziChen/SObj-typescript.git

## Usage
You can see examples below and the `SObj-test.scm` file

```scheme
;; load `SObj.scm` library
(load "SObj.scm")

;;; base test
(define u1
  '(*obj
    (id 1)
    (name "DavidChen")
    (age 25)
    (birth "2019-01-16 01:08,30")
    (glasses ((id 1)
	      (degree 203.3)
	      (color "RED-BLACK")))
    (height 167.3)
    (goods (*list
	    (*obj (name "火龙果") (price 2.3))
	    (*obj (name "雪梨") (price 3.2))))
    (behaviors (*list "Shopping""Running""Football"))))

;;; START TESTS
;; * Get name
(sobj-ref u1 'name)
;; * Get glasses sobj
(sobj-ref u1 'glasses)
;; * Get goods list
(sobj-ref u1 'goods)
;; * Get goods list first element
(car (sobj-ref u1 'goods))
;; * Get behaviors list
(sobj-ref u1 'behaviors)
```
