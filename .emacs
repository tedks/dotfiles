(add-to-list 'load-path "~/.elisp")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#4d4d4c" "#c82829" "#718c00" "#eab700" "#4271ae" "#8959a8" "#3e999f" "#ffffff"))
 '(beacon-color "#f2777a")
 '(blink-cursor-mode t)
 '(column-number-mode t)
 '(custom-enabled-themes (quote (sanityinc-solarized-light)))
 '(custom-safe-themes
   (quote
    ("06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "4d66773cc6d32566eaf2c9c7ce11269d9eb26e428a1a4fa10e97bae46ff615da" "79362f5a1dfa44cc2625aa4e171f9b203d29e4800ae072b3070599c3f81a8f6e" "d05303816026cec734e26b59e72bb9e46480205e15a8a011c62536a537c29a1a" "5e2ade7f65d9162ca2ba806908049fb37d602d59d90dc3a08463e1a042f177ae" default)))
 '(delete-by-moving-to-trash t)
 '(epa-file-cache-passphrase-for-symmetric-encryption t)
 '(fci-rule-color "#efefef")
 '(flycheck-color-mode-line-face-to-color (quote mode-line-buffer-id))
 '(global-font-lock-mode t nil (font-lock))
 '(global-pair-mode t)
 '(ido-ignore-files
   (quote
    ("\\`CVS/" "\\`#" "\\`.#" "\\`\\.\\./" "\\`\\./" "\\.pyc$" "\\.d$" "~$")))
 '(ido-show-dot-for-dired t)
 '(muse-book-latex-header
   "\\documentclass[12pt]{book}

\\usepackage[english]{babel}
\\usepackage{amsmath}
\\usepackage[utf8x]{inputenc}
\\usepackage[latin1]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage{url}
\\usepackage{graphicx}
\\usepackage{fullpage}

\\begin{document}

\\title{<lisp>(muse-publishing-directive \"title\")</lisp>}
\\author{<lisp>(muse-publishing-directive \"author\")</lisp>}
\\date{<lisp>(muse-publishing-directive \"date\")</lisp>}

\\maketitle")
 '(muse-file-extension "muse.txt")
 '(muse-latex-header
   "\\documentclass{article}

\\usepackage[english]{babel}
\\usepackage{ucs}
\\usepackage[utf8x]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage{hyperref}
\\usepackage[pdftex]{graphicx}
\\usepackage{url}
\\usepackage{setspace}
\\usepackage{natbib}

\\def\\museincludegraphics{%
  \\begingroup
  \\catcode`\\|=0
  \\catcode`\\\\=12
  \\catcode`\\#=12
  \\includegraphics[width=0.75\\textwidth]
}

\\begin{document}

\\title{<lisp>(muse-publish-escape-specials-in-string
  (muse-publishing-directive \"title\") 'document)</lisp>}
\\author{<lisp>(muse-publishing-directive \"author\")</lisp>}
\\date{<lisp>(muse-publishing-directive \"date\")</lisp>}

\\maketitle

<lisp>(and muse-publish-generate-contents
           (not muse-latex-permit-contents-tag)
           \"\\\\tableofcontents
\\\\newpage\")</lisp>

")
 '(muse-latex-markup-strings
   (quote
    ((image-with-desc . "\\begin{figure}[h]
\\centering\\museincludegraphics{%s.%s}|endgroup
\\caption{%s}
\\end{figure}")
     (image . "\\begin{figure}[h]
\\centering\\museincludegraphics{%s.%s}|endgroup
\\end{figure}")
     (image-link . "%% %s
\\museincludegraphics{%s.%s}|endgroup")
     (anchor-ref . "\\ref{%s}")
     (url . "\\url{%s}")
     (url-and-desc . "\\href{%s}{%s}\\footnote{%1%}")
     (link . "\\href{%s}{%s}\\footnote{%1%}")
     (link-and-anchor . "\\href{%1%}{%3%}\\footnote{%1%}")
     (email-addr . "\\verb|%s|")
     (anchor . "\\label{%s}")
     (emdash . "---")
     (comment-begin . "% ")
     (rule . "\\vspace{.5cm}\\hrule\\vspace{.5cm}")
     (no-break-space . "~")
     (line-break . "\\\\")
     (enddots . "\\ldots{}")
     (dots . "\\dots{}")
     (part . "\\part{")
     (part-end . "}")
     (chapter . "\\chapter*{")
     (chapter-end . "}")
     (section . "\\section{")
     (section-end . "}")
     (subsection . "\\subsection{")
     (subsection-end . "}")
     (subsubsection . "\\subsubsection{")
     (subsubsection-end . "}")
     (section-other . "\\paragraph{")
     (section-other-end . "}")
     (footnote . "\\footnote{")
     (footnote-end . "}")
     (footnotetext . "\\footnotetext[%d]{")
     (begin-underline . "\\underline{")
     (end-underline . "}")
     (begin-literal . "\\texttt{")
     (end-literal . "}")
     (begin-emph . "\\emph{")
     (end-emph . "}")
     (begin-more-emph . "\\textbf{")
     (end-more-emph . "}")
     (begin-most-emph . "\\textbf{\\emph{")
     (end-most-emph . "}}")
     (begin-verse . "\\begin{verse}
")
     (end-verse-line . " \\\\")
     (verse-space . "~~~~")
     (end-verse . "
\\end{verse}")
     (begin-example . "\\begin{quote}
\\begin{verbatim}")
     (end-example . "\\end{verbatim}
\\end{quote}")
     (begin-center . "\\begin{center}
")
     (end-center . "
\\end{center}")
     (begin-quote . "\\begin{quote}
")
     (end-quote . "
\\end{quote}")
     (begin-cite . "\\cite{")
     (begin-cite-author . "\\citet{")
     (begin-cite-year . "\\citet{")
     (end-cite . "}")
     (begin-uli . "\\begin{itemize}
")
     (end-uli . "
\\end{itemize}")
     (begin-uli-item . "\\item ")
     (begin-oli . "\\begin{enumerate}
")
     (end-oli . "
\\end{enumerate}")
     (begin-oli-item . "\\item ")
     (begin-dl . "\\begin{description}
")
     (end-dl . "
\\end{description}")
     (begin-ddt . "\\item[")
     (end-ddt . "] \\mbox{}
"))))
 '(muse-mode-auto-p t)
 '(muse-mode-hook (quote (flyspell-mode muse-mode-bindings)))
 '(muse-project-alist
   (quote
    (("State and Terrorist Conspiracies"
      ("/home/tedks/Documents/polit/rtc/distro/state_and_terrorist_conspiracies/")
      (:base "book-pdf" :path "/home/tedks/Documents/polit/rtc/distro/state_and_terrorist_conspiracies/"))
     ("The dotCommunist Manifesto"
      ("/home/tedks/Documents/polit/rtc/distro/dotCommunism")
      (:base "book-pdf" :path "/home/tedks/Documents/polit/rtc/distro/")))))
 '(package-archives (quote (("gnu" . "https://elpa.gnu.org/packages/"))))
 '(package-check-signature (quote allow-unsigned))
 '(package-selected-packages
   (quote
    (gnu-elpa-keyring-update ace-window fountain-mode bazel-mode merlin tuareg utop rainbow-delimiters rainbow-identifiers zeitgeist weblogger smex scala-mode2 python pkg-info org-mac-link-grabber org-mac-link org-blog org-agenda-property opam muse magit-tramp magit-gerrit magit-find-file howdoi go-scratch go-rename go-dlv go-autocomplete flymake-ruby flymake-python-pyflakes flymake-perlcritic flymake-json flymake-jslint flymake-haskell-multi flymake-go flymake-cursor flymake-coffee flx-ido f ess-R-data-view erlang emacs-eclim dockerfile-mode docker-api docker csv-mode csharp-mode color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized bison-mode autopair 2048-game)))
 '(pair-mode-chars (quote (40 91 123 171 96 34)))
 '(safe-local-variable-values
   (quote
    ((coq-prog-args "-emacs-U" "-I" "/home/tedks/Documents/School/cmpsci691pl/cpdt/src" "-I" "/home/tedks/Documents/School/cmpsci691pl/sf")
     (coq-prog-args "-emacs-U" "-I" "/home/tedks/Documents/School/cmpsci691pl/homework/sf")
     (coq-prog-args "-emacs-U" "-I" "/home/tedks/Documents/School/cmpsci691pl/cpdt/src"))))
 '(select-enable-clipboard t)
 '(sentence-end-double-space nil)
 '(show-paren-mode t)
 '(speedbar-frame-parameters
   (quote
    ((minibuffer)
     (width . 20)
     (border-width . 0)
     (menu-bar-lines . 0)
     (tool-bar-lines . 0)
     (unsplittable . t)
     (set-background-color "black"))))
 '(todoo-initials "TKS")
 '(tool-bar-mode nil)
 '(tuareg-font-lock-symbols nil)
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify))
 '(vc-diff-switches "-u"))

(require 'package)
(package-initialize)

;; opam
(opam-init)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "adobe" :slant normal :weight normal :height 80 :width normal)))))

(add-to-list 'custom-theme-load-path "~/.elisp/")
;; (load-theme 'tomorrow-night-eighties)


(tool-bar-mode 0)			;turn the toolbar off
(blink-cursor-mode t)			;blink the cursor

;; use a visual switch-window
;; (require 'switch-window) fuck that actually

;; mostly used for journal.el stuff
(defun open-date-file-in-dir (basedir ext &optional find-file-cmd &rest ffc-args)
  "Open a file, based on today's date, in the base directory with
a given extension."
  (let ((filename (concat basedir (format-time-string "%Y-%m-%d-%a" nil) ext))
	(find-file-cmd (if (not find-file-cmd)  'find-file find-file-cmd)))
	(funcall find-file-cmd filename ffc-args)))

;; notes framework
;; (defun open-class-notes (classcode)
;;   "Open the notes for a class in ~/Documents/school/<classcode>/"
;;   (interactive)
;;   (open-date-file-in-dir (concat "~/Documents/school/" classcode "/") ".txt")
;;   (if (eq (buffer-size) 0) (progn (today) (center-line) (insert "\n")) ())
;;   (end-of-buffer)
;;   (header)
;;   (insert "\n")
;;   (muse-mode)
;;   )

;; (defun open-hist-notes () "" (interactive) (open-class-notes "hist275"))
;; (defun open-phil-notes () "" (interactive) (open-class-notes "phil140"))

(defun muse-mode-bindings () 
  "Set up bindings for muse-mode"
  (local-set-key [(tab)] 'dabbrev-expand)
)

(add-hook 'muse-mode-hook 'muse-mode-bindings)

;;c-function-signature
(require 'c-function-signature)

(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
;; (global-set-key "\C-c\C-k" 'kill-region)
(global-set-key "\C-x\C-m" 'smex)
(global-set-key "\C-c\C-m" 'smex)

;; (require 'install-elisp)
;; (setq install-elisp-repository-directory "~/.elisp/")

;; server stuff
;(setq server-name "teddy-server")
;(server-start)

;; let us use C-x C-u
(put 'upcase-region 'disabled nil)

(require 'xscheme) ;; scheme mode and interpreter
(require 'savannah);; savannah mode

;;autoclose pairs
(require 'pair-mode)
(add-hook 'c-mode-common-hook '(lambda () (setq skeleton-pair t)))

;; (add-hook 'c-mode-common-hook
;;           '(lambda ()
;;              (turn-on-auto-fill)
;;              (setq fill-column 80)
;;              (setq comment-column 60)
;;              (modify-syntax-entry ?_ "w")       ; now '_' is not considered a word-delimiter
;;              (c-set-style "ellemtel")           ; set indentation style
;;              (local-set-key [(control tab)] ; move to next tempo
;;                             mark 'tempo-forward-mark) ))

;; c-mode hungy-delete
(setq c-hungry-delete-key t)
;; kill an entire line if the cursor is at the beginning of the line
(setq kill-whole-line t)

;; Bring commonly-used programming symbols to the front.
(setq my-key-pairs
      '((?! ?1) (?@ ?2) (?# ?3) (?$ ?4) (?% ?5)
        (?^ ?6) (?& ?7) (?* ?8) (?( ?9) (?) ?0)
        (?- ?_) (?\" ?') (?{ ?[) (?} ?])         ; (?| ?\\)
        ))

(setq my-key-pairs-mode nil)

(defun my-key-swap (key-pairs)
  (if (eq key-pairs nil)
      (progn (setq my-key-pairs-mode t))
    (progn
      (keyboard-translate (caar key-pairs)  (cadar key-pairs)) 
      (keyboard-translate (cadar key-pairs) (caar key-pairs))
      (my-key-swap (cdr key-pairs))
      )
    ))

(defun my-key-restore (key-pairs)
  (if (eq key-pairs nil)
      (progn (setq my-key-pairs-mode nil))
    (progn
      (keyboard-translate (caar key-pairs)  (caar key-pairs))
      (keyboard-translate (cadar key-pairs) (cadar key-pairs))
      (my-key-restore (cdr key-pairs))
      )
    ))

;; now that we've brought commonly used keypairs to the front, it's
;; more difficult to make the -> symbol. Bind __ to ->.
(defun my-editing-function (first last len) 
  (interactive) 
  (if (and (boundp 'major-mode) 
	   (member major-mode (list 'c-mode 'c++-mode 'gud-mode 
				    'fundamental-mode 'ruby-mode 'tuareg-mode)) 
	   (= len 0) (> (point) 4) 
	   (= first (- (point) 1))) 
      (cond ((and (string-equal (buffer-substring (point) (- (point) 2)) "__") 
		  (not (string-equal (buffer-substring (point) 
						       (- (point) 3)) "___"))) 
	     (progn (delete-backward-char 2)
		    (insert-char ?- 1) (insert-char ?> 1)))

	    ((string-equal (buffer-substring (point) (- (point) 3)) "->_")
	     (progn (delete-backward-char 3) (insert-char ?_ 3)))
	    
	    ((and (string-equal (buffer-substring (point) (- (point) 2)) "..") 
		  (not (string-equal 
			(buffer-substring (point) (- (point) 3)) "..."))) 
	     (progn (delete-backward-char 2)
		    (insert-char ?[ 1) (insert-char ?] 1) (backward-char 1)))

	    ((and (> (point-max) (point)) 
		  (string-equal (buffer-substring 
				 (+ (point) 1) (- (point) 2)) "[.]")) 
	     (progn (forward-char 1) 
		    (delete-backward-char 3) 
		    (insert-char ?. 1) 
		    (insert-char ?. 1))))
    nil))

(add-hook 'after-change-functions 'my-editing-function)

(global-set-key [f9] '(lambda () (interactive) 
			 (if (eq my-key-pairs-mode nil) 
			     (my-key-swap my-key-pairs) 
			 (my-key-restore my-key-pairs))))
(add-hook 'minibuffer-setup-hook '(lambda () (interactive)
				    (if (eq my-key-pairs-mode nil) ()
				      (progn 
					(my-key-restore my-key-pairs)
					(setq my-key-pairs-mode -1)))))
(add-hook 'minibuffer-exit-hook '(lambda () (interactive)
				   (if (eq my-key-pairs-mode -1)
				       (my-key-swap my-key-pairs))))

;; other cc-mode keyboard hooks:
(add-hook 'c-mode-common-hook
	  (lambda () (progn
		       (define-key c-mode-base-map "\C-c\C-g" 'insert-gpl-header)
		       (define-key c-mode-base-map "\C-cm" 'man-follow)
		       )
		       ;; insert more as needed...
		       ))

;; load modules installed by portage with no errors on non-gentoo machines
(require 'site-gentoo nil t)

;; identica-mode
;; (require 'identica-mode)
;; (setq identica-username "tedks")
;; (global-set-key "\C-ci" 'identica-update-status-interactive)

(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'text-mode-hook 'epa-mail-mode)
;;(add-hook 'text-mode-hook 'longlines-mode)

;; write time
(defun insert-time ()
  (interactive)
  (insert (format-time-string "%Y-%m-%d-%R")))


;; journal.el
(require 'journal)
;; muse-journal
(require 'muse-mode)

(require 'muse-latex)
(require 'muse-docbook)
(require 'muse-journal)
(require 'muse-html)
(require 'muse-texinfo)
(require 'muse-xml)

(require 'muse-project)

(setq muse-project-alist 
      '(
	("Journal" 
	 ("~/Documents/.journal/")
	 (:base "book-pdf" 
		:path "~/Documents/.journal_output/"
		))

	("The Right to Read" 
	 (:nochapters t
	  :book-chapter "The Free Software Definition"
	  "~/Documents/polit/rtc/distro/the_right_to_read/definition"
	  :book-chapter "The Right to Read"
	  "~/Documents/polit/rtc/distro/the_right_to_read/right_to_read"
	  :book-chapter "Why Software Should Not Have Owners"
	  "~/Documents/polit/rtc/distro/the_right_to_read/no_owners"
	  :book-chapter "Your Freedom Needs Free Software"
	  "~/Documents/polit/rtc/distro/the_right_to_read/your_freedom"
	  :book-chapter "Why Open Source Misses The Point"
	  "~/Documents/polit/rtc/distro/the_right_to_read/open_source"
	  :book-chapter "Who does that server really serve?"
	  "~/Documents/polit/rtc/distro/the_right_to_read/who_really"
	  :book-end t
	  "~/Documents/polit/rtc/distro/the_right_to_read/"
	)
	(:base "book-pdf" 
		:include "/the_right_to_read.[^/]*$"
		:path "~/Documents/polit/rtc/distro/the_right_to_read"
		))

	("The dotCommunist Manifesto" 
	 ("~/Documents/polit/repos/rtc-trunk/distro/dotCommunism") 
	 (:base "book-pdf" :nochapters t :path "~/Documents/polit/rtc/distro/dotCommunism"))
	
	("State and Terrrorist Conspiracies" 
	 ("~/Documents/polit/rtc/distro/state_and_terrorist_conspiracies")
	 (:base "book-pdf" 
		:path "~/Documents/polit/rtc/distro/state_and_terrorist_conspiracies"))
	("A Sharable Future draft" 
	 ("~/Documents/polit/repos/rtc-trunk/misc/a_sharable_future/") 
	 (:base "book-pdf" :nochapters t :path "~/Documents/polit/rtc/misc/a_sharable_future" :exclude "/outline*/"))
	
	))
;; end muse stuff

(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)


;(defun local-perl-mode () (if file-exists-p insert "#!/usr/bin/perl\n\nuse strict;\nuse warnings;\n\n"))
;(add-hook 'perl-mode-hook 'local-perl-mode)
(add-hook 'perl-mode-hook (lambda () (define-key perl-mode-map "\C-c\C-c" 'comment-region)))

;function to implement a smarter TAB
(global-set-key [(tab)] 'smart-tab)
(defun smart-tab ()
  "This smart tab is minibuffer compliant: it acts as usual in
the minibuffer. Else, if mark is active, indents region. Else if
point is at the end of a symbol, expands it. Else indents the
current line."
  (interactive)
  (if (minibufferp)
      (unless (minibuffer-complete)
	(dabbrev-expand nil))
    (if mark-active
	(indent-region (region-beginning)
		       (region-end))
      (if (looking-at "\\_>")
	  (dabbrev-expand nil)
	(indent-for-tab-command)))))

;; load licenses from the file
(require 'licenses)

;; let's show the battery
(display-battery-mode)

(defun get-user-full-name ()
  "Returns the users full name."
  "Ted Smith"
)

; retitle emacs window
 (defun frame-retitle (title)
   (modify-frame-parameters 
     nil 
     (list
       (cons
          'name
          title))))

(setq frame-title-format '("" "%b - GNU Emacs"))


;; moinmoin-mode
(require 'moinmoin-mode)

;; blogging
(require 'weblogger)

(defun weblogger-change-server-lambda (newurl)
  "non-interactively changed the server-url"
  (setq weblogger-server-url newurl)
  (weblogger-determine-capabilities))

(defun toggle-blog ()
  "Change from the wordpress blog to the baywords blog."
  (interactive)
  (let ((baywords-blog "http://gnuradical.baywords.com/xmlrpc.php")
	(wordpress-blog "http://gnuradical.wordpress.com/xmlrpc.php"))
    (if (equal weblogger-server-url baywords-blog)
	(weblogger-change-server-lambda wordpress-blog)
      (weblogger-change-server-lambda baywords-blog))))

(global-set-key "\C-cbt" 'toggle-blog)
(global-set-key "\C-cbs" 'weblogger-start-entry)


;; ido-mode
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t) ;; enable fuzzy matching
(global-set-key (kbd "C-x C-b") 'ibuffer) ;; ibuffer!

(require 'flx-ido)
(ido-mode t)
(ido-everywhere t)
(flx-ido-mode t)
(setq ido-use-faces nil)

;; (ido-better-flex/enable)

;; smex
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; ditz
(require 'ditz-mode)
(define-key global-map "\C-c\C-d" ditz-prefix)

;; mediawiki
(require 'mediawiki)
;; (mediawiki-do-login "Gnuradical")

;; google-maps
;; (require 'google-maps) ;; my god... it's full of EMACS!

;; unique buffer names
(require 'uniquify)

;; point-stack
(require 'point-stack)
(global-set-key '[(f5)] 'point-stack-push)
(global-set-key '[(f6)] 'point-stack-pop)
(global-set-key '[(f7)] 'point-stack-forward-stack-pop)


(put 'downcase-region 'disabled nil)

(add-hook 'latex-mode-hook (lambda () (setq sentence-end-double-space nil)))
(add-hook 'text-mode-hook (lambda () (setq sentence-end-double-space nil)))
(add-hook 'text-mode-hook (lambda () (abbrev-mode t)))
(add-hook 'text-mode-hook 'visual-line-mode)

;; make prompts less annoying
(fset 'yes-or-no-p 'y-or-n-p)		; y/n instead of yes/no
(setq confirm-nonexistent-file-or-buffer nil) ;no [confirm] in find-file
(setq ido-create-new-buffer 'always)	      ;make throwaway buffers easy

;; make scripts executable
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;; abbrevs for unicode chars

(define-abbrev-table 'global-abbrev-table '(
    ("abalpha" "α" nil 0)
    ("abbeta" "β" nil 0)
    ("abgamma" "γ" nil 0)
    ("abtheta" "θ" nil 0)
    ("abupsigma" "Σ" nil 0)
    ("abepsilon" "ε" nil 0)
    ("abinf" "∞" nil 0)
    ("abomega" "Ω" nil 0)

    ("arlt" "←" nil 0)
    ("arrt" "→" nil 0)
    ("arrd" "↔" nil 0)
    
    ;; ("logand" "∧" nil 0)
    ;; ("logor" "∨" nil 0)
    ;; ("lognot" "¬" nil 0)
    ;; ("logxor" "⊕" nil 0)
    ;; ("logequiv" "≡" nil 0)

    ("circlea" "Ⓐ" nil 0)
    ("hammsick" "☭" nil 0)

    ("abthereis" "∃" nil 0)
    ("abforall" "∀" nil 0)
    ("abelem" "∈" nil 0)
    ("ablessthan" "≤" nil 0)
    ("abturnstyle" "⊢" nil 0)
    ))
(setq flyspell-issue-welcome-flag nil) ;; fix for Ubuntu 10.10 problem

;; rhythmbox bindings
(require 'rhythmbox)

;; (load-library "zeitgeist.el")
(require 'zeitgeist)

;;----pydoc lookup----
(defun hohe2-lookup-pydoc ()
  (interactive)
  (let ((curpoint (point)) (prepoint) (postpoint) (cmd))
    (save-excursion
      (beginning-of-line)
      (setq prepoint (buffer-substring (point) curpoint)))
    (save-excursion
      (end-of-line)
      (setq postpoint (buffer-substring (point) curpoint)))
    (if (string-match "[_a-z][_\\.0-9a-z]*$" prepoint)
        (setq cmd (substring prepoint (match-beginning 0) (match-end 0))))
    (if (string-match "^[_0-9a-z]*" postpoint)
        (setq cmd (concat cmd (substring postpoint (match-beginning 0) (match-end 0)))))
    (if (string= cmd "") nil
      (let ((max-mini-window-height 0))
        (shell-command (concat "pydoc " cmd))))))

(add-hook 'python-mode-hook
          (lambda ()
            (local-set-key (kbd "C-h f") 'hohe2-lookup-pydoc)
	    ))


;; (setq TeX-auto-save t)
;; (setq TeX-parse-self t)
;; (setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
;; (setq reftex-plug-into-AUCTeX t)

(autoload 'vala-mode "vala-mode" "Major mode for editing Vala code." t)
(add-to-list 'auto-mode-alist '("\\.vala$" . vala-mode))
(add-to-list 'auto-mode-alist '("\\.vapi$" . vala-mode))
(add-to-list 'file-coding-system-alist '("\\.vala$" . utf-8))
(add-to-list 'file-coding-system-alist '("\\.vapi$" . utf-8))


(defun spaceify (deck taglist) 
  (interactive "sDeckname: \nsTags: ")
  (let ((file (shell-quote-argument (buffer-file-name)))
	(deck (shell-quote-argument deck))
	(tags (shell-quote-argument taglist)))
    (shell-command (concat "space " file " " deck " " tags) nil nil)))
(global-set-key "\C-c\C-s" 'spaceify)

(global-unset-key "\C-xm")		;fuck composing email

(defun insert-space-sep () (interactive) (insert "\n;;\n"))

(add-hook 'text-mode-hook (lambda () 
			    (local-set-key (kbd "C-c C-<return>")
					   'insert-space-sep)))

					   

(global-set-key (kbd "C-c r n") 'rhythmbox-next)
(global-set-key (kbd "C-c r p") 'rhythmbox-prev)
(global-set-key (kbd "C-c r SPC") 'rhythmbox-play-pause)

(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))

(defun mah/weblogger-setup ()
  (flyspell-mode 1)
  (flyspell-buffer)         ; spell check the fetched post
  (auto-fill-mode -1)       ; Turn off hard word-wrap
  (visual-line-mode 1))     ; Tell Emacs to do soft word-wapping

;; weblogger helpful things from Mark A Hershberger, living god
(defun mah/weblogger-publish-hook ()
  (when visual-line-mode    ; Turn soft word-wrapping off so the text
    (visual-line-mode -1))  ; we send doesn't have stray n/ls
  ;; tabs might spoil code indentation
  (untabify (point-min) (point-max)))

(defun mah/weblogger-publish-end-hook ()
  (visual-line-mode 1))

(add-hook 'weblogger-publish-entry-end-hook
          'mah/weblogger-publish-end-hook)
(add-hook 'weblogger-publish-entry-hook 'mah/weblogger-publish-hook)
(add-hook 'weblogger-start-edit-entry-hook 'mah/weblogger-setup)

(require 'tramp)
(add-to-list 'tramp-default-proxies-alist
             '(nil "\\`root\\'" "/ssh:%h:"))
(add-to-list 'tramp-default-proxies-alist
             '((regexp-quote (system-name)) nil nil))

(require 'hamster)

;; (setq inferior-lisp-program "/usr/bin/clisp")
;; (require 'slime)
;; (add-hook 'slime-mode-hook
;; 	  (lambda ()
;; 	    (unless (slime-connected-p)
;; 	      (save-excursion (slime)))))

(global-set-key "\C-x\C-r" 'revert-buffer)

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


;; (load-theme 'sanityinc-solarized-light) obsolete

;; (add-hook 'after-init-hook #'global-flycheck-mode)

;; python IDE

(require 'pymacs)
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)

(require 'flymake)
(add-hook 'find-file-hook 'flymake-find-file-hook)
(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
               'flymake-create-temp-inplace))
       (local-file (file-relative-name
            temp-file
            (file-name-directory buffer-file-name))))
      (list "pycheckers"  (list local-file))))
   (add-to-list 'flymake-allowed-file-name-masks
             '("\\.py\\'" flymake-pyflakes-init)))
(load-library "flymake-cursor")
(global-set-key [f10] 'flymake-goto-prev-error)
(global-set-key [f11] 'flymake-goto-next-error)


(defun open-gnuradical-wiki ()
  (interactive
  (mediawiki-site "Gnuradical")))
(global-set-key "\C-c\C-w" 'open-gnuradical-wiki)

(require 'howdoi)

(require 'erlang-start)

(defun unfill-paragraph ()
  "Replace newline chars in current paragraph by single spaces.
This command does the inverse of `fill-paragraph'."
  (interactive)
  (let ((fill-column 90002000)) ; 90002000 is just random. you can use `most-positive-fixnum'
    (fill-paragraph nil)))

(defun unfill-region (start end)
  "Replace newline chars in region by single spaces.
This command does the inverse of `fill-region'."
  (interactive "r")
  (let ((fill-column 90002000))
    (fill-region start end)))

(global-set-key "\C-c\M-q" 'unfill-paragraph)

(setq concentrate-mode-map
      (let ((map (make-sparse-keymap)))
	(define-key map [remap delete-backward-char] "")
	(define-key map [remap backward-kill-word] "")
	map))
(define-minor-mode concentrate-mode "")


(defun flymake-get-tex-args (file-name)
  (list "pdflatex" (list "-file-line-error" "-draftmode" "-interaction=nonstopmode" file-name)))

;; emacs speaks statistics
(require 'ess-site)

;; rainbow delimeters
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; magit
(global-set-key "\C-c\C-g" 'magit-status)

;; utop
(add-to-list
 'load-path
 (replace-regexp-in-string
  "\n" "/share/emacs/site-lisp"
  (shell-command-to-string "opam config var prefix")))

;; Automatically load utop.el
(autoload 'utop "utop" "Toplevel for OCaml" t)

;; Use the opam installed utop
(setq utop-command "opam config exec -- utop -emacs")

;; Tuareg integration
(autoload 'utop-minor-mode "utop" "Minor mode for utop" t)
(add-hook 'tuareg-mode-hook 'utop-minor-mode)

;; ace-window
(global-set-key (kbd "M-o") 'ace-window)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
