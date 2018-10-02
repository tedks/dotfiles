;Since list people have asked for this a couple times, I thought the
;code below belongs in a more public place.  So here it is.  Free,
;GPL'd code for whoever.  Enjoy, ken fisler
;
; To specify the directory in which to put your journal entries, put
; the following into your ~/.emacs, specifying the directory: (load
; "journal") (if (file-directory-p "~/personal/diary/") (setq-default
; journal-dir "~/personal/diary/") )
;
; Because "format-time-string" isn't a builtin function until a later
; version of emacs, the below won't work with this version (19.22.1).
;
; Put this entire file into ".../site-lisp" or somewhere in emacs'
; path.

(defun journal (filename)
  "Open file named after today's date, format YYYY-MM-DD-Day,
in subdirectory named in variable journal-dir, set in ~/.emacs,
else in $HOME."
  (interactive
   (progn
     (setq filename journal-dir)
     (list filename)))

  (journal-open-date-file-in-dir filename ".muse.txt" 'muse-project-find-file "journal")
  (if (eq (buffer-size) 0) 
      (progn (insert "* ") (today) (progn (newline) (newline))) 
    ())
  (end-of-buffer)
  (progn (newline) (newline))
  (header))

(defun journal-open-date-file-in-dir
  (basedir ext &optional find-file-cmd &rest ffc-args)
  "Open a file, based on today's date, in the base directory with
a given extension."
  (let ((filename 
	 (concat basedir 
		 (format-time-string "%Y/%m/%0d" (journal-timestring))
		 ext))
	(find-file-cmd (if (not find-file-cmd)  'find-file find-file-cmd)))
    (make-directory (file-name-directory filename) 't)
    (funcall find-file-cmd filename ffc-args)))

(defun journal-timenumber (fmt)
  "Return a number representing the timestring format."
  (string-to-number (format-time-string fmt)))

(defun journal-timestring ()
  "Return today's date respecting hamster midnight."
  (if (< (journal-timenumber "%H") 6)
      (seconds-to-time (- (float-time) (* 24 (* 60 60))))
    (seconds-to-time (float-time))
  ))

(defun header ()
  "Insert header string: Today, Month DD, YYYY: time"
  (interactive)
  (insert (concat "** " (format-time-string "%-H:%M" (journal-timestring)) "\n\n")))

(defun today ()
  "Insert string for today's date nicely formatted in American style,
e.g. Sunday, September 17, 2000."
  (interactive)                 ; permit invocation in minibuffer
  (insert (format-time-string "%B %e, %Y" (journal-timestring))))

(setq-default journal-dir "~/Documents/.journal/")
(global-set-key "\C-c\C-j" 'journal)
(provide 'journal)
