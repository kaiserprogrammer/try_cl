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
    (is-false (active? user))))

(run!)
