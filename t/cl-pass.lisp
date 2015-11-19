(in-package :cl-user)
(defpackage cl-pass-test
  (:use :cl :cl-pass :fiveam)
  (:export :run-tests))
(in-package :cl-pass-test)

(def-suite cl-pass)
(in-suite cl-pass)

(test passwords
  (let ((hash (cl-pass:hash "test")))
    (is-true (check-password "test" hash))
    (is-false (check-password "nope" hash))))

(defun run-tests ()
  (run! 'cl-pass))
