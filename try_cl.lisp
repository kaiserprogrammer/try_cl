(defpackage :try-cl
  (:use :cl :anaphora :fiveam))

(in-package :try-cl)

(defvar *db*)

(defclass memory-db ()
  ((users :accessor users
          :initform (make-hash-table :test 'equal))
   (id :accessor id
       :initform 0)))

(defclass user ()
  ((id :reader id)
   (active :accessor active?
           :initform t)))

(defun next-id (db)
  (princ-to-string (incf (id db))))

(defgeneric db-add-user (user db &key))
(defmethod db-add-user ((user user) (db memory-db) &key)
  (setf (slot-value user 'id) (next-id db))
  (setf (gethash (id user) (users db)) user))

(defgeneric db-get-user (id db &key))
(defmethod db-get-user (id (db memory-db) &key)
  (gethash id (users db)))

(defun start-session (&optional (db *db*))
  (let ((user (make-instance 'user)))
    (db-add-user user db)
    (id user)))

(defun active-session (id &optional (db *db*))
  (awhen (db-get-user id db)
    (active? it)))

