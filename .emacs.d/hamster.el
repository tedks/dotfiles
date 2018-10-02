;;
;; hamster.el
;; 
;; Copyright © 2012 Edward Smith
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

(defun hamster-term () 
  (interactive)
  (shell-command "hamster-cli stop"))

(defun hamster-start (activity)
  (interactive "sActivity: ")
  (let ((cmd (concat "hamster-cli start \'" activity "\'")))
    (shell-command cmd)))

(defun hamster-list ()
  (interactive)
  (shell-command "hamster-cli list"))

(defun hamster-categories ()
  (interactive)
  (shell-command "hamser-cli list-categories"))

(defun hamster-insert-list ()
  "Insert the results of hamster-cli list at point."
  (interactive)
  (insert (shell-command-to-string "hamster-cli list")))

(global-set-key (kbd "C-c h t") 'hamster-term)
(global-set-key (kbd "C-c h s") 'hamster-start)
(global-set-key (kbd "C-c h l") 'hamster-list)
(global-set-key (kbd "C-c h i") 'hamster-insert-list)
(provide 'hamster)
