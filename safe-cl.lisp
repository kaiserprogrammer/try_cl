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
          read-from-string))
