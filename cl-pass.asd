(asdf:defsystem cl-pass
  :version "0.1"
  :author "Fernando Borretti"
  :license "MIT"
  :depends-on (:ironclad
               :trivial-utf-8
               :split-sequence)
  :components ((:module "src"
                :components
                ((:file "cl-pass"))))
  :description "Password hashing and verification library."
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.md"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op cl-pass-test))))
