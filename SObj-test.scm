(load "SObj.scm")

;;; base test
(define u1
  '(*obj
    (id 1)
    (name "DavidChen")
    (age 25)
    (birth "2019-01-16 01:08,30")
    (glasses (*obj
	      (id 1)
	      (degree 203.3)
	      (color "RED-BLACK")))
    (height 167.3)
    (goods (*list
	    (*obj (name "火龙果") (price 2.3) (vegetable #f))
	    (*obj (name "Peanut") (price 3.2) (vegetable #t))))
    (behaviors (*list "Shopping""Running"))
    (ss (*list (*list 1 2 3) (*list 2 3 5 6)))))

(define su1
  (with-output-to-string
    (lambda () (write u1))))

;;; START TESTS
;; * Get name
(sobj-ref u1 'name)
(sobj-ref su1 'name)
;; * Get glasses sobj
(sobj-ref u1 'glasses)
(sobj-ref su1 'glasses)
;; * Get goods list
(sobj-ref u1 'goods)
(sobj-ref su1 'goods)
;; * Get goods list first element
(sobj-ref (sobj-ref u1 'goods) 0)
(sobj-ref (sobj-ref su1 'goods) 0)
;; * Get behaviors list
(sobj-ref u1 'behaviors)
(sobj-ref su1 'behaviors)
;; SObj to JSON
(sobj->JSON u1)
