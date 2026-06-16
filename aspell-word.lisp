;; ------------------------------------------------------------------------------
;; quick warm up hack (again)
;; inspired by LW 'Spell Word' in examples ...
;; 
;; Author: 	Stéphane Perrot
;; Date:	June 2026
;; 
;; TODO:
;; - better error handling
;; - build a "Aspell Sentence" command
;; - Use Editor capability to highlight wrong word(s)
;;
;; ------------------------------------------------------------------------------
(in-package "CL-USER")

;; ------------------------------------------------------------------------------
(editor:defcommand "Aspell Word" (p)
     "Call Unix Aspell command on the current word, and display a message."
     "Call Unix Aspell command."
  (aspell-word  p))

(defvar *spell-command* "aspell -a" ;; "spell"
  "The name of the unix command used by \"Aspell Word\"")

;; ------------------------------------------------------------------------------
;; Sample aspell -a output 
;; & as first line char denotes incorrect word
;; * as first line char denotes correct word
;; @ denotes an info line
;; 
;;; @(#) International Ispell Version 3.1.20 (but really Aspell 0.60.8)
;;; & hellllllo 34 0: hello, hell, he'll, Heller, halloo, hellos, hallow, hollow, hellion, Hall, Hill, Hull, hall, heal, heel, hill, hull, Holly, hilly, holly, Hillel, hell's, Halley, Hallie, Holley, Hollie, healer, holler, huller, Hellene, hellish, hello's, helluva, Heller's


(defun aspell-word (p)
  (lw:when-let (word
             (editor:with-current-point-locked
                 (cp :for-modification nil :errorp nil)
               
               (editor:backward-word-command p)
               (let* ((end-point (editor:copy-point cp)))
                 (editor:forward-word-command p)
                 (editor:points-to-string end-point cp))))

    (editor:message "Spelling word ~S ..." word)

    (multiple-value-bind (rc cmd-output)
        (sys:call-system-showing-output
         (format nil "echo ~a | ~A ~%" word *spell-command*)
         :show-cmd nil
         :output-stream nil)
      (cond
       ((not (zerop rc))	(editor:message "Call to ~S failed!" *spell-command*))


       (t ;; we assume 1 word for now
        (let* ((lines  		(split-sequence (list #\Newline) cmd-output))
               (word-info-line 	(nth 1 lines))
               (first-char	(char word-info-line 0)))
          (cond
           ((char= first-char #\*)
            (editor:message "Word ~S spelled correctly!" word))

           ((char= first-char #\&)
            (let ((info-items 
                   (remove-if-not (lambda (x) (not (string-equal "" x))) 
                                  (split-sequence (list #\Space #\,) word-info-line))))
              (editor:message "Word ~S spelled INcorrectly (~a possible corrections: ~{~a~^, ~})!" word (nth 2 info-items) (subseq info-items 4)))))))))))


;; hello


