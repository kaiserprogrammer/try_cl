(defpackage :try-cl
  (:use :cl :anaphora :fiveam)
  (:export
   :safe-read
   :eval-in-session
   :close-session
   :active-session
   :start-session))

(in-package :try-cl)

(defvar *db*)
(defvar *default-timeout* 0)

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
    (let ((name (user-package user)))
      (SB-IMPL::%DEFPACKAGE name 'NIL 'NIL 'NIL 'NIL (list "SAFE-CL") 'NIL 'NIL 'NIL
                            `(,name) 'NIL 'NIL nil))
    (id user)))

(defun active-session (id &optional (db *db*))
  (awhen (db-get-user id db)
    (active? it)))

(defun close-session (user-id &optional (db *db*))
  (let ((user (db-get-user user-id db)))
    (setf (active? user) nil)
    (delete-package (user-package user))))

(defmethod user-package ((user user))
  (format nil "USER.~a" (id user)))

(defun eval-in-session (user-id expression &key (db *db*) (timeout *default-timeout*))
  (let ((*read-eval* nil))
    (let ((*package* (SB-INT:FIND-UNDELETED-PACKAGE-OR-LOSE
                      (user-package (db-get-user user-id db)))))
      (handler-case
          (sb-ext:with-timeout timeout
            (eval (safe-read expression)))
        (SB-EXT:TIMEOUT (e) e)))))

(defun safe-read (&rest args)
  (if (cl-ppcre:scan ":" (first args))
      (error "No other internal or external symbols allowed.")
      (apply #'read-from-string args)))
