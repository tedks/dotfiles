;;
;; rhythmbox.el
;; 
;; Copyright © 2011 Edward Smith
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(defun rhythmbox-next () 
  (interactive)
  (shell-command "rhythmbox-client --next"))

(defun rhythmbox-prev () 
  (interactive)
  (shell-command "rhythmbox-client --previous"))

(defun rhythmbox-play-pause () 
  (interactive)
  (shell-command "rhythmbox-client --play-pause"))

(defun rhythmbox-vol-up () 
  (interactive)
  (shell-command "rhythmbox-client --volume-up"))

(defun rhythmbox-vol-down () 
  (interactive)
  (shell-command "rhythmbox-client --volume-down"))

(defun rhythmbox-notify ()
  (interactive)
  (shell-command "rhythmbox-client --notify && echo Notification sent!"))

(defun rhythmbox-show-playing ()
  (interactive)
  (shell-command "rhythmbox-client --print-playing-format=\"%tt by %ta from %at\""))

(defun rhythmbox-insert-playing ()
  (interactive)
  (insert (shell-command-to-string 
	   "rhythmbox-client --print-playing-format=\"%tt by %ta from %at\"")))

(provide 'rhythmbox)
