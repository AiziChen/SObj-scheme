;;;;;;;;;;;;;;;;;;;;;
 ; SObj for scheme ;
 ; @author Quanyec ;
;;;;;;;;;;;;;;;;;;;;;
;;; tags ;;;
(define SOBJ-TAG '*obj)
(define LIST-TAG '*list)

;;; basic procedures ;;;
(define first car)
(define second cadr)
(define key-value-pair?
  (lambda (lat)
    (and (= 2 (length lat))
         (atom? (first lat))
         (atom? (second lat)))))
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

(define ->JSON-value
  (lambda (e)
    (cond
     [(string? e) (string-append "\"" e "\"")]
     [(symbol? e) (->JSON-value (symbol->string e))]
     [(number? e) (number->string e)]
     [(char? e) (string e)]
     [(boolean? e) (if e "true" "false")]
     [(null? e) "null"]
     [else (error '->JSON-value (format "~a do not convert to string" e))])))


;;;;;;;;;;;;;;;;;;;;;
;;; SObj THINGS
;;;;;;;;;;;;;;;;;;;;;
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
         [else (sfind (cdr sobj) k)]))])))
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
     [else (error 'sobj-ref "Invalid SObj syntax")])))


;;;;;;;;;;;;;;;;;;;;;;
;;; HASH TABLE THINGS
;;;;;;;;;;;;;;;;;;;;;;
(define sobj->hashtable-list
  (lambda (lat)
    (cond
     [(null? lat) '()]
     [(atom? lat) lat]
     [(*sobj? (car lat))
      (cons (sobj->hashtable (car lat))
        (sobj->hashtable-list (cdr lat)))]
     [(*list? (car lat))
      (cons (sobj->hashtable-list (cdar lat))
        (sobj->hashtable-list (cdr lat)))]
     [else
      (cons (sobj->hashtable-list (car lat))
        (sobj->hashtable-list (cdr lat)))])))
;;; sobj->hashtable
(define sobj->hashtable
  (case-lambda
   [(lat) (sobj->hashtable (make-eq-hashtable) lat)]
   [(ht lat)
    (cond
     [(null? lat) ht]
     [(*sobj? lat)
      (sobj->hashtable ht (cdr lat))]
     [(*list? lat)
      (sobj->hashtable-list (cdr lat))]
     [else
      (let ([kvp (first lat)])
        (cond
         [(key-value-pair? kvp)
          (put-hash-table! ht (first kvp) (second kvp))
          (sobj->hashtable ht (cdr lat))]
         [else
          (put-hash-table! ht (first kvp)
            (sobj->hashtable (second kvp)))
          (sobj->hashtable ht (cdr lat))]))])]))
;;; s-ref -- SObj's hashtable reference
(define s-ref
  (lambda (ht-sobj k)
    (hashtable-ref ht-sobj k '())))
(define hashtable->sobj
  (lambda (ht)
    (letrec ([->list
              (lambda (lat)
                (cond
                 [(null? lat) '()]
                 [(atom? lat) lat]
                 [(hashtable? (car lat))
                  (cons (hashtable->sobj (car lat))
                    (->list (cdr lat)))]
                 [(list? (car lat))
                  (cons (cons LIST-TAG (car lat))
                    (->list (cdr lat)))]
                 [else
                  (cons (->list (car lat))
                    (->list (cdr lat)))]))])
      (cons SOBJ-TAG
        (hash-table-map ht
          (lambda (k v)
            (cond
             [(hashtable? v)
              (cons k
                (cons (hashtable->sobj v) '()))]
             [(list? v)
              (cons k
                (cons (cons LIST-TAG (->list v))
                  '()))]
             [else (cons k (cons v '()))])))))))

;;;;;;;;;;;;;;;;;;;;;
;;; JSON THINGS
;;;;;;;;;;;;;;;;;;;;;
(define sobj->JSON-list
  (lambda (lat)
    (cond
     [(null? lat) "]"]
     [(or (*sobj? (first lat))
          (*list? (first lat)))
      (string-append (sobj->JSON (first lat))
        (if (null? (cdr lat)) "]"
            (string-append "," (sobj->JSON-list (cdr lat)))))]
     [else
      (string-append (->JSON-value (first lat))
        (if (null? (cdr lat)) "]"
            (string-append "," (sobj->JSON-list (cdr lat)))))])))
;;; sobj->JSON
(define sobj->JSON
  (lambda (lat)
    (cond
     [(null? lat) "{}"]
     [(or (*sobj? lat) (*list? lat))
      (let loop ([lat lat])
        (cond
         ;;[(null? lat) "}"]
         [(*sobj? lat)
          (string-append "{" (loop (cdr lat)))]
         [(*list? lat)
          (string-append "[" (sobj->JSON-list (cdr lat)))]
         [else
          (let* ([fp (first lat)]
                 [k (first fp)]
                 [v (second fp)])
            (if (null? (cdr lat))
                (string-append (->JSON-value k) ":" (sobj->JSON v) "}")
                (string-append (->JSON-value k) ":" (sobj->JSON v) ","
                  (loop (cdr lat)))))]))]
     [(atom? lat) (->JSON-value lat)]
     [else (error 'sobj-ref "Invalid SObj syntax")])))
