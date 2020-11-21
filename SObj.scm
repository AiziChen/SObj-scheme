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

(define read-from-string
  (lambda (s)
    (with-input-from-string s
      (lambda () (read)))))

(define ->value
  (lambda (e)
    (cond
     [(string? e) (string-append "\"" e "\"")]
     [(symbol? e) (symbol->string e)]
     [(number? e) (number->string e)]
     [(char? e) (string e)]
     [(boolean? e)
      (if e "true" "false")]
     [else e])))


;;; sfind - find an key from SObj
(define sfind
  (lambda (sobj k)
    (cond
     [(null? sobj) '()]
     [else
      (let* ([fp (first sobj)]
	     [v (second fp)])
	(cond
	 [(eq? (first fp) k) v]
	 [else
	  (sfind (cdr sobj) k)]))])))

;;; sobj-ref
(define sobj-ref
  (lambda (lat a)
    (cond
     [(string? lat)
      (sobj-ref (read-from-string lat) a)]
     [(*sobj? lat)
      (sfind (cdr lat) a)]
     [(*list? lat)
      (list-ref (cdr lat) a)]
     [else
      (error 'sobj-ref "Invalid SObj syntax")])))


(define sobj->JSON-list
  (lambda (lat)
    (cond
     [(null? lat) "]"]
     [(or (*sobj? (first lat))
	  (*list? (first lat)))
      (string-append
       (sobj->JSON (first lat))
       (if (null? (cdr lat))
	   "]"
	   (string-append
	    ","
	    (sobj->JSON-list (cdr lat)))))]
     [else
      (string-append
       (->value (first lat))
       (if (null? (cdr lat))
	   "]"
	   (string-append
	    ","
	    (sobj->JSON-list (cdr lat)))))])))

;;; sobj->JSON
(define sobj->JSON
  (lambda (lat)
    (cond
     [(null? lat) "}"]
     [(*sobj? lat)
      (string-append
       "{"
       (sobj->JSON (cdr lat)))]
     [(*list? lat)
      (string-append
       "["
       (sobj->JSON-list (cdr lat)))]
     [(pair? lat)
      (cond
       [(pair? (first lat))
	(string-append
	 (sobj->JSON (first lat))
	 (if (null? (cdr lat))
	     "}"
	     (string-append
	      ","
	      (sobj->JSON (cdr lat)))))]
       [else
	(string-append
	 "\""
	 (sobj->JSON (first lat))
	 "\":"
	 (sobj->JSON (second lat)))])]
     [else (->value lat)])))
