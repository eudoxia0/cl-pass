(asdf:defsystem cl-pass
  :version "0.1"
  :author "Fernando Borretti"
  :license "MIT"
  :homepage "https://github.com/eudoxia0/cl-pass"
  :depends-on (:ironclad
               :trivial-utf-8
               :split-sequence)
  :components ((:module "src"
                :components
                ((:file "cl-pass"))))
  :description "Password hashing and verification library."
  :long-description
  #.(uiop:read-file-string
     (uiop:subpathname *load-pathname* "README.md"))
  :in-order-to ((test-op (test-op cl-pass-test))))
