;;; Sobj for scheme
(define SOBJ-TAG '*sobj)
(define LIST-TAG '*list)

(define first
  (lambda (lat)
    (car lat)))

(define second
  (lambda (lat)
    (cadr lat)))

(define *list?
  (lambda (sobj)
    (and (pair? sobj) (eq? LIST-TAG (first sobj)))))

(define *sobj?
  (lambda (sobj)
    (and (pair? sobj) (eq? SOBJ-TAG (first sobj)))))

;;; sobj-ref
(define sobj-ref
  (lambda (sobj a)
    (sfind (cdr sobj) a)))

(define sfind
  (lambda (lat a)
    (cond
     [(null? lat) '()]
     [(eq? (first (first lat)) a)
      (if (*list? (second (first lat)))
	  (cdr (second (first lat)))
	  (second (first lat)))]
     [else
      (sfind (cdr lat) a)])))


