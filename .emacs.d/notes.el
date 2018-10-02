;;
;; notes.el
;; Login : <teddy@stormbringer>
;; Started on  Tue Sep  8 19:46:31 2009 Teddy Smith
;; $Id$
;; 
;; Copyright (C) @YEAR@ Teddy Smith
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3 of the License, or
;; (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
;;



(defun open-class-notes (classcode)
  "Open the notes for a class in ~/Documents/school/<classcode>/"
  (interactive)
  (open-date-file-in-dir (concat "~/Documents/school/" classcode "/") ".txt")
  (if (eq (buffer-size) 0) (progn (today) (center-line) (insert "\n")) ())
  (end-of-buffer)
  (header)
  (insert "\n")
  (muse-mode)
  )

;; (defun open-hist-notes () "" 
;;   (interactive)
;;   (open-class-notes "hist275"))


;; (defun open-phil-notes () "" (interactive) (open-class-notes "phil140"))

(defun open-132-notes () "" (interactive) (open-class-notes "cmsc132"))