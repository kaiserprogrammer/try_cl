(defpackage :safe-cl
  (:use :cl)
  (:shadow :read-from-string))

(in-package :safe-cl)

(defun read-from-string (&rest args)
  (apply #'try-cl::safe-read args))

(export '(+
          -
          *
          /
          1+
          1-
          lambda
          exp
          expt
          log
          defvar
          defparameter
          defun
          defmacro
          list
          cons
          map
          mapcar
          concatenate
          format
          nil
          code-char
          eval
          let
          let*
          t
          sleep
          read-from-string))
