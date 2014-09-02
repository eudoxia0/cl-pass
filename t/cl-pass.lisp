(in-package :cl-user)
(defpackage cl-pass-test
  (:use :cl :cl-pass :fiveam))
(in-package :cl-pass-test)

(def-suite cl-pass)
(in-suite cl-pass)

(defparameter +hash+ "PBKDF2$sha256:20000$5cf6ee792cdf05e1ba2b6325c41a5f10$19c7f2ccb3880716bf7cdf999b3ed99e07c7a8140bab37af2afdc28d8806e854")

(test passwords
  (is (equal (cl-pass:hash "test") +hash+))
  (is-true (check-password "test" +hash+))
  (is-false (check-password "nope" +hash+)))
