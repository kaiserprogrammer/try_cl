(asdf:defsystem try-cl
  :version "0"
  :description "Try Common Lisp out"
  :maintainer "Jürgen Bickert <juergenbickert@gmail.com>"
  :author "Jürgen Bickert <juergenbickert@gmail.com>"
  :licence "GPL"
  :depends-on (fiveam anaphora)
  :serial t
  :components ((:static-file "README.md" :pathname "README.md")
               (:file "try_cl")
               (:file "safe-cl")
               (:file "try_cl-test")))
