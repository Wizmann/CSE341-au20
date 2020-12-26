#lang racket

(require "hw6.rkt")

; This file uses Racket's unit-testing framework, which is convenient but not required of you.

; Note we have provided [only] 3 tests, but you can't run them until do some of the assignment.
; You will want more tests.

(require rackunit)

(define tests
  (test-suite
   "Homework 6 Tests"


  ; Problem 1
  (check-equal? (racketlist->mupllist [list 1 2 3]) (apair 1 (apair 2 (apair 3 munit))) "Problem1")
 
  ; Problem 2
  (check-equal? (mupllist->racketlist (apair 1 (apair 2 (apair 3 munit)))) [list 1 2 3] "Problem2")
 
  ; Problem 3
  (check-equal? (eval-exp (add (int 2) (int 2))) (int 4) "Problem3: add simple test")
 
  (check-equal? (eval-exp (isgreater (int 2) (int 2))) (int 0) "Problem3: isgreater simple test1")
 
  (check-equal? (eval-exp (isgreater (int 3) (int 2))) (int 1) "Problem3: isgreater simple test2")
 
  (check-equal? (eval-exp (isgreater (int 2) (int -1))) (int 1) "Problem3: isgreater simple test3")
 
  (check-equal? (eval-exp (isgreater (int -2) (int -1))) (int 0) "Problem3: isgreater simple test4")
 
  (check-equal? (eval-exp (ifnz (int -2) (int -1) (int -2))) (int -2) "Problem3: ifnz simple test1")
 
  (check-equal? (eval-exp (ifnz (int 0) (int -1) (int -2))) (int -1) "Problem3: ifnz simple test2")
 
  (check-equal? (eval-exp (mlet "foo" (int 1)
                            (add (var "foo") (int 1)))) (int 2) "Problem3: mlet simple test1")

  (check-equal? (eval-exp (mlet "foo" (int 1)
                           (mlet "bar" (int 2)
                            (add (var "foo") (var "bar"))))) (int 3) "Problem3: mlet simple test2")
 
  (check-equal? (eval-exp (first (apair (int 1) (int 2)))) (int 1) "Problem3: apair/first simple test")

  (check-equal? (eval-exp (second (apair (int 1) (int 2)))) (int 2) "Problem3: apair/second simple test")

  (check-equal? (eval-exp
                 (call (eval-exp (fun "plus" "delta" (add (int 1) (var "delta")))) (int 2)))
                 (int 3) "Problem3: call/fun test1")

  (check-exn (lambda (x) (string=? (exn-message x) "MUPL addition applied to non-number"))
             (lambda () (eval-exp (add (int 2) (munit))))
             "Problem3: add bad argument")

  ; (check-equal? (mupllist->racketlist
  ;                (eval-exp (call (call mupl-all-gt (int 9))
  ;                                (racketlist->mupllist 
  ;                                 (list (int 10) (int 9) (int 15))))))
  ;               (list (int 10) (int 15))
  ;               "provided combined test using problems 2, 3, and 5")
  ))

(require rackunit/text-ui)
;; runs the test
(run-tests tests)