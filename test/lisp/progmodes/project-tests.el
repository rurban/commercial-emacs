;;; project-tests.el --- tests for project.el -*- lexical-binding: t; -*-

;; Copyright (C) 2021-2023 Free Software Foundation, Inc.

;; Keywords:

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

;; Unit tests for progmodes/project.el.

;;; Code:

(require 'project)

(require 'cl-lib)
(require 'ert)
(require 'ert-x) ; ert-with-temp-directory
(require 'grep)
(require 'xref)
(require 'vc)
(require 'vc-git)
(require 'log-edit)


(ert-deftest project/quoted-directory ()
  "Check that `project-files' and `project-find-regexp' deal with
quoted directory names (Bug#47799)."
  (skip-unless (executable-find find-program))
  (skip-unless (executable-find "xargs"))
  (skip-unless (executable-find "grep"))
  (ert-with-temp-directory directory
    (let ((default-directory directory)
          (project-find-functions nil)
          (project-list-file
           (expand-file-name "projects" directory))
          (project (cons 'transient (file-name-quote directory)))
          (file (expand-file-name "file" directory)))
      (add-hook 'project-find-functions (lambda (_dir) project))
      (should (eq (project-current) project))
      (write-region "contents" nil file nil nil nil 'excl)
      (should (equal (project-files project)
                     (list (file-name-quote file))))
      (let* ((references nil)
             (xref-search-program 'grep)
             (xref-show-xrefs-function
              (lambda (fetcher _display)
                (push (funcall fetcher) references))))
        (project-find-regexp "tent")
        (pcase references
          (`((,item))
           ;; FIXME: Shouldn't `xref-match-item' be a subclass of
           ;; `xref-item'?
           (should (cl-typep item '(or xref-item xref-match-item)))
           (should (file-equal-p
                    (xref-location-group (xref-item-location item))
                    file)))
          (otherwise
           (ert-fail (format-message "Unexpected references: %S"
                                     otherwise))))))))

(cl-defstruct project-tests--trivial root ignores)

(cl-defmethod project-root ((project project-tests--trivial))
  (project-tests--trivial-root project))

(cl-defmethod project-ignores ((project project-tests--trivial) _dir)
  (project-tests--trivial-ignores project))

(ert-deftest project-ignores ()
  "Check that `project-files' correctly ignores the files
returned by `project-ignores' if the root directory is a
directory name (Bug#48471)."
  (skip-unless (executable-find find-program))
  (ert-with-temp-directory dir
    (make-empty-file (expand-file-name "some-file" dir))
    (make-empty-file (expand-file-name "ignored-file" dir))
    (let* ((project (make-project-tests--trivial
                     :root (file-name-as-directory dir)
                     :ignores '("./ignored-file")))
           (files (project-files project))
           (relative-files
            (cl-loop for file in files
                     collect (file-relative-name file dir))))
      (should (equal relative-files '("some-file"))))))

(ert-deftest project-ignores-bug-50240 ()
  "Check that `project-files' does not ignore all files.
When `project-ignores' includes a name matching project dir."
  (skip-unless (executable-find find-program))
  (ert-with-temp-directory dir
    (make-empty-file (expand-file-name "some-file" dir))
    (let* ((project (make-project-tests--trivial
                     :root (file-name-as-directory dir)
                     :ignores (list (file-name-nondirectory
                                     (directory-file-name dir)))))
           (files (project-files project)))
      (should (equal files
                     (list
                      (expand-file-name "some-file" dir)))))))

(ert-deftest project-switch-project-extant-buffer ()
  "Prefer just switching to the mru buffer of the switched-to project instead
of bringing up `project-switch-commands'."
  (ert-with-temp-directory dir1
    (ert-with-temp-directory dir2
      (cl-letf* ((switch-called-on nil)
                 ((symbol-function 'switch-project)
                  (lambda () (interactive)
                    (setq default-directory project-current-directory-override
                          switch-called-on default-directory)))
                 (project1 (make-project-tests--trivial :root dir1))
                 (project2 (make-project-tests--trivial :root dir2))
                 (project-find-functions
                  (list (lambda (dir)
                          (assoc-default dir (list (cons dir1 project1)
                                                   (cons dir2 project2))))))
                 (project-switch-commands 'switch-project)
                 (buf2 (progn
                         (make-empty-file (expand-file-name "some-file" dir2))
                         (find-file-noselect (expand-file-name "some-file" dir2)))))
        (project-switch-project dir1)
        (should (equal switch-called-on dir1))
        (should (equal (project-root (project-current)) dir1))
        (project-switch-project dir2)
        (should (equal switch-called-on dir1)) ; not dir2
        (should (equal (project-root (project-current)) dir2))
        (should (eq (current-buffer) buf2))
        (let (kill-buffer-query-functions) (kill-buffer buf2))))))

(ert-deftest project-assume-mru-project ()
  "Assume mru project if default-directory is project-less."
  (ert-with-temp-directory dir1
    (ert-with-temp-directory dir2
      (cl-letf* ((project2 (make-project-tests--trivial :root dir2))
                 (project-find-functions
                  (list (lambda (dir)
                          (assoc-default dir (list (cons dir2 project2))))))
                 (buf1 (progn
                         (make-empty-file (expand-file-name "some-file" dir1))
                         (find-file-noselect (expand-file-name "some-file" dir1))))
                 (buf2 (progn
                         (make-empty-file (expand-file-name "some-file" dir2))
                         (find-file-noselect (expand-file-name "some-file" dir2))))
                 ((symbol-function 'read-buffer)
                  (lambda (_prompt other-buffer &rest _args)
                    other-buffer)))
        (switch-to-buffer buf1)
        (should-not (project-current))
        (switch-to-buffer buf2)
        (should (equal (project-root (project-current)) dir2))
        (switch-to-buffer buf1)
        (call-interactively #'project-switch-to-buffer)
        (should (eq (current-buffer) buf2))
        (let (kill-buffer-query-functions)
          (kill-buffer buf1)
          (kill-buffer buf2))))))

(defmacro project-tests--mock-repo (&rest body)
  (declare (indent defun))
  `(let* ((dir (make-temp-file "project-tests" t))
          (default-directory dir))
     (unwind-protect
         (progn
           (vc-git-create-repo)
           (vc-git-command nil 0 nil "config" "--add" "user.name" "frou")
           (vc-git-command nil 0 nil "config" "--add" "user.email" "frou@frou.org")
           ,@body)
       (delete-directory dir t))))

(ert-deftest project-implicit-project-absorption ()
  "Running a project command should register the project without further ado."
  (skip-unless (executable-find vc-git-program))
  (project-tests--mock-repo
    (with-temp-file "foo")
    (condition-case err
        (progn
          (vc-git-register (split-string "foo"))
          (vc-git-checkin (split-string "foo") "No-Verify: yes
his fooness")
          (vc-git-checkout nil (vc-git--rev-parse "HEAD")))
      (error (signal (car err) (with-current-buffer "*vc*" (buffer-string)))))
    (cl-letf (((symbol-function 'read-buffer)
               (lambda (&rest _args)
                 (current-buffer))))
      (switch-to-buffer (find-file-noselect "foo"))
      (should-not (cl-some (lambda (project)
                             (equal default-directory (car project)))
                           project--list))
      (call-interactively #'project-switch-to-buffer)
      (should (cl-some (lambda (project)
                         (equal default-directory (car project)))
                       project--list)))))

(defvar project-tests--this-file (or (bound-and-true-p byte-compile-current-file)
                                     (and load-in-progress load-file-name)
                                     buffer-file-name))

(ert-deftest project-vc-recognizes-git ()
  "Check that Git repository is detected."
  (skip-unless (eq (vc-responsible-backend default-directory) 'Git))
  (let* ((vc-handled-backends '(Git))
         (dir (file-name-directory project-tests--this-file))
         (_ (vc-file-clearprops dir))
         (project-vc-extra-root-markers nil)
         (project (project-current nil dir))
         (this-file "test/lisp/progmodes/project-tests.el"))
    (should-not (null project))
    (should (string-prefix-p this-file (file-relative-name
                                        project-tests--this-file
                                        (project-root project))))))

(ert-deftest project-vc-extra-root-markers-supports-wildcards ()
  "Check that one can add wildcard entries."
  (skip-unless (eq (vc-responsible-backend default-directory) 'Git))
  (let* ((dir (file-name-directory project-tests--this-file))
         (_ (vc-file-clearprops dir))
         (project-vc-extra-root-markers '("files-x-tests.*"))
         (project (project-current nil dir)))
    (should project)
    (should (string-match-p "/test/lisp/\\'" (project-root project)))))

(ert-deftest project-vc-supports-project-in-different-dir ()
  "Check that it picks up dir-locals settings from somewhere else."
  (skip-unless (eq (vc-responsible-backend default-directory) 'Git))
  (let* ((dir (ert-resource-directory))
         (_ (vc-file-clearprops dir))
         (project-vc-extra-root-markers '(".dir-locals.el"))
         (project (project-current nil dir)))
    (should-not (null project))
    (should (string-match-p "/test/lisp/progmodes/project-resources/\\'" (project-root project)))
    (should (member "etc" (project-ignores project dir)))
    (should (equal '(".dir-locals.el" "foo")
                   (mapcar #'file-name-nondirectory (project-files project))))))

(ert-deftest project-vc-nonexistent-directory-no-error ()
  "Check that is doesn't error out when the current dir does not exist."
  (skip-unless (eq (vc-responsible-backend default-directory) 'Git))
  (let* ((dir (expand-file-name "foo-456/bar/" (ert-resource-directory)))
         (_ (vc-file-clearprops dir))
         (project-vc-extra-root-markers '(".dir-locals.el"))
         (project (project-current nil dir)))
    (should-not (null project))
    (should (string-match-p "/test/lisp/progmodes/project-resources/\\'" (project-root project)))))

;;; project-tests.el ends here
