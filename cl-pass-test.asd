(in-package :cl-user)
(defpackage cl-pass-test-asd
  (:use :cl :asdf))
(in-package :cl-pass-test-asd)

(defsystem cl-pass-test
  :author "Fernando Borretti"
  :license "MIT"
  :description "Tests for cl-pass"
  :depends-on (:cl-pass :fiveam)
  :components ((:module "t"
                :components
                ((:file "cl-pass")))))
