;;; thingatpt-tests.el --- tests for thing-at-point.  -*- lexical-binding:t -*-

;; Copyright (C) 2013-2023 Free Software Foundation, Inc.

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

;;; Code:

(require 'ert)
(require 'thingatpt)

(defvar thing-at-point-test-data
  '(("https://1.gnu.org" 1  url "https://1.gnu.org")
    ("https://2.gnu.org" 6 url "https://2.gnu.org")
    ("https://3.gnu.org" 19 url "https://3.gnu.org")
    ("https://4.gnu.org" 1  url "https://4.gnu.org")
    ("A geo URI (geo:3.14159,-2.71828)." 12 url "geo:3.14159,-2.71828")
    ("Visit https://5.gnu.org now." 5 url nil)
    ("Visit https://6.gnu.org now." 7 url "https://6.gnu.org")
    ("Visit https://7.gnu.org now." 22 url "https://7.gnu.org")
    ("Visit https://8.gnu.org now." 22 url "https://8.gnu.org")
    ("Visit https://9.gnu.org now." 25 url nil)
    ;; Invalid URIs
    ("<<<<" 2 url nil)
    ("<>" 1 url nil)
    ("<url:>" 1 url nil)
    ("http://" 1 url nil)
    ;; Invalid schema
    ("foo://www.gnu.org" 1 url nil)
    ("foohttp://www.gnu.org" 1 url nil)
    ;; Non alphanumeric characters can be found in URIs
    ("ftp://example.net/~foo!;#bar=baz&goo=bob" 3 url "ftp://example.net/~foo!;#bar=baz&goo=bob")
    ("bzr+ssh://user@example.net:5/a%20d,5" 34 url "bzr+ssh://user@example.net:5/a%20d,5")
    ;; IPv6 brackets enclosed in [markup]
    ("[http://[::1]:8000/foo]" 10 url "http://[::1]:8000/foo")
    ("[http://[fe08::7:8%eth0]]" 10 url "http://[fe08::7:8%eth0]")
    ;; <url:...> markup
    ("Url: <url:foo://1.example.com>..." 8 url "foo://1.example.com")
    ("Url: <url:foo://2.example.com>..." 30 url "foo://2.example.com")
    ("Url: <url:foo://www.gnu.org/a bc>..." 20 url "foo://www.gnu.org/a bc")
    ;; Hack used by thing-at-point: drop punctuation at end of URI.
    ("Go to https://www.gnu.org, for details" 7 url "https://www.gnu.org")
    ("Go to https://www.gnu.org." 24 url "https://www.gnu.org")
    ;; Standard URI delimiters
    ("Go to \"https://10.gnu.org\"." 8 url "https://10.gnu.org")
    ("Go to \"https://11.gnu.org/\"." 26 url "https://11.gnu.org/")
    ("Go to <https://12.gnu.org> now." 8 url "https://12.gnu.org")
    ("Go to <https://13.gnu.org> now." 24 url "https://13.gnu.org")
    ;; Parenthesis handling (non-standard)
    ("http://example.com/a(b)c" 21 url "http://example.com/a(b)c")
    ("http://example.com/a(b)" 21 url "http://example.com/a(b)")
    ("(http://example.com/abc)" 2 url "http://example.com/abc")
    ("This (http://example.com/a(b))" 7 url "http://example.com/a(b)")
    ("This (http://example.com/a(b))" 30 url "http://example.com/a(b)")
    ("This (http://example.com/a(b))" 5 url nil)
    ("http://example.com/ab)c" 4 url "http://example.com/ab)c")
    ;; URL markup, lacking schema
    ("<url:foo@example.com>" 1 url "mailto:foo@example.com")
    ("<url:ftp.example.net/abc/>" 1 url "ftp://ftp.example.net/abc/")
    ;; UUID, only hex is allowed
    ("01234567-89ab-cdef-ABCD-EF0123456789" 1 uuid "01234567-89ab-cdef-ABCD-EF0123456789")
    ("01234567-89ab-cdef-ABCD-EF012345678G" 1 uuid nil)
    ;; email addresses
    ("foo@example.com" 1 email "foo@example.com")
    ("f@example.com" 1 email "f@example.com")
    ("foo@example.com" 4 email "foo@example.com")
    ("foo@example.com" 5 email "foo@example.com")
    ("foo@example.com" 15 email "foo@example.com")
    ("foo@example.com" 16 email "foo@example.com")
    ("<foo@example.com>" 1 email "<foo@example.com>")
    ("<foo@example.com>" 4 email "<foo@example.com>")
    ("<foo@example.com>" 5 email "<foo@example.com>")
    ("<foo@example.com>" 16 email "<foo@example.com>")
    ("<foo@example.com>" 17 email "<foo@example.com>")
    ;; email adresses containing numbers
    ("foo1@example.com" 1 email "foo1@example.com")
    ("1foo@example.com" 1 email "1foo@example.com")
    ("11@example.com" 1 email "11@example.com")
    ("1@example.com" 1 email "1@example.com")
    ;; email adresses user portion containing dots
    ("foo.bar@example.com" 1 email "foo.bar@example.com")
    (".foobar@example.com" 1 email nil)
    (".foobar@example.com" 2 email "foobar@example.com")
    ;; email adresses domain portion containing dots and dashes
    ("foobar@.example.com" 1 email nil)
    ("foobar@-example.com" 1 email "foobar@-example.com")
    ;; These are illegal, but thingatpt doesn't yet handle them
    ;;    ("foo..bar@example.com" 1 email nil)
    ;;    ("foobar@.example.com" 1 email nil)
    ;;    ("foobar@example..com" 1 email nil)
    ;;    ("foobar.@example.com" 1 email nil)

    )
  "List of `thing-at-point' tests.
Each list element should have the form

  (STRING POS THING RESULT)

where STRING is a string of buffer contents, POS is the value of
point, THING is a symbol argument for `thing-at-point', and
RESULT should be the result of calling `thing-at-point' from that
position to retrieve THING.")

(ert-deftest thing-at-point-tests ()
  "Test the file-local variables implementation."
  (dolist (test thing-at-point-test-data)
    (with-temp-buffer
      (insert (nth 0 test))
      (goto-char (nth 1 test))
      (should (equal (thing-at-point (nth 2 test)) (nth 3 test))))))

;; See bug#24627 and bug#31772.
(ert-deftest thing-at-point-bounds-of-list-at-point ()
  (cl-macrolet ((with-test-buffer (str &rest body)
                  `(with-temp-buffer
                     (emacs-lisp-mode)
                     (insert ,str)
                     (search-backward "|")
                     (delete-char 1)
                     ,@body)))
    (let ((tests1
           '(("|(a \"b\" c)" (a "b" c))
             (";|(a \"b\" c)" (a "b" c) nil)
             ("|(a \"b\" c\n)" (a "b" c))
             ("\"|(a b c)\"" (a b c) nil)
             ("|(a ;(b c d)\ne)" (a e))
             ("(foo\n|(a ;(b c d)\ne) bar)" (foo (a e) bar))
             ("(foo\n|a ;(b c d)\ne bar)" (foo a e bar))
             ("(foo\n|(a \"(b c d)\"\ne) bar)" (foo (a "(b c d)" e) bar))
             ("(b\n|(a ;(foo c d)\ne) bar)" (b (a e) bar))
             ("(princ \"|(a b c)\")" (a b c) (princ "(a b c)"))
             ("(defun foo ()\n  \"Test function.\"\n  ;;|(a b)\n  nil)"
              (defun foo nil "Test function." nil)
              (defun foo nil "Test function." nil))))
          (tests2
           '(("|list-at-point" . "list-at-point")
             ("list-|at-point" . "list-at-point")
             ("list-at-point|" . nil)
             ("|(a b c)" . "(a b c)")
             ("(a b c)|" . nil))))
      (dolist (test tests1)
        (with-test-buffer (car test)
          (should (equal (list-at-point) (cl-second test)))
          (when (cddr test)
            (should (equal (list-at-point t) (cl-third test))))))
      (dolist (test tests2)
        (with-test-buffer (car test)
          (should (equal (thing-at-point 'list) (cdr test))))))))

(ert-deftest thing-at-point-url-in-comment ()
  (with-temp-buffer
    (c-mode)
    (insert "/* (http://foo/bar)\n(http://foo/bar(baz)) */\n")
    (goto-char 6)
    (should (equal (thing-at-point 'url) "http://foo/bar"))
    (goto-char 23)
    (should (equal (thing-at-point 'url) "http://foo/bar(baz)"))))

(ert-deftest thing-at-point-looking-at ()
  (with-temp-buffer
    (insert "1abcd 2abcd 3abcd")
    (goto-char (point-min))
    (let ((m2 (progn (search-forward "2abcd")
                     (match-data))))
      (goto-char (point-min))
      (search-forward "2ab")
      (should (thing-at-point-looking-at "2abcd"))
      (should (equal (match-data) m2)))))

(ert-deftest test-symbol-thing-1 ()
  (with-temp-buffer
    (insert "foo bar zot")
    (goto-char 4)
    (should (eq (symbol-at-point) 'foo))
    (forward-char 1)
    (should (eq (symbol-at-point) 'bar))
    (forward-char 1)
    (should (eq (symbol-at-point) 'bar))
    (forward-char 1)
    (should (eq (symbol-at-point) 'bar))
    (forward-char 1)
    (should (eq (symbol-at-point) 'bar))
    (forward-char 1)
    (should (eq (symbol-at-point) 'zot))))

(ert-deftest test-symbol-thing-2 ()
  (with-temp-buffer
    (insert " bar ")
    (goto-char (point-max))
    (should (eq (symbol-at-point) nil))
    (forward-char -1)
    (should (eq (symbol-at-point) 'bar))))

(ert-deftest test-symbol-thing-3 ()
  (with-temp-buffer
    (insert "bar")
    (goto-char 2)
    (should (eq (symbol-at-point) 'bar))))

(ert-deftest test-symbol-thing-4 ()
  (with-temp-buffer
    (insert "`[[`(")
    (goto-char 2)
    (should (eq (symbol-at-point) nil))))

(defun test--number (number pos)
  (with-temp-buffer
    (insert (format "%s\n" number))
    (goto-char (point-min))
    (forward-char pos)
    (number-at-point)))

(ert-deftest test-numbers-none ()
  (should (equal (test--number "foo" 0) nil)))

(ert-deftest test-numbers-decimal ()
  (should (equal (test--number "42" 0) 42))
  (should (equal (test--number "42" 1) 42))
  (should (equal (test--number "42" 2) 42)))

(ert-deftest test-numbers-hex-lisp ()
  (should (equal (test--number "#x42" 0) 66))
  (should (equal (test--number "#x42" 1) 66))
  (should (equal (test--number "#x42" 2) 66))
  (should (equal (test--number "#xf00" 0) 3840))
  (should (equal (test--number "#xf00" 1) 3840))
  (should (equal (test--number "#xf00" 2) 3840))
  (should (equal (test--number "#xf00" 3) 3840)))

(ert-deftest test-numbers-hex-c ()
  (should (equal (test--number "0x42" 0) 66))
  (should (equal (test--number "0x42" 1) 66))
  (should (equal (test--number "0x42" 2) 66))
  (should (equal (test--number "0xf00" 0) 3840))
  (should (equal (test--number "0xf00" 1) 3840))
  (should (equal (test--number "0xf00" 2) 3840))
  (should (equal (test--number "0xf00" 3) 3840)))

;;; thingatpt-tests.el ends here
