;;; Sobj for scheme
(define SOBJ-TAG '*obj)
(define LIST-TAG '*list)

(define first car)
(define second cadr)

(define *list?
  (lambda (sobj)
    (and (pair? sobj) (eq? LIST-TAG (first sobj)))))

(define *sobj?
  (lambda (sobj)
    (and (pair? sobj) (eq? SOBJ-TAG (first sobj)))))

;;; sfind - find an key from SObj
(define sfind
  (lambda (sobj k)
    (cond
     [(null? sobj) '()]
     [else
      (let ([left (first sobj)])
	(cond
	 [(eq? (first left) k)
	  (if (*list? (second left))
	      (cdr (second left))
	      (second left))]
	 [else
	  (sfind (cdr sobj) k)]))])))

;;; sobj-ref
(define sobj-ref
  (lambda (lat a)
    (cond
     [(or (*sobj? lat) (*list? lat))
      (sfind (cdr lat) a)]
     [else
      (error 'sobj-ref "Invalid SObj syntax")])))




