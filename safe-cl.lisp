(defpackage :safe-cl
  (:use :cl)
  (:shadow :read-from-string))

(in-package :safe-cl)

(defun read-from-string (&rest args)
  (apply #'try-cl::safe-read args))

(export '(+ defvar format nil code-char eval read-from-string))
