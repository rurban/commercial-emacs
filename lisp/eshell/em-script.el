;;; em-script.el --- Eshell script files  -*- lexical-binding:t -*-

;; Copyright (C) 1999-2023 Free Software Foundation, Inc.

;; Author: John Wiegley <johnw@gnu.org>

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

;;; Code:

(require 'esh-mode)

;;;###autoload
(progn
(defgroup eshell-script nil
  "This module allows for the execution of files containing Eshell
commands, as a script file."
  :tag "Running script files."
  :group 'eshell-module))

;;; User Variables:

(defcustom eshell-script-load-hook nil
  "A list of functions to call when loading `eshell-script'."
  :version "24.1"                       ; removed eshell-script-initialize
  :type 'hook
  :group 'eshell-script)

(defcustom eshell-login-script (expand-file-name "login" eshell-directory-name)
  "If non-nil, a file to invoke when starting up Eshell interactively.
This file should be a file containing Eshell commands, where comment
lines begin with `#'."
  :type 'file
  :group 'eshell-script)

(defcustom eshell-rc-script (expand-file-name "profile" eshell-directory-name)
  "If non-nil, a file to invoke whenever Eshell is started.
This includes when running `eshell-command'."
  :type 'file
  :group 'eshell-script)

;;; Functions:

(defun eshell-script-initialize ()  ;Called from `eshell-mode' via intern-soft!
  "Initialize the script parsing code."
  (setq-local eshell-interpreter-alist
              (cons (cons (lambda (file _args)
                            (and (file-regular-p file)
                                 (string= (file-name-nondirectory file)
                                          "eshell")))
                          'eshell/source)
                    eshell-interpreter-alist))
  (setq-local eshell-complex-commands
	(append '("source" ".") eshell-complex-commands))
  ;; these two variables are changed through usage, but we don't want
  ;; to ruin it for other modules
  (let (eshell-inside-quote-regexp
	eshell-outside-quote-regexp)
    (and (not (bound-and-true-p eshell-non-interactive-p))
	 eshell-login-script
	 (file-readable-p eshell-login-script)
	 (eshell-do-eval
	  (list 'eshell-commands
		(catch 'eshell-replace-command
		  (eshell-source-file eshell-login-script)))
          t))
    (and eshell-rc-script
	 (file-readable-p eshell-rc-script)
	 (eshell-do-eval
	  (list 'eshell-commands
		(catch 'eshell-replace-command
		  (eshell-source-file eshell-rc-script))) t))))

(defun eshell-source-file (file &optional args subcommand-p)
  "Execute a series of Eshell commands in FILE, passing ARGS.
Comments begin with `#'."
  (let ((orig (point))
	(here (point-max)))
    (goto-char (point-max))
    (with-silent-modifications
      ;; FIXME: Why not use a temporary buffer and avoid this
      ;; "insert&delete" business?  --Stef
      (insert-file-contents file)
      (goto-char (point-max))
      (throw 'eshell-replace-command
             (prog1
                 (list 'let
                       (list (list 'eshell-command-name (list 'quote file))
                             (list 'eshell-command-arguments
                                   (list 'quote args)))
                       (let ((cmd (eshell-parse-command (cons here (point)))))
                         (if subcommand-p
                             (setq cmd (list 'eshell-as-subcommand cmd)))
                         cmd))
               (delete-region here (point))
               (goto-char orig))))))

(defun eshell/source (&rest args)
  "Source a file in a subshell environment."
  (eshell-source-file (car args) (cdr args) t))

(put 'eshell/source 'eshell-no-numeric-conversions t)

(defun eshell/. (&rest args)
  "Source a file in the current environment."
  (eshell-source-file (car args) (cdr args)))

(put 'eshell/. 'eshell-no-numeric-conversions t)

(provide 'em-script)

;; Local Variables:
;; generated-autoload-file: "esh-groups.el"
;; End:

;;; em-script.el ends here
