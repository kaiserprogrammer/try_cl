(in-package :try-cl)

(def-suite try-cl)
(in-suite try-cl)

(test creating-user-session
  (let ((*db* (make-instance 'memory-db)))
    (is-false (active-session "blub"))
    (let* ((user-id (start-session))
           (user (db-get-user user-id *db*)))
      (is-true user)
      (is-true (active? user)))))

(test closing-session
  (let* ((*db* (make-instance 'memory-db))
         (user (db-get-user (start-session) *db*)))
    (close-session (id user))
    (is-false (active? user))
    (signals (error "The name")
      (sb-int:find-undeleted-package-or-lose (user-package user)))))

(test eval-in-session
  (let* ((*db* (make-instance 'memory-db))
         (id (start-session)))
    (is (= 1 (eval-in-session id "1")))
    (is (= 2 (eval-in-session id "(+ 1 1)")))
    (signals (error "can't read #.")
      (eval-in-session id "#.(get-universal-time)"))
    (eval-in-session id "(defvar *test-abc* 1)")
    (is (= 1 (eval-in-session id "*test-abc*")))
    (let ((new-id (start-session)))
      (eval-in-session new-id "(defvar *test-abc* 2)")
      (is (= 2 (eval-in-session new-id "*test-abc*")) "different users have same session"))))

(test no-eval-of-internal-symbols-in-other-packages
  (let* ((*db* (make-instance 'memory-db))
         (id (start-session)))
    (signals (error "No other internal symbols allowed.")
      (eval-in-session id "(cl:+ 1 1)"))
    (signals (error "No other internal symbols allowed.")
      (eval-in-session id "(cl::+ 1 1)"))
    (signals (error "No other internal symbols allowed.")
      (eval-in-session id "(eval (read-from-string (format nil \"(cl~a~a+ 1 1)\" (code-char 58) (code-char 58))))"))
    (signals (error "can't read #. while *read-eval* is nil")
      (eval-in-session id "(let ((*read-eval* t)) (read-from-string \"#.(get-universal-time)\"))"))))

(run!)
