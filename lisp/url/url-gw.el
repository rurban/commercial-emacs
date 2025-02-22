;;; url-gw.el --- Gateway munging for URL loading  -*- lexical-binding: t; -*-

;; Copyright (C) 1997-1998, 2004-2023 Free Software Foundation, Inc.

;; Author: Bill Perry <wmperry@gnu.org>
;; Maintainer: emacs-devel@gnu.org
;; Keywords: comm, data, processes

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

(require 'url-vars)
(require 'url-parse)
(require 'network-stream)

(autoload 'socks-open-network-stream "socks")

(defgroup url-gateway nil
  "URL gateway variables."
  :group 'url)

(defcustom url-gateway-local-host-regexp nil
  "A regular expression specifying local hostnames/machines."
  :type '(choice (const nil) regexp)
  :group 'url-gateway)

(defcustom url-gateway-prompt-pattern
  "^[^#$%>;]*[#$%>;] *" ;; "bash\\|[$>] *\r?$"
  "A regular expression matching a shell prompt."
  :type 'regexp
  :group 'url-gateway)

(defcustom url-gateway-rlogin-host nil
  "What hostname to actually rlog into before doing a telnet."
  :type '(choice (const nil) string)
  :group 'url-gateway)
(make-obsolete-variable 'url-gateway-rlogin-host nil "29.1")

(defcustom url-gateway-rlogin-user-name nil
  "Username to log into the remote machine with when using rlogin."
  :type '(choice (const nil) string)
  :group 'url-gateway)
(make-obsolete-variable 'url-gateway-rlogin-user-name nil "29.1")

(defcustom url-gateway-rlogin-parameters '("telnet" "-8")
  "Parameters to `url-open-rlogin'.
This list will be used as the parameter list given to rsh."
  :type '(repeat string)
  :group 'url-gateway)
(make-obsolete-variable 'url-gateway-rlogin-parameters nil "29.1")

(defcustom url-gateway-telnet-host nil
  "What hostname to actually login to before doing a telnet."
  :type '(choice (const nil) string)
  :group 'url-gateway)

(defcustom url-gateway-telnet-parameters '("exec" "telnet" "-8")
  "Parameters to `url-open-telnet'.
This list will be executed as a command after logging in via telnet."
  :type '(repeat string)
  :group 'url-gateway)

(defcustom url-gateway-telnet-login-prompt "^\r*.?login:"
  "Prompt that tells us we should send our username when logging in w/telnet."
  :type 'regexp
  :group 'url-gateway)

(defcustom url-gateway-telnet-password-prompt "^\r*.?password:"
  "Prompt that tells us we should send our password when logging in w/telnet."
  :type 'regexp
  :group 'url-gateway)

(defcustom url-gateway-telnet-user-name nil
  "User name to log in via telnet with."
  :type '(choice (const nil) string)
  :group 'url-gateway)

(defcustom url-gateway-telnet-password nil
  "Password to use to log in via telnet with."
  :type '(choice (const nil) string)
  :group 'url-gateway)

(defcustom url-gateway-broken-resolution nil
  "Whether to use nslookup to resolve hostnames.
This should be used when your version of Emacs cannot correctly use DNS,
but your machine can.  This usually happens if you are running a statically
linked Emacs under SunOS 4.x."
  :type 'boolean
  :group 'url-gateway)

(defcustom url-gateway-nslookup-program "nslookup"
  "If non-nil then a string naming nslookup program."
  :type '(choice (const :tag "None" :value nil) string)
  :group 'url-gateway)

;; Stolen from ange-ftp
;;;###autoload
(defun url-gateway-nslookup-host (host)
  "Attempt to resolve the given HOST using nslookup if possible."
  (interactive "sHost:  ")
  (if url-gateway-nslookup-program
      (let ((proc (start-process " *nslookup*" " *nslookup*"
				 url-gateway-nslookup-program host))
	    (res host))
	(set-process-query-on-exit-flag proc nil)
	(with-current-buffer (process-buffer proc)
	  (while (memq (process-status proc) '(run open))
	    (accept-process-output proc))
	  (goto-char (point-min))
	  (if (re-search-forward "Name:.*\nAddress: *\\(.*\\)$" nil t)
	      (setq res (buffer-substring (match-beginning 1)
					  (match-end 1))))
	  (kill-buffer (current-buffer)))
	res)
    host))

;; Stolen from red gnus nntp.el
(defun url-wait-for-string (regexp proc)
  "Wait until string matching REGEXP arrives in process PROC's buffer."
  (let ((buf (current-buffer)))
    (goto-char (point-min))
    (while (not (re-search-forward regexp nil t))
      (accept-process-output proc)
      (set-buffer buf)
      (goto-char (point-min)))))

;; Stolen from red gnus nntp.el
(defun url-open-rlogin (name buffer host service)
  "Open a connection using rsh."
  (declare (obsolete nil "29.1"))
  (if (not (stringp service))
      (setq service (int-to-string service)))
  (let ((proc (if url-gateway-rlogin-user-name
		  (start-process
		   name buffer "rsh"
		   url-gateway-rlogin-host "-l" url-gateway-rlogin-user-name
		   (mapconcat 'identity
			      (append url-gateway-rlogin-parameters
				      (list host service)) " "))
		(start-process
		 name buffer "rsh" url-gateway-rlogin-host
		 (mapconcat 'identity
			    (append url-gateway-rlogin-parameters
				    (list host service))
			    " ")))))
    (set-buffer buffer)
    (url-wait-for-string "^\r*200" proc)
    (beginning-of-line)
    (delete-region (point-min) (point))
    proc))

;; Stolen from red gnus nntp.el
(defun url-open-telnet (name buffer host service)
  (if (not (stringp service))
      (setq service (int-to-string service)))
  (with-current-buffer (get-buffer-create buffer)
    (erase-buffer)
    (let ((proc (start-process name buffer "telnet" "-8"))
	  (case-fold-search t))
      (when (memq (process-status proc) '(open run))
	(process-send-string proc "set escape \^X\n")
	(process-send-string proc (concat
				   "open " url-gateway-telnet-host "\n"))
	(url-wait-for-string url-gateway-telnet-login-prompt proc)
	(process-send-string
	 proc (concat
	       (or url-gateway-telnet-user-name
		   (setq url-gateway-telnet-user-name (read-string "login: ")))
	       "\n"))
	(url-wait-for-string url-gateway-telnet-password-prompt proc)
	(process-send-string
	 proc (concat
	       (or url-gateway-telnet-password
		   (setq url-gateway-telnet-password
			 (read-passwd "Password: ")))
	       "\n"))
	(erase-buffer)
	(url-wait-for-string url-gateway-prompt-pattern proc)
	(process-send-string
	 proc (concat (mapconcat 'identity
				 (append url-gateway-telnet-parameters
					 (list host service)) " ") "\n"))
	(url-wait-for-string "^\r*Escape character.*\n+" proc)
	(delete-region (point-min) (match-end 0))
	(process-send-string proc "\^]\n")
	(url-wait-for-string "^telnet" proc)
	(process-send-string proc "mode character\n")
	(accept-process-output proc 1)
	(sit-for 1)
	(goto-char (point-min))
	(forward-line 1)
	(delete-region (point) (point-max)))
      proc)))

(defvar url-gw-rlogin-obsolete-warned-once nil)
(make-obsolete-variable 'url-gw-rlogin-obsolete-warned-once nil "29.1")

;;;###autoload
(cl-defun url-open-stream (name buffer host service &optional gateway-method &key timeout)
  "Open a stream to HOST, possibly via a gateway.
Args per `open-network-stream'.
Will not make a connection if `url-gateway-unplugged' is non-nil.
Might do a non-blocking connection; use `process-status' to check.

Optional arg GATEWAY-METHOD specifies the gateway to be used,
overriding the value of `url-gateway-method'.
Optional key TIMEOUT is a list of seconds and microseconds."
  (unless url-gateway-unplugged
    (let* ((gwm (or gateway-method url-gateway-method))
           (gw-method (if (and url-gateway-local-host-regexp
                               (not (eq 'tls gwm))
                               (not (eq 'ssl gwm))
                               (string-match
                                url-gateway-local-host-regexp
                                host))
                          'native
                        gwm))
	   ;; An attempt to deal with denied connections, and attempt
	   ;; to reconnect
	   ;; (cur-retries 0)
	   ;; (retry t)
	   (conn nil))

      ;; If the user told us to do DNS for them, do it.
      (if url-gateway-broken-resolution
	  (setq host (url-gateway-nslookup-host host)))

      (condition-case nil
	  ;; This is a clean way to ensure the new process inherits the
	  ;; right coding systems in both Emacs and XEmacs.
	  (let ((coding-system-for-read 'binary)
		(coding-system-for-write 'binary))
	    (setq conn (pcase gw-method
			 ((or 'tls 'ssl 'native)
			  (if (eq gw-method 'native)
			      (setq gw-method 'plain))
			  (apply #'open-network-stream
			         name buffer host service
			         :type gw-method
                                 (append
                                  (when (and (featurep 'make-network-process)
                                             (url-asynchronous url-current-object))
                                    (cons :nowait (list '(:nowait t))))
                                  (when (and (featurep 'make-network-process)
                                             timeout)
                                    (cons :sndtimeo (list timeout))))))
                         ('socks
			  (socks-open-network-stream name buffer host service))
			 ('telnet
			  (url-open-telnet name buffer host service))
			 ('rlogin
                          (unless url-gw-rlogin-obsolete-warned-once
                            (lwarn 'url :error "Setting `url-gateway-method' to `rlogin' is obsolete")
                            (setq url-gw-rlogin-obsolete-warned-once t))
                          (with-suppressed-warnings ((obsolete url-open-rlogin))
                            (url-open-rlogin name buffer host service)))
			 (_
			  (error "Bad setting of url-gateway-method: %s"
				 url-gateway-method))))))
      conn)))

(provide 'url-gw)

;;; url-gw.el ends here
