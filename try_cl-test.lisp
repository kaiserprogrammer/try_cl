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

(run!)
