;; -------------------------------------------------------------------
;; Test Huchentoot & grep 
;;
(in-package :CL-USER)

(defpackage :TEST-HCT
  (:use :cl :cl-who :hunchentoot))

(in-package :TEST-HCT)

(defparameter *port* 4242)

(defparameter *version* "0.0 08-08-2026")

(defun create-and-start-server (&optional (port *port*))
  (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port port)))

;; directory does return some form of recursion

;; WORKS
(hunchentoot:define-easy-handler (listlisp :uri "/listlisp") (subdir)
  (setf (hunchentoot:content-type*) "text/plain")
  (with-output-to-string (out)
    (format out "# Lisp files under '~a'~%" subdir)
    ;; dirty for now
    (let ((lisp-files
           (directory (format nil "~a/**/*.lisp" subdir))
           ))
      (loop :for file :in lisp-files
            :do (format out "- ~a~%" file)
            :finally (force-output out) ))))

;; let's try it with HTML => works
;; 
(hunchentoot:define-easy-handler (listlisp :uri "/listlisphtm") (subdir)
  (setf (hunchentoot:content-type*) "text/html")
  (with-output-to-string (out)
    (with-html-output (out)
        (htm
         (:header "HEADER")
         (:body "BODY")))))


;; returns a string apparently
(hunchentoot:define-easy-handler (lspgrep :uri "/lspgrep") (pattern)
    (setf (hunchentoot:content-type*) "text/plain")
    ;(format nil "Results of searching for '~a'~%" pattern)
    (with-output-to-string (out)
      (format out "Results of searching for '~a'~%" pattern)))


;(create-and-start-server)
