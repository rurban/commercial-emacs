;;; net-utils.el --- network functions  -*- lexical-binding: t; -*-

;; Copyright (C) 1998-2023 Free Software Foundation, Inc.

;; Author: Peter Breton <pbreton@cs.umb.edu>
;; Created: Sun Mar 16 1997
;; Keywords: network comm

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

;; There are three main areas of functionality:
;;
;; * Wrap common network utility programs (ping, traceroute, netstat,
;; nslookup, arp, route).  Note that these wrappers are of the diagnostic
;; functions of these programs only.
;;
;; * Implement some very basic protocols in Emacs Lisp (finger and whois)
;;
;; * Support connections to HOST/PORT, generally for debugging and the like.
;; In other words, for doing much the same thing as "telnet HOST PORT", and
;; then typing commands.

;;; Code:

;; On some systems, programs like ifconfig are not in normal user
;; path, but rather in /sbin, /usr/sbin, etc. (but non-root users can
;; still use them for queries).  Actually the trend these
;; days is for /sbin to be a symlink to /usr/sbin, but we still need to
;; search both for older systems.

(require 'subr-x)
(require 'cl-lib)

(defun net-utils--executable-find-sbin (command)
  "Return absolute name of COMMAND if found in an sbin directory."
  (let ((exec-path '("/sbin" "/usr/sbin" "/usr/local/sbin")))
    (executable-find command)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customization Variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defgroup net-utils nil
  "Network utility functions."
  :prefix "net-utils-"
  :group 'comm
  :version "20.3")

(defcustom traceroute-program
  (if (eq system-type 'windows-nt)
      "tracert"
    "traceroute")
  "Program to trace network hops to a destination."
  :type  'string)

(defcustom traceroute-program-options nil
  "Options for the traceroute program."
  :type  '(repeat string))

(defcustom ping-program "ping"
  "Program to send network test packets to a host."
  :type  'string)

;; On GNU/Linux and Irix, the system's ping program seems to send packets
;; indefinitely unless told otherwise
(defcustom ping-program-options
  (and (eq system-type 'gnu/linux)
       (list "-c" "4"))
  "Options for the ping program.
These options can be used to limit how many ICMP packets are emitted."
  :type  '(repeat string))

(defcustom ifconfig-program
  (cond ((eq system-type 'windows-nt) "ipconfig")
        ((executable-find "ifconfig") "ifconfig")
        ((net-utils--executable-find-sbin "ifconfig"))
        ((net-utils--executable-find-sbin "ip"))
        (t "ip"))
  "Program to print network configuration information."
  :version "25.1"                       ; add ip
  :type  'string)

(defcustom ifconfig-program-options
  (cond ((string-match "ipconfig\\'" ifconfig-program) '("/all"))
        ((string-match "ifconfig\\'" ifconfig-program) '("-a"))
        ((string-match "ip\\'" ifconfig-program) '("addr")))
  "Options for the ifconfig program."
  :version "25.1"
  :set-after '(ifconfig-program)
  :type  '(repeat string))

(defcustom iwconfig-program
  (cond ((executable-find "iwconfig") "iwconfig")
        ((net-utils--executable-find-sbin "iw") "iw")
        (t "iw"))
  "Program to print wireless network configuration information."
  :type 'string
  :version "26.1")

(defcustom iwconfig-program-options
  (cond ((string-match-p "iw\\'" iwconfig-program) (list "dev"))
        (t nil))
 "Options for the iwconfig program."
 :type '(repeat string)
 :version "26.1")

(defcustom netstat-program
  (cond ((executable-find "netstat") "netstat")
        ((net-utils--executable-find-sbin "ss"))
        (t "ss"))
  "Program to print network statistics."
  :type  'string
  :version "26.1")

(defcustom netstat-program-options
  (list "-a")
  "Options for the netstat program."
  :type  '(repeat string))

(defcustom arp-program (or (net-utils--executable-find-sbin "arp") "arp")
  "Program to print IP to address translation tables."
  :type  'string)

(defcustom arp-program-options
  (list "-a")
  "Options for the arp program."
  :type  '(repeat string))

(defcustom route-program
  (cond ((eq system-type 'windows-nt) "route")
        ((executable-find "netstat") "netstat")
        ((net-utils--executable-find-sbin "netstat"))
        ((executable-find "ip") "ip")
        ((net-utils--executable-find-sbin "ip"))
        (t "ip"))
  "Program to print routing tables."
  :type  'string
  :version "26.1")

(defcustom route-program-options
  (cond ((eq system-type 'windows-nt) (list "print"))
        ((string-match-p "netstat\\'" route-program) (list "-r"))
        (t (list "route")))
  "Options for the route program."
  :type  '(repeat string)
  :version "26.1")

(defcustom nslookup-program "nslookup"
  "Program to interactively query DNS information."
  :type  'string)

(defcustom nslookup-program-options nil
  "Options for the nslookup program."
  :type  '(repeat string))

(defcustom nslookup-prompt-regexp "^> "
  "Regexp to match the nslookup prompt.

This variable is only used if the variable
`comint-use-prompt-regexp' is non-nil."
  :type  'regexp)

(defcustom ftp-program "ftp"
  "Program to run to do FTP transfers."
  :type  'string)

(defcustom ftp-program-options nil
  "Options for the ftp program."
  :type  '(repeat string))

(defcustom ftp-prompt-regexp "^ftp>"
  "Regexp which matches the FTP program's prompt.

This variable is only used if the variable
`comint-use-prompt-regexp' is non-nil."
  :type  'regexp)

(defcustom smbclient-program "smbclient"
  "Smbclient program."
  :type  'string)

(defcustom smbclient-program-options nil
  "Options for the smbclient program."
  :type  '(repeat string))

(defcustom smbclient-prompt-regexp "^smb: >"
  "Regexp which matches the smbclient program's prompt.

This variable is only used if the variable
`comint-use-prompt-regexp' is non-nil."
  :type  'regexp)

(defcustom dns-lookup-program "host"
  "Program to interactively query DNS information."
  :type  'string)

(defcustom dns-lookup-program-options nil
  "Options for the dns-lookup program."
  :type  '(repeat string))

;; Internal variables
(defvar network-connection-service nil)
(defvar network-connection-host    nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Nslookup goodies
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar nslookup-font-lock-keywords
  (list
   (list "^[A-Za-z0-9 _]+:" 0 'font-lock-type-face)
   (list "\\<\\(SOA\\|NS\\|MX\\|A\\|CNAME\\)\\>"
         1 'font-lock-keyword-face)
   ;; Dotted quads
   (list
    (mapconcat #'identity
               (make-list 4 "[0-9]+")
               "\\.")
    0 'font-lock-variable-name-face)
   ;; Host names
   (list
    (let ((host-expression "[-A-Za-z0-9]+"))
      (concat
       (mapconcat #'identity
                  (make-list 2 host-expression)
                  "\\.")
       "\\(\\." host-expression "\\)*"))
    0 'font-lock-variable-name-face))
  "Expressions to font-lock for nslookup.")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General network utilities mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar net-utils-font-lock-keywords
  (list
   ;; Dotted quads
   (list
    (mapconcat #'identity (make-list 4 "[0-9]+") "\\.")
    0 'font-lock-variable-name-face)
   ;; Simple rfc4291 addresses
   (list (concat
	  "\\( \\([[:xdigit:]]+\\(:\\|::\\)\\)+[[:xdigit:]]+\\)"
	  "\\|"
	  "\\(::[[:xdigit:]]+\\)")
    0 'font-lock-variable-name-face)
   ;; Host names
   (list
    (let ((host-expression "[-A-Za-z0-9]+"))
      (concat
       (mapconcat #'identity (make-list 2 host-expression) "\\.")
       "\\(\\." host-expression "\\)*"))
    0 'font-lock-variable-name-face))
  "Expressions to font-lock for general network utilities.")

(define-derived-mode net-utils-mode special-mode "NetworkUtil"
  "Major mode for interacting with an external network utility."
  :interactive nil
  (setq-local font-lock-defaults
              '((net-utils-font-lock-keywords)))
  (setq-local revert-buffer-function #'net-utils--revert-function))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utility functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun net-utils-remove-ctrl-m-filter (process output-string)
  "Remove trailing control Ms."
  (with-current-buffer (process-buffer process)
    (save-excursion
      (let ((inhibit-read-only t)
            (filtered-string output-string))
        (while (string-match "\r" filtered-string)
          (setq filtered-string
                (replace-match "" nil nil filtered-string)))
        ;; Insert the text, moving the process-marker.
        (goto-char (process-mark process))
        (insert filtered-string)
        (set-marker (process-mark process) (point))))))

(declare-function w32-get-console-output-codepage "w32proc.c" ())

(defun net-utils-run-program (name header program args)
  "Run a network information program."
  (let ((buf (get-buffer-create (concat "*" name "*")))
	(coding-system-for-read
	 ;; MS-Windows versions of network utilities output text
	 ;; encoded in the console (a.k.a. "OEM") codepage, which is
	 ;; different from the default system (a.k.a. "ANSI")
	 ;; codepage.
	 (if (eq system-type 'windows-nt)
	     (intern (format "cp%d" (w32-get-console-output-codepage)))
	   coding-system-for-read)))
    (set-buffer buf)
    (erase-buffer)
    (insert header "\n")
    (set-process-filter
     (apply #'start-process name buf program args)
     #'net-utils-remove-ctrl-m-filter)
    (display-buffer buf)
    buf))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General network utilities (diagnostic)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Todo: This data could be saved in a bookmark.
(defvar net-utils--revert-cmd nil)

(defun net-utils-run-simple (buffer program-name args &optional nodisplay)
  "Run a network utility for diagnostic output only."
  (with-current-buffer (if (stringp buffer) (get-buffer-create buffer) buffer)
    (let ((proc (get-buffer-process (current-buffer))))
      (when proc
        (set-process-filter proc nil)
        (delete-process proc)))
    (let ((inhibit-read-only t))
      (erase-buffer))
    (net-utils-mode)
    (setq-local net-utils--revert-cmd
                `(net-utils-run-simple ,(current-buffer)
                                       ,program-name ,args nodisplay))
    (let ((coding-system-for-read
	   ;; MS-Windows versions of network utilities output text
	   ;; encoded in the console (a.k.a. "OEM") codepage, which is
	   ;; different from the default system (a.k.a. "ANSI")
	   ;; codepage.
	   (if (eq system-type 'windows-nt)
	       (intern (format "cp%d" (w32-get-console-output-codepage)))
	     coding-system-for-read)))
      (set-process-filter
       (apply #'start-process program-name
              (current-buffer) program-name args)
       #'net-utils-remove-ctrl-m-filter))
    (unless nodisplay (display-buffer (current-buffer)))))

(defun net-utils--revert-function (&optional _ignore-auto _noconfirm)
  (message "Reverting `%s'..." (buffer-name))
  (apply (car net-utils--revert-cmd) (cdr net-utils--revert-cmd))
  (let ((proc (get-buffer-process (current-buffer))))
    (when proc
      (set-process-sentinel
       proc
       (lambda (process event)
         (when (string= event "finished\n")
           (message "Reverting `%s' done" (process-buffer process))))))))

;;;###autoload
(defun ifconfig ()
  "Run `ifconfig-program' and display diagnostic output."
  (interactive)
  (net-utils-run-simple
   (format "*%s*" ifconfig-program)
   ifconfig-program
   ifconfig-program-options))

(defalias 'ipconfig #'ifconfig)

;;;###autoload
(defun iwconfig ()
  "Run `iwconfig-program' and display diagnostic output."
  (interactive)
  (net-utils-run-simple
   (format "*%s*" iwconfig-program)
   iwconfig-program
   iwconfig-program-options))

;;;###autoload
(defun netstat ()
  "Run `netstat-program' and display diagnostic output."
  (interactive)
  (net-utils-run-simple
   (format "*%s*" netstat-program)
   netstat-program
   netstat-program-options))

;;;###autoload
(defun arp ()
  "Run `arp-program' and display diagnostic output."
  (interactive)
  (net-utils-run-simple
   (format "*%s*" arp-program)
   arp-program
   arp-program-options))

;;;###autoload
(defun route ()
  "Run `route-program' and display diagnostic output."
  (interactive)
  (net-utils-run-simple
   (format "*%s*" route-program)
   route-program
   route-program-options))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Wrappers for external network programs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;###autoload
(defun traceroute (target)
  "Run `traceroute-program' for TARGET."
  (interactive "sTarget: ")
  (let ((options
	 (if traceroute-program-options
	     (append traceroute-program-options (list target))
	   (list target))))
    (net-utils-run-simple
     (concat "Traceroute" " " target)
     traceroute-program
     options)))

;;;###autoload
(defun ping (host)
  "Ping HOST.
If your system's ping continues until interrupted, you can try setting
`ping-program-options'."
  (interactive
   (list (let ((default (ffap-machine-at-point)))
           (read-string (format-prompt "Ping host" default) nil nil default))))
  (let ((options
	 (if ping-program-options
	     (append ping-program-options (list host))
	   (list host))))
    (net-utils-run-program
     (concat "Ping" " " host)
     (concat "** Ping ** " ping-program " ** " host)
     ping-program
     options)))

;;;###autoload
(defun nslookup-host (host &optional name-server)
  "Look up the DNS information for HOST (name or IP address).
Optional argument NAME-SERVER says which server to use for
DNS resolution.
Interactively, prompt for NAME-SERVER if invoked with prefix argument.

This command uses `nslookup-program' for looking up the DNS information.

See also: `nslookup-host-ipv4', `nslookup-host-ipv6' for
non-interactive versions of this function more suitable for use
in Lisp code."
  (interactive
   (list (let ((default (ffap-machine-at-point)))
           (read-string (format-prompt "Lookup host" default) nil nil default))
         (if current-prefix-arg (read-from-minibuffer "Name server: "))))
  (let ((options
         (append nslookup-program-options (list host)
                 (if name-server (list name-server)))))
    (net-utils-run-program
     "Nslookup"
     (concat "** "
      (mapconcat #'identity
		(list "Nslookup" host nslookup-program)
		" ** "))
     nslookup-program
     options)))

;;;###autoload
(defun nslookup-host-ipv4 (host &optional name-server format)
  "Return the IPv4 address for HOST (name or IP address).
Optional argument NAME-SERVER says which server to use for DNS
resolution.

If FORMAT is `string', returns the IP address as a
string (default).  If FORMAT is `vector', returns a 4-integer
vector of octets.

This command uses `nslookup-program' to look up DNS records."
  (let* ((args `(,nslookup-program "-type=A" ,host ,name-server))
         (output (shell-command-to-string
                  (string-join (cl-remove nil args) " ")))
         (ip (or (and (string-match
                       "Name:.*\nAddress: *\\(\\([0-9]\\{1,3\\}\\.?\\)\\{4\\}\\)"
                       output)
                      (match-string 1 output))
                 host)))
    (cond ((memq format '(string nil))
           ip)
          ((eq format 'vector)
           (apply #'vector (mapcar #'string-to-number (split-string ip "\\."))))
          (t (error "Invalid format: %s" format)))))

(defun nslookup--ipv6-expand (ipv6-vector)
  (let ((len (length ipv6-vector)))
    (if (< len 8)
        (let* ((pivot (cl-position 0 ipv6-vector))
               (head (cl-subseq ipv6-vector 0 pivot))
               (tail (cl-subseq ipv6-vector (1+ pivot) len)))
          (vconcat head (make-vector (- 8 (1- len)) 0) tail))
      ipv6-vector)))

;;;###autoload
(defun nslookup-host-ipv6 (host &optional name-server format)
  "Return the IPv6 address for HOST (name or IP address).
Optional argument NAME-SERVER says which server to use for DNS
resolution.

If FORMAT is `string', returns the IP address as a
string (default).  If FORMAT is `vector', returns a 8-integer
vector of hextets.

This command uses `nslookup-program' to look up DNS records."
  (let* ((args `(,nslookup-program "-type=AAAA" ,host ,name-server))
         (output (shell-command-to-string
                  (string-join (cl-remove nil args) " ")))
         (hextet "[0-9a-fA-F]\\{1,4\\}")
         (ip-regex (concat "\\(\\(" hextet "[:]\\)\\{1,6\\}\\([:]?\\(" hextet "\\)\\{1,6\\}\\)\\)"))
         (ip (or (and (string-match
                       (if (eq system-type 'windows-nt)
                           (concat "Name:.*\nAddress: *" ip-regex)
                         (concat "has AAAA address " ip-regex))
                       output)
                      (match-string 1 output))
                 host)))
    (cond ((memq format '(string nil))
           ip)
          ((eq format 'vector)
           (nslookup--ipv6-expand
            (apply #'vector
                   (cl-loop for hextet in (split-string ip "[:]")
                            collect (string-to-number hextet 16)))))
          (t (error "Invalid format: %s" format)))))

;;;###autoload
(defun nslookup ()
  "Run `nslookup-program'."
  (interactive)
  (switch-to-buffer (make-comint "nslookup" nslookup-program))
  (nslookup-mode))

(defvar comint-prompt-regexp)
(defvar comint-input-autoexpand)

(autoload 'comint-mode "comint" nil t)

(defvar-keymap nslookup-mode-map
  "TAB" #'completion-at-point)

(define-derived-mode nslookup-mode comint-mode "Nslookup"
  "Major mode for interacting with the nslookup program."
  :interactive nil
  (setq-local font-lock-defaults
              '((nslookup-font-lock-keywords)))
  (setq comint-prompt-regexp nslookup-prompt-regexp)
  (setq comint-input-autoexpand t))

;;;###autoload
(defun dns-lookup-host (host &optional name-server)
  "Look up the DNS information for HOST (name or IP address).
Optional argument NAME-SERVER says which server to use for
DNS resolution.
Interactively, prompt for NAME-SERVER if invoked with prefix argument.

This command uses `dns-lookup-program' for looking up the DNS information."
  (interactive
   (list (let ((default (ffap-machine-at-point)))
           (read-string (format-prompt "Lookup host" default) nil nil default))
         (if current-prefix-arg (read-from-minibuffer "Name server: "))))
  (let ((options
         (append dns-lookup-program-options (list host)
                 (if name-server (list name-server)))))
    (net-utils-run-program
     (concat "DNS Lookup [" host "]")
     (concat "** "
	     (mapconcat #'identity
		        (list "DNS Lookup" host dns-lookup-program)
		        " ** "))
     dns-lookup-program
     options)))

;;;###autoload
(defun run-dig (host &optional name-server)
  "Look up DNS information for HOST (name or IP address).
Optional argument NAME-SERVER says which server to use for
DNS resolution.
Interactively, prompt for NAME-SERVER if invoked with prefix argument.

This command uses `dig-program' for looking up the DNS information."
  (declare (obsolete dig "29.1"))
  (interactive
   (list (let ((default (ffap-machine-at-point)))
           (read-string (format-prompt "Lookup host" default) nil nil default))
         (if current-prefix-arg (read-from-minibuffer "Name server: "))))
  (dig host nil nil nil nil name-server))

(autoload 'comint-exec "comint")
(declare-function comint-watch-for-password-prompt "comint" (string))

;; This is a lot less than ange-ftp, but much simpler.
;;;###autoload
(defun ftp (host)
  "Run `ftp-program' to connect to HOST."
  (interactive
   (list (let ((default (ffap-machine-at-point)))
           (read-string (format-prompt "Ftp to Host" default) nil nil default))))
  (let ((buf (get-buffer-create (concat "*ftp [" host "]*"))))
    (set-buffer buf)
    (ftp-mode)
    (comint-exec buf (concat "ftp-" host) ftp-program nil
		 (if ftp-program-options
		     (append (list host) ftp-program-options)
		   (list host)))
    (pop-to-buffer buf)))

(defvar-keymap ftp-mode-map
  "TAB" #'completion-at-point)

(define-derived-mode ftp-mode comint-mode "FTP"
  "Major mode for interacting with the ftp program."
  :interactive nil
  (setq comint-prompt-regexp ftp-prompt-regexp)
  (setq comint-input-autoexpand t)
  ;; Only add the password-prompting hook if it's not already in the
  ;; global hook list.  This stands a small chance of losing, if it's
  ;; later removed from the global list (very small, since any
  ;; password prompts will probably immediately follow the initial
  ;; connection), but it's better than getting prompted twice for the
  ;; same password.
  (unless (memq #'comint-watch-for-password-prompt
		(default-value 'comint-output-filter-functions))
    (add-hook 'comint-output-filter-functions #'comint-watch-for-password-prompt
	      nil t)))

(defun smbclient (host service)
  "Connect to SERVICE on HOST via SMB.

This command uses `smbclient-program' to connect to HOST."
  (interactive
   (list
    (let ((default (ffap-machine-at-point)))
      (read-string (format-prompt "Connect to Host" default) nil nil default))
    (read-from-minibuffer "SMB Service: ")))
  (let* ((name (format "smbclient [%s\\%s]" host service))
	 (buf (get-buffer-create (concat "*" name "*")))
	 (service-name (concat "\\\\" host "\\" service)))
    (set-buffer buf)
    (smbclient-mode)
    (comint-exec buf name smbclient-program nil
		 (if smbclient-program-options
		     (append (list service-name) smbclient-program-options)
		   (list service-name)))
    (pop-to-buffer buf)))

(defun smbclient-list-shares (host)
  "List services on HOST.
This command uses `smbclient-program' to connect to HOST."
  (interactive
   (list
    (let ((default (ffap-machine-at-point)))
      (read-string (format-prompt "Connect to Host" default) nil nil default))))
  (let ((buf (get-buffer-create (format "*SMB Shares on %s*" host))))
    (set-buffer buf)
    (smbclient-mode)
    (comint-exec buf "smbclient-list-shares"
		 smbclient-program nil (list "-L" host))
    (pop-to-buffer buf)))

(define-derived-mode smbclient-mode comint-mode "smbclient"
  "Major mode for interacting with the smbclient program."
  :interactive nil
  (setq comint-prompt-regexp smbclient-prompt-regexp)
  (setq comint-input-autoexpand t)
  ;; Only add the password-prompting hook if it's not already in the
  ;; global hook list.  This stands a small chance of losing, if it's
  ;; later removed from the global list (very small, since any
  ;; password prompts will probably immediately follow the initial
  ;; connection), but it's better than getting prompted twice for the
  ;; same password.
  (unless (memq #'comint-watch-for-password-prompt
		(default-value 'comint-output-filter-functions))
    (add-hook 'comint-output-filter-functions #'comint-watch-for-password-prompt
	      nil t)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Network Connections
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Full list is available at:
;; https://www.iana.org/assignments/port-numbers
(defvar network-connection-service-alist
  (list
    (cons 'echo          7)
    (cons 'active-users 11)
    (cons 'daytime      13)
    (cons 'chargen      19)
    (cons 'ftp          21)
    (cons 'telnet	23)
    (cons 'smtp		25)
    (cons 'time		37)
    (cons 'whois        43)
    (cons 'gopher       70)
    (cons 'finger       79)
    (cons 'www		80)
    (cons 'pop2		109)
    (cons 'pop3		110)
    (cons 'sun-rpc	111)
    (cons 'nntp		119)
    (cons 'ntp		123)
    (cons 'netbios-name 137)
    (cons 'netbios-data 139)
    (cons 'irc		194)
    (cons 'https	443)
    (cons 'rlogin	513))
  "Alist of services and associated TCP port numbers.
This list is not complete.")

;; Workhorse routine
(defun run-network-program (process-name host port &optional initial-string)
  (let ((tcp-connection)
	(buf))
    (setq buf (get-buffer-create (concat "*" process-name "*")))
    (set-buffer buf)
    (or
     (setq tcp-connection
	   (open-network-stream process-name buf host port))
     (error "Could not open connection to %s" host))
    (erase-buffer)
    (set-marker (process-mark tcp-connection) (point-min))
    (set-process-filter tcp-connection #'net-utils-remove-ctrl-m-filter)
    (and initial-string
	 (process-send-string tcp-connection
			      (concat initial-string "\r\n")))
    (display-buffer buf)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Simple protocols
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defcustom finger-X.500-host-regexps nil
  "A list of regular expressions matching host names.
If a host name passed to `finger' matches one of these regular
expressions, it is assumed to be a host that doesn't accept
queries of the form USER@HOST, and wants a query containing USER only."
  :type '(repeat regexp)
  :version "21.1")

;; Finger protocol
;;;###autoload
(defun finger (user host)
  "Finger USER on HOST.
This command uses `finger-X.500-host-regexps'
and `network-connection-service-alist', which see."
  ;; One of those great interactive statements that's actually
  ;; longer than the function call! The idea is that if the user
  ;; uses a string like "pbreton@cs.umb.edu", we won't ask for the
  ;; host name. If we don't see an "@", we'll prompt for the host.
  (interactive
    (let* ((answer (let ((default (ffap-url-at-point)))
                     (read-string (format-prompt "Finger User" default) nil nil default)))
	   (index  (string-match (regexp-quote "@") answer)))
      (if index
	  (list (substring answer 0 index)
		(substring answer (1+ index)))
	(list answer
              (let ((default (ffap-machine-at-point)))
                (read-string (format-prompt "At Host" default) nil nil default))))))
  (let* ((user-and-host (concat user "@" host))
	 (process-name (concat "Finger [" user-and-host "]"))
	 (regexps finger-X.500-host-regexps)
	 ) ;; found
    (and regexps
	 (while (not (string-match (car regexps) host))
	   (setq regexps (cdr regexps)))
	 (when regexps
	   (setq user-and-host user)))
    (run-network-program
     process-name
     host
     (cdr (assoc 'finger network-connection-service-alist))
     user-and-host)))

(defcustom whois-server-name "rs.internic.net"
  "Default host name for the whois service."
  :type  'string)

(defcustom whois-server-list
  '(("whois.arin.net")     ; Networks, ASN's, and related POC's (numbers)
    ("rs.internic.net")  ; domain related info
    ("whois.publicinterestregistry.net")
    ("whois.abuse.net")
    ("whois.apnic.net")
    ("nic.ddn.mil")
    ("whois.nic.mil")
    ("whois.nic.gov")
    ("whois.ripe.net"))
  "A list of whois servers that can be queried."
  :type '(repeat (list string)))

;; FIXME: modern whois clients include a much better tld <-> whois server
;; list, Emacs should probably avoid specifying the server as the client
;; will DTRT anyway... -rfr
;; I'm not sure about the above FIXME.  It seems to me that we should
;; just check the Root Zone Database maintained at:
;;     https://www.iana.org/domains/root/db
;; For example:  whois -h whois.iana.org .se | grep whois
(defcustom whois-server-tld
  '(("whois.verisign-grs.com" . "com")
    ("whois.verisign-grs.com" . "net")
    ("whois.pir.org" . "org")
    ("whois.ripe.net" . "be")
    ("whois.ripe.net" . "de")
    ("whois.ripe.net" . "dk")
    ("whois.ripe.net" . "it")
    ("whois.ripe.net" . "fi")
    ("whois.ripe.net" . "fr")
    ("whois.ripe.net" . "uk")
    ("whois.iis.se" . "se")
    ("whois.iis.nu" . "nu")
    ("whois.apnic.net" . "au")
    ("whois.apnic.net" . "ch")
    ("whois.apnic.net" . "hk")
    ("whois.apnic.net" . "jp")
    ("whois.eu" . "eu")
    ("whois.nic.gov" . "gov")
    ("whois.nic.mil" . "mil"))
  "Alist to map top level domains to whois servers."
  :type '(repeat (cons string string)))

(defcustom whois-guess-server t
  "If non-nil, try to deduce the appropriate whois server from the query.
If the query doesn't look like a domain or hostname then the
server named by `whois-server-name' is used."
  :type 'boolean)

(defun whois-get-tld (host)
  "Return the top level domain of `host', or nil if it isn't a domain name."
  (let ((i (1- (length host)))
	(max-len (- (length host) 5)))
    (while (not (or (= i max-len) (char-equal (aref host i) ?.)))
      (setq i (1- i)))
    (if (= i max-len)
	nil
      (substring host (1+ i)))))

;; Whois protocol
;;;###autoload
(defun whois (arg search-string)
  "Send SEARCH-STRING to server defined by the `whois-server-name' variable.
If `whois-guess-server' is non-nil, then try to deduce the correct server
from SEARCH-STRING.  With argument, prompt for whois server.
The port is deduced from `network-connection-service-alist'."
  (interactive "P\nsWhois: ")
  (let* ((whois-apropos-host (if whois-guess-server
				 (rassoc (whois-get-tld search-string)
					 whois-server-tld)
			       nil))
	 (server-name (if whois-apropos-host
			  (car whois-apropos-host)
			whois-server-name))
	 (host
	  (if arg
	      (completing-read "Whois server name: "
			       whois-server-list nil nil "whois.")
	    server-name)))
    (run-network-program
     "Whois"
     host
     (cdr (assoc 'whois network-connection-service-alist))
     search-string)))

(defcustom whois-reverse-lookup-server "whois.arin.net"
  "Server which provides inverse DNS mapping."
  :type  'string)

;;;###autoload
(defun whois-reverse-lookup ()
  (interactive)
  (let ((whois-server-name whois-reverse-lookup-server))
    (call-interactively 'whois)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; General Network connection
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-derived-mode network-connection-mode comint-mode "Network-Connection"
  "Major mode for interacting with the `network-connection' program."
  :interactive nil)

(defun network-connection-mode-setup (host service)
  (setq-local network-connection-host host)
  (setq-local network-connection-service service))

;;;###autoload
(defun network-connection-to-service (host service)
  "Open a network connection to SERVICE on HOST.
This command uses `network-connection-service-alist', which see."
  (interactive
   (list
    (let ((default (ffap-machine-at-point)))
      (read-string (format-prompt "Host" default) nil nil default))
    (completing-read "Service: "
		     (mapcar
                      (lambda (elt)
                        (list (symbol-name (car elt))))
		      network-connection-service-alist))))
  (network-connection
   host
   (cdr (assoc (intern service) network-connection-service-alist))))

;;;###autoload
(defun network-connection (host port)
  "Open a network connection to HOST on PORT."
  (interactive "sHost: \nnPort: ")
  (network-service-connection host (number-to-string port)))

(defun network-service-connection (host service)
  "Open a network connection to SERVICE on HOST.
The port to use is determined from `network-connection-service-alist'."
  (let* ((process-name (concat "Network Connection [" host " " service "]"))
	 (portnum (string-to-number service))
	 (buf (get-buffer-create (concat "*" process-name "*"))))
    (or (zerop portnum) (setq service portnum))
    (make-comint
     process-name
     (cons host service))
    (set-buffer buf)
    (network-connection-mode)
    (network-connection-mode-setup host service)
    (pop-to-buffer buf)))

(defvar comint-input-ring)

(defun network-connection-reconnect  ()
  "Reconnect a network connection, preserving the old input ring.
This command uses `network-connection-service-alist', which see."
  (interactive)
  (let ((proc (get-buffer-process (current-buffer)))
	(old-comint-input-ring comint-input-ring)
	(host network-connection-host)
	(service network-connection-service))
    (if (not (or (not proc)
		 (eq (process-status proc) 'closed)))
	(message "Still connected")
      (goto-char (point-max))
      (insert (format "Reopening connection to %s\n" host))
      (network-connection host
			  (if (numberp service)
			      service
			    (cdr (assoc service network-connection-service-alist))))
      (and old-comint-input-ring
	   (setq comint-input-ring old-comint-input-ring)))))

(define-obsolete-function-alias 'net-utils-machine-at-point #'ffap-machine-at-point "29.1")
(define-obsolete-function-alias 'net-utils-url-at-point #'ffap-url-at-point "29.1")

(provide 'net-utils)

;;; net-utils.el ends here
