;;; erc-list.el --- /list support for ERC  -*- lexical-binding:t -*-

;; Copyright (C) 2008-2023 Free Software Foundation, Inc.

;; Author: Tom Tromey <tromey@redhat.com>
;; Maintainer: Amin Bandali <bandali@gnu.org>, F. Jason Park <jp@neverwas.me>
;; Old-Version: 0.1
;; URL: https://www.emacswiki.org/emacs/ErcList
;; Keywords: comm

;; This file is NOT part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This file provides nice support for /list in ERC.

;;; Code:

(require 'erc)

(defgroup erc-list nil
  "Support for the /list command."
  :group 'erc)

;; This is implicitly the width of the channel name column.  Pick
;; something small enough that the topic has a chance of being
;; readable, but long enough that most channel names won't make for
;; strange formatting.
(defconst erc-list-nusers-column 25)

;; Width of the number-of-users column.
(defconst erc-list-topic-column (+ erc-list-nusers-column 10))

;; The list buffer.  This is buffer local in the server buffer.
(defvar erc-list-buffer nil)

;; The argument to the last "/list".  This is buffer local in the
;; server buffer.
(defvar erc-list-last-argument nil)

;; The server buffer corresponding to the list buffer.  This is buffer
;; local in the list buffer.
(defvar erc-list-server-buffer nil)

;; Define module:
;;;###autoload(autoload 'erc-list-mode "erc-list")
(define-erc-module list nil
  "List channels nicely in a separate buffer."
  ((remove-hook 'erc-server-321-functions #'erc-server-321-message)
   (remove-hook 'erc-server-322-functions #'erc-server-322-message))
  ((erc-with-all-buffers-of-server nil
     #'erc-open-server-buffer-p
     (remove-hook 'erc-server-322-functions #'erc-list-handle-322 t))
   (add-hook 'erc-server-321-functions #'erc-server-321-message t)
   (add-hook 'erc-server-322-functions #'erc-server-322-message t)))

;; Format a record for display.
(defun erc-list-make-string (channel users topic)
  (concat
   channel
   (propertize " "
	       'display (list 'space :align-to erc-list-nusers-column)
	       'face 'fixed-pitch)
   users
   (propertize " "
	       'display (list 'space :align-to erc-list-topic-column)
	       'face 'fixed-pitch)
   topic))

;; Insert a record into the list buffer.
(defun erc-list-insert-item (channel users topic)
  (save-excursion
    (let ((buffer-read-only nil))
      (goto-char (point-max))
      (insert (erc-list-make-string channel users topic) "\n"))))

(defun erc-list-join ()
  "Join the irc channel named on this line."
  (interactive)
  (unless (eobp)
    (beginning-of-line)
    (unless (looking-at "\\([&#+!][^ \n]+\\)")
      (error "Not looking at channel name?"))
    (let ((chan (match-string 1)))
      (with-current-buffer erc-list-server-buffer
	(erc-join-channel chan)))))

(defun erc-list-kill ()
  "Kill the current ERC list buffer."
  (interactive)
  (kill-buffer (current-buffer)))

(defun erc-list-revert ()
  "Refresh the list of channels."
  (interactive)
  (with-current-buffer erc-list-server-buffer
    (erc-cmd-LIST erc-list-last-argument)))

(defun erc-list-menu-sort-by-column (&optional e)
  "Sort the channel list by the column clicked on."
  (interactive (list last-input-event))
  (if e (mouse-select-window e))
  (let* ((pos (event-start e))
	 (obj (posn-object pos))
	 (col (if obj
		  (get-text-property (cdr obj) 'column-number (car obj))
		(get-text-property (posn-point pos) 'column-number))))
    (let ((buffer-read-only nil))
      (if (= col 1)
	  (sort-fields col (point-min) (point-max))
	(sort-numeric-fields col (point-min) (point-max))))))

(defvar erc-list-menu-mode-map
  (let ((map (make-keymap)))
    (set-keymap-parent map special-mode-map)
    (define-key map "k" #'erc-list-kill)
    (define-key map "j" #'erc-list-join)
    (define-key map "g" #'erc-list-revert)
    (define-key map "n" #'next-line)
    (define-key map "p" #'previous-line)
    map)
  "Local keymap for `erc-list-mode' buffers.")

(defvar erc-list-menu-sort-button-map
  (let ((map (make-sparse-keymap)))
    (define-key map [header-line mouse-1] #'erc-list-menu-sort-by-column)
    (define-key map [follow-link] 'mouse-face)
    map)
  "Local keymap for ERC list menu mode sorting buttons.")

;; Helper function that makes a buttonized column header.
(defun erc-list-button (title column)
  (propertize title
	      'column-number column
	      'help-echo "mouse-1: sort by column"
	      'mouse-face 'header-line-highlight
	      'keymap erc-list-menu-sort-button-map))

(define-derived-mode erc-list-menu-mode special-mode "ERC-List"
  "Major mode for editing a list of irc channels."
  (setq header-line-format
	(concat
	 (propertize " "
		     'display '(space :align-to 0)
		     'face 'fixed-pitch)
	 (erc-list-make-string (erc-list-button "Channel" 1)
			       (erc-list-button "# Users" 2)
			       "Topic")))
  (setq truncate-lines t))

(put 'erc-list-menu-mode 'mode-class 'special)

;; Handle a "322" response.  This response tells us about a single
;; channel.
;; Called via erc-once-with-server-event with two arguments.
(defun erc-list-handle-322 (_proc parsed)
  (let* ((args (cdr (erc-response.command-args parsed)))
	 (channel (car args))
	 (nusers (car (cdr args)))
	 (topic (erc-response.contents parsed)))
    (when (buffer-live-p erc-list-buffer)
      (with-current-buffer erc-list-buffer
	(erc-list-insert-item channel nusers topic))))
  ;; Don't let another hook run.
  t)

;; Helper function to install our 322 handler and make our buffer.
(defun erc-list-install-322-handler (server-buffer)
  (with-current-buffer server-buffer
    ;; Arrange for 322 responses to insert into our buffer.
    (add-hook 'erc-server-322-functions #'erc-list-handle-322 t t)
    ;; Arrange for 323 (end of list) to end this.
    (erc-once-with-server-event
     323
     (lambda (_proc _parsed)
	(remove-hook 'erc-server-322-functions #'erc-list-handle-322 t)))
    ;; Find the list buffer, empty it, and display it.
    (setq-local erc-list-buffer
                (get-buffer-create (concat "*Channels of "
                                           erc-server-announced-name
                                           "*")))
    (with-current-buffer erc-list-buffer
      (erc-list-menu-mode)
      (setq buffer-read-only nil)
      (erase-buffer)
      (setq-local erc-list-server-buffer server-buffer)
      (setq buffer-read-only t))
    (pop-to-buffer erc-list-buffer))
  t)

;; The main entry point.
(defun erc-cmd-LIST (&optional line)
  "Show a listing of channels on the current server in a separate window.

If LINE is specified, include it with the /LIST command.  It
should usually be one or more channels, separated by commas.

Please note that this function only works with IRC servers which conform
to RFC and send the LIST header (#321) at start of list transmission."
  (erc-with-server-buffer
   (setq-local erc-list-last-argument line)
   (erc-once-with-server-event
    321
    (let ((buf (current-buffer)))
      (lambda (_proc _parsed)
	(erc-list-install-322-handler buf)))))
  (erc-server-send (concat "LIST :" (or (and line (substring line 1))
					""))))
(put 'erc-cmd-LIST 'do-not-parse-args t)

(provide 'erc-list)

;;; erc-list.el ends here
;;
;; Local Variables:
;; generated-autoload-file: "erc-loaddefs.el"
;; End:
