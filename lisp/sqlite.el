;;; sqlite.el --- Functions for interacting with sqlite3 databases  -*- lexical-binding: t; -*-

;; Copyright (C) 2021-2023 Free Software Foundation, Inc.

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

;;

;;; Code:

(defmacro with-sqlite-transaction (db &rest body)
  "Execute BODY while holding a transaction for DB."
  (declare (indent 1) (debug (form body)))
  (let ((db-var (gensym))
        (func-var (gensym)))
    `(let ((,db-var ,db)
           (,func-var (lambda () ,@body)))
       (if (fboundp 'sqlite-transaction)
           (unwind-protect
               (progn
                 (sqlite-transaction ,db-var)
                 (funcall ,func-var))
             (sqlite-commit ,db-var))
         (funcall ,func-var)))))

(provide 'sqlite)

;;; sqlite.el ends here
