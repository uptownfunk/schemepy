; Scheme Utility Functions
(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))

(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

; Problem 18

;; Merge two lists LIST1 and LIST2 according to COMP and return
;; the merged lists.
(define (merge comp list1 list2)

	(cond ((null? list1) list2) 
		  ((null? list2) list1)
		  ((comp (car list1) (car list2)) 
		     (cons (car list1) (merge comp (cdr list1) list2)))
		  (else (cons (car list2) (merge comp list1 (cdr list2))))))

    

(merge < '(1 5 7 9) '(4 8 10))
; expect (1 4 5 7 8 9 10)
(merge > '(9 7 5 1) '(10 8 4 3))
; expect (10 9 8 7 5 4 3 1)

;; Sort a list of lists of numbers to be in decreasing lexicographic
;; order. Relies on a correct implementation of merge.
(define (sort-lists lsts)
  (if (or (null? lsts) (null? (cdr lsts)))
      lsts
      (let ((sublsts (split lsts)))
        (merge greater-list
               (sort-lists (car sublsts))
               (sort-lists (cdr sublsts))))))

(define (greater-list x y)
  (cond ((null? y) #t)
        ((null? x) #f)
        ((> (car x) (car y)) #t)
        ((> (car y) (car x)) #f)
        (else (greater-list (cdr x) (cdr y)))))

(define (split x)
  (cond ((or (null? x) (null? (cdr x))) (cons x nil))
        (else (let ((sublsts (split (cdr (cdr x)))))
                (cons (cons (car x) (car sublsts))
                      (cons (car (cdr x)) (cdr sublsts)))))))

(merge greater-list '((3 2 1) (1 1) (0)) '((4 0) (3 2 0) (3 2) (1)))
; expect ((4 0) (3 2 1) (3 2 0) (3 2) (1 1) (1) (0))


; Problem 19

; A list of all ways to partition TOTAL, where  each partition must
; be at most MAX-VALUE and there are at most MAX-PIECES partitions.
(define (list-partitions total max-pieces max-value)

  (define (with total max-pieces max-value)
	(let ((smaller (list-partitions (- total max-value) (- max-pieces 1) max-value)))
	(let ((smaller-extended 
		(if (null? smaller) 
		  nil 
	      (map (lambda (lst) (cons max-value lst)) smaller))))
	  (if (= total max-value)
		(cons (list total) smaller-extended)
		smaller-extended))))
  (define (without total max-pieces max-value)
	(let ((smaller (list-partitions total max-pieces (- max-value 1))))
	  (if (null? smaller)
		nil
		smaller)))
  (cond ((or (<= total 0) (= 0 max-pieces) (= 0 max-value)) nil)
		((= 1 total) (cons '(1) nil))
		(else 
			(append 
			(with total max-pieces max-value) 
			(without total max-pieces max-value)))))

		
; Problem 19 tests rely on correct Problem 18.
(sort-lists (list-partitions 5 2 4))
; expect ((4 1) (3 2))
(sort-lists (list-partitions 7 3 5))
; expect ((5 2) (5 1 1) (4 3) (4 2 1) (3 3 1) (3 2 2))


; Problem 20

;; The Tree abstract data type has an entry and a list of children.
(define (make-tree entry children)
  (cons entry children))
(define (entry tree)
  (car tree))
(define (children tree)
  (cdr tree))

;; An example tree:
;;                5
;;       +--------+--------+
;;       |        |        |
;;       6        7        2
;;    +--+--+     |     +--+--+
;;    |     |     |     |     |
;;    9     8     1     6     4
;;                      |
;;                      |
;;                      3
(define tree
  (make-tree 5 (list
                (make-tree 6 (list
                              (make-tree 9 nil)
                              (make-tree 8 nil)))
                (make-tree 7 (list
                              (make-tree 1 nil)))
                (make-tree 2 (list
                              (make-tree 6 (list
                                            (make-tree 3 nil)))
                              (make-tree 4 nil))))))

;; Takes a TREE of numbers and outputs a list of sums from following each
;; possible path from root to leaf.
(define (reduce op lst base)
  (if (null? lst)
	base
	(op (car lst) (reduce op (cdr lst) base))))

(reduce + (list 1 2 3 4) 0)
; expect 10

(reduce append (list '(1 2 3) '(4 5 6)) nil)
; expect (1 2 3 4 5 6)

(define (tree-sums tree)

  (cond ((null? tree) nil)
		((null? (children tree)) (list (entry tree)))
		(else 
		  (let ((add-entry (lambda (n) (+ (entry tree) n))))
			(map add-entry (reduce append (map tree-sums (children tree)) nil))))))
	  






(tree-sums tree)
; expect (20 19 13 16 11)


; Problem 21 (optional)

; Draw the hax image using turtle graphics.
(define (hax d k)
  nil)
