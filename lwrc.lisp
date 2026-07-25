;; -------------------------------------------------------------------------------
;; minimal init file for Lispworks Personal (not loaded automatically)
(in-package		:cl-user)

(setq *print-case*	:downcase)

;; Let's do it the official way 
(defvar *quicklisp-home*
  (merge-pathnames (make-pathname :directory '(:relative "quicklisp"))
                   (user-homedir-pathname)))

(defvar *setup-pathname*
  (merge-pathnames (make-pathname :name "setup" :type "lisp")
                   *quicklisp-home*))

(when (probe-file *setup-pathname*)
  (load "/home/sperrot/quicklisp/setup"))

;; yes is's the way to do it !!!
(setf (editor:variable-value `editor:backups-wanted) nil)

(ql:quickload "cl-who")
(ql:quickload "split-sequence")

;; local
(ql:quickload "40ants-doc")
(ql:quickload "lw-add-ons")

;; another example (that from lw-add-ons") is to be find under 
;; /usr/local/lib64/LispWorksPersonal/lib/8-1-0-0/examples/editor/commands/space-show-arglist.lisp

;; BY defautl in LWP 8.1 Tab calls 'Indent Selection or Complete Symbol' ISoCS for short
;; the function advertised by LWAO is 'Indent And Complete Symbolw' IACS for short

;; pathname completion works, let's try it for a while 
(editor:bind-key "Indent And Complete Symbol" #\Tab :mode "Lisp")

;; WORKS
(editor:bind-key "Insert Space and Show Arglist" #\Space :mode "Lisp")

;; WORKS 
(editor:bind-key "Scroll Window Down" "Ctrl-Down" :mode "Lisp")
(editor:bind-key "Scroll Window Up"   "Ctrl-Up"   :mode "Lisp")

;; -------------------------------------------------------------------------------
;; WORKS,
;; a point is smthing like 
;; #<editor::i-point "lwrc.lisp" 0 offset 808 51115816158>
(editor:defcommand "Insert Tab" (p)
  (declare (ignore p))
  (editor:insert-character (editor:current-point) #\Tab))

(editor:bind-key "Insert Tab" "Meta-j")

;; -------------------------------------------------------------------------------
;; Copy example from Split Line ... 

(editor:bind-key "Mark Form" "Ctrl-Meta-Space")

;; -------------------------------------------------------------------------------
;; FIXME: more generic
;; WORKS
(editor:defcommand "Insert Separation Line" (p)
  (declare (ignore p))
  (editor:with-current-point-locked (cur-point)
    (let* ((insert-string (string-append ";; " (make-string 78 :initial-element #\-))))
      (editor:insert-string cur-point insert-string))))

(editor:bind-key "Insert Separation Line" "Control-Meta-o")

;; ------------------------------------------------------------------------------
(defun iota (n)
  (loop for i from 1 to n collect i))


;; ------------------------------------------------------------------------------
;; EXAMPLE FROM editor.lisp in lw-add-ons ...

