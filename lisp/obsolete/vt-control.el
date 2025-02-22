;;; vt-control.el --- Common VTxxx control functions  -*- lexical-binding:t -*-

;; Copyright (C) 1993-1994, 2001-2023 Free Software Foundation, Inc.

;; Author: Rob Riepel <riepel@networking.stanford.edu>
;; Keywords: terminals
;; Obsolete-since: 29.1

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

;;  The functions contained in this file send various VT control codes
;;  to the terminal where Emacs is running.  The following functions are
;;  available.

;;    Function           Action

;;    vt-wide            set wide screen (132 characters)
;;    vt-narrow          set narrow screen (80 characters)
;;    vt-toggle-screen   toggle wide/narrow screen
;;    vt-keypad-on       set applications keypad on
;;    vt-keypad-off      set applications keypad off
;;    vt-numlock         toggle applications keypad on/off

;;; Usage:

;;  To use enable these functions, simply load this file.

;;  Note: vt-control makes no effort to determine how the terminal is
;;        initially set.  It assumes the terminal starts with a width
;;        of 80 characters and the applications keypad enabled.  Nor
;;        does vt-control try to restore the terminal when emacs is
;;        killed or suspended.

;;; Code:


;;;  Global variables

(defvar vt-applications-keypad-p t
  "If non-nil, keypad is in applications mode.")

(defvar vt-wide-p nil
  "If non-nil, the screen is 132 characters wide.")


;;;  Screen width functions.

(defun vt-wide nil
  "Set the screen 132 characters wide."
  (interactive)
  (send-string-to-terminal "\e[?3h")
  (set-frame-width (selected-frame) 132)
  (setq vt-wide-p t))

(defun vt-narrow nil
  "Set the screen 80 characters wide."
  (interactive)
  (send-string-to-terminal "\e[?3l")
  (set-frame-width (selected-frame) 80)
  (setq vt-wide-p nil))

(defun vt-toggle-screen nil
  "Toggle between 80 and 132 character screen width."
  (interactive)
  (if vt-wide-p (vt-narrow) (vt-wide)))


;;;  Applications keypad functions.

(defun vt-keypad-on (&optional tell)
  "Turn on the VT applications keypad."
  (interactive "p")
  (send-string-to-terminal "\e=")
  (setq vt-applications-keypad-p t)
  (if tell (message "Applications keypad enabled.")))

(defun vt-keypad-off (&optional tell)
  "Turn off the VT applications keypad."
  (interactive "p")
  (send-string-to-terminal "\e>")
  (setq vt-applications-keypad-p nil)
  (if tell (message "Applications keypad disabled.")))

(defun vt-numlock (&optional tell)
  "Toggle VT application keypad on and off."
  (interactive "p")
  (if vt-applications-keypad-p
      (vt-keypad-off tell)
    (vt-keypad-on tell)))

(provide 'vt-control)

;;; vt-control.el ends here
