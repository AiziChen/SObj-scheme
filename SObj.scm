;;; SObj for scheme
(define SOBJ-TAG '*obj)
(define LIST-TAG '*list)

(define first car)
(define second cadr)
(define apair?
  (lambda (lat)
    (and (pair? lat) (<= 2 (length lat)))))

(define *list?
  (lambda (sobj)
    (and (apair? sobj) (eq? LIST-TAG (first sobj)))))

(define *sobj?
  (lambda (sobj)
    (and (apair? sobj) (eq? SOBJ-TAG (first sobj)))))

;;; sfind - find an key from SObj
(define sfind
  (lambda (sobj k)
    (cond
     [(null? sobj) '()]
     [else
      (let* ([fp (first sobj)]
	     [v (second fp)])
	(cond
	 [(eq? (first fp) k)
	  (if (*list? v) (cdr v) v)]
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




