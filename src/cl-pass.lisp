(in-package :cl-user)
(defpackage cl-pass
  (:use :cl)
  (:export :salt
           :hash
           :check-password))
(in-package :cl-pass)

(defparameter +known-digests+
  (list :pbkdf2-sha1 :pbkdf2-sha256 :pbkdf2-sha512))

(defparameter *package-random-state* nil
  "Holds the random state used for generation of random numbers.")

(defun salt (&optional (size 16))
  "Generate a salt of a given size."
  (unless *package-random-state*
    (setf *package-random-state* (make-random-state t)))
  (let* ((*random-state* (make-random-state *package-random-state*))
         (salt (ironclad:make-random-salt size)))
    (setf *package-random-state* (make-random-state nil))
    salt))

(defun pbkdf2 (password salt digest iterations)
  (ironclad:pbkdf2-hash-password-to-combined-string password
                                                    :salt salt
                                                    :digest digest
                                                    :iterations iterations))

(defun hash (password &key (type :pbkdf2-sha256)
                      (salt (salt 16))
                      (iterations 20000))
  "Hash a password string."
  (declare (optimize (speed 3) (safety 0) (debug 0)))
  (let ((pass (trivial-utf-8:string-to-utf-8-bytes password)))
    (case type
      (:pbkdf2-sha1
       (pbkdf2 pass salt :sha1 iterations))
      (:pbkdf2-sha256
       (pbkdf2 pass salt :sha256 iterations))
      (:pbkdf2-sha512
       (pbkdf2 pass salt :sha512 iterations))
      (t
       (error "No such digest: ~A. Available digests: ~A."
              type
              +known-digests+)))))

(defun constant-string= (a b)
  "Custom string equality function to defeat timing attacks."
  (if (= (length a) (length b))
      (let ((result 0))
        (loop for char-a across a
              for char-b across b
              do
          (setf result (logior result (logxor (char-code char-a)
                                              (char-code char-b)))))
        (= result 0))
      nil))

(defun parse-password-hash (password-hash)
  "Parse a combined string into a list containing the digest; and the number of
iterations, salt and algorithm used to produce it."
  (let* ((split (split-sequence:split-sequence #\$ password-hash))
         (function (first split))
         (digest (first
                  (split-sequence:split-sequence #\: (second split)))))
    (list :digest (intern (string-upcase (concatenate 'string function "-" digest))
                          :keyword)
          :iterations (parse-integer
                       (second (split-sequence:split-sequence #\: (second split))))
          :salt (third split)
          :hash (fourth split))))

(defun check-password (pass password-hash)
  "Verify that PASS hashes to PASSWORD-HASH. Extracts the parameters (Salt,
algorithm, number of iterations) in PASSWORD-HASH, so you don't have to pass
anything else."
  (declare (type string pass password-hash))
  (let ((parsed (parse-password-hash password-hash)))
    (constant-string= password-hash
                      (hash pass
                            :type (getf parsed :digest)
                            :salt (ironclad:hex-string-to-byte-array (getf parsed :salt))
                            :iterations (getf parsed :iterations)))))
