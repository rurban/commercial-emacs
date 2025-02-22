;;; ja-dic-cnv.el --- convert a Japanese dictionary (SKK-JISYO.L) to Emacs Lisp  -*- lexical-binding: t; -*-

;; Copyright (C) 2001-2023 Free Software Foundation, Inc.

;; Copyright (C) 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004,
;;   2005, 2006, 2007, 2008, 2009, 2010, 2011
;;   National Institute of Advanced Industrial Science and Technology (AIST)
;;   Registration Number H14PRO021

;; Keywords: i18n, mule, multilingual, Japanese

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

;; SKK is a Japanese input method running on Mule created by Masahiko
;; Sato <masahiko@sato.riec.tohoku.ac.jp>.  Here we provide utilities
;; to handle a dictionary distributed with SKK so that a different
;; input method (e.g. quail-japanese) can utilize the dictionary.

;; The format of SKK dictionary is quite simple.  Each line has the
;; form "KANASTRING /CONV1/CONV2/.../" which means KANASTRING (仮名文
;; 字列) can be converted to one of CONVi.  CONVi is a Kanji (漢字)
;; and Kana (仮名) mixed string.
;;
;; KANASTRING may have a trailing ASCII letter for Okurigana (送り仮名)
;; information.  For instance, the trailing letter `k' means that one
;; of the following Okurigana is allowed: かきくけこ.  So, in that
;; case, the string "KANASTRINGく" can be converted to one of "CONV1く",
;; CONV2く, ...

;;; Code:

(require 'generate-lisp-file)

;; Name of a file to generate from SKK dictionary.
(defvar ja-dic-filename "ja-dic.el")

(defun skkdic-convert-okuri-ari (skkbuf buf)
  (byte-compile-info "Processing OKURI-ARI entries" t)
  (goto-char (point-min))
  (with-current-buffer buf
    (insert ";; Setting okuri-ari entries.\n"
	    "(skkdic-set-okuri-ari\n"))
  (while (not (eobp))
    (if (/= (following-char) ?>)
	(let ((from (point))
	      (to (line-end-position)))
	  (with-current-buffer buf
	    (insert-buffer-substring skkbuf from to)
	    (beginning-of-line)
	    (insert "\"")
	    (search-forward " ")
	    (delete-char 1)		; delete the first '/'
	    (let ((p (point)))
	      (end-of-line)
	      (delete-char -1)		; delete the last '/'
	      (subst-char-in-region p (point) ?/ ? 'noundo))
	    (insert "\"\n"))))

    (forward-line 1))
  (with-current-buffer buf
    (insert ")\n\n")))

(defconst skkdic-postfix-list '(skkdic-postfix-list))

(defconst skkdic-postfix-data
  '(("いき" "行")
    ("がかり" "係")
    ("がく" "学")
    ("がわ" "川")
    ("しゃ" "社")
    ("しゅう" "集")
    ("しょう" "賞" "城")
    ("じょう" "城")
    ("せん" "線")
    ("だけ" "岳")
    ("ちゃく" "着")
    ("てん" "店")
    ("とうげ" "峠")
    ("どおり" "通り")
    ("やま" "山")
    ("ばし" "橋")
    ("はつ" "発")
    ("もく" "目")
    ("ゆき" "行")))

(defun skkdic-convert-postfix (_skkbuf buf)
  (byte-compile-info "Processing POSTFIX entries" t)
  (goto-char (point-min))
  (with-current-buffer buf
    (insert ";; Setting postfix entries.\n"
	    "(skkdic-set-postfix\n"))

  ;; Initialize SKKDIC-POSTFIX-LIST by predefined data
  ;; SKKDIC-POSTFIX-DATA.
  (with-current-buffer buf
    (let ((l skkdic-postfix-data)
	  kana candidates entry)
      (while l
	(setq kana (car (car l)) candidates (cdr (car l)))
	(insert "\"" kana)
	(while candidates
	  (insert " " (car candidates))
	  (setq entry (lookup-nested-alist (car candidates)
					   skkdic-postfix-list nil nil t))
	  (if (consp (car entry))
	      (setcar entry (cons kana (car entry)))
	    (set-nested-alist (car candidates) (list kana)
			      skkdic-postfix-list))
	  (setq candidates (cdr candidates)))
	(insert "\"\n")
	(setq l (cdr l)))))

  ;; Search postfix entries.
  (while (re-search-forward "^[#<>?]\\(\\cH+\\) " nil t)
    (let ((kana (match-string-no-properties 1))
	  str candidates)
      (while (looking-at "/[#0-9 ]*\\([^/\n]*\\)/")
        (setq str (match-string-no-properties 1))
	(if (not (member str candidates))
	    (setq candidates (cons str candidates)))
	(goto-char (match-end 1)))
      (with-current-buffer buf
	(insert "\"" kana)
	(while candidates
	  (insert " " (car candidates))
	  (let ((entry (lookup-nested-alist (car candidates)
					    skkdic-postfix-list nil nil t)))
	    (if (consp (car entry))
		(if (not (member kana (car entry)))
		    (setcar entry (cons kana (car entry))))
	      (set-nested-alist (car candidates) (list kana)
				skkdic-postfix-list)))
	  (setq candidates (cdr candidates)))
	(insert "\"\n"))))
  (with-current-buffer buf
    (insert ")\n\n")))

(defconst skkdic-prefix-list '(skkdic-prefix-list))

(defun skkdic-convert-prefix (_skkbuf buf)
  (byte-compile-info "Processing PREFIX entries" t)
  (goto-char (point-min))
  (with-current-buffer buf
    (insert ";; Setting prefix entries.\n"
	    "(skkdic-set-prefix\n"))
  (save-excursion
    (while (re-search-forward "^\\(\\cH+\\)[<>?] " nil t)
      (let ((kana (match-string-no-properties 1))
	    str candidates)
	(while (looking-at "/\\([^/\n]+\\)/")
          (setq str (match-string-no-properties 1))
	  (if (not (member str candidates))
	      (setq candidates (cons str candidates)))
	  (goto-char (match-end 1)))
	(with-current-buffer buf
	  (insert "\"" kana)
	  (while candidates
	    (insert " " (car candidates))
	    (set-nested-alist (car candidates) kana skkdic-prefix-list)
	    (setq candidates (cdr candidates)))
	  (insert "\"\n")))))
  (with-current-buffer buf
    (insert ")\n\n")))

;; FROM and TO point the head and tail of "/J../J../.../".
(defun skkdic-get-candidate-list (from to)
  (let (candidates)
    (goto-char from)
    (while (re-search-forward "/[^/ \n]+" to t)
      (setq candidates (cons (buffer-substring-no-properties
                              (1+ (match-beginning 0)) (match-end 0))
			     candidates)))
    candidates))

;; Return entry for STR from nested alist ALIST.
(defsubst skkdic-get-entry (str alist)
  (car (lookup-nested-alist str alist nil nil t)))


(defconst skkdic-word-list '(skkdic-word-list))

;; Return t if substring of STR (between FROM and TO) can be broken up
;; to chunks all of which can be derived from another entry in SKK
;; dictionary.  SKKBUF is the buffer where the original SKK dictionary
;; is visited, KANA is the current entry for STR.  FIRST is t only if
;; this is called at top level.

(defun skkdic-breakup-string (skkbuf kana str from to &optional first)
  (let ((len (- to from)))
    (or (and (>= len 2)
	     (let ((min-idx (+ from 2))
		   (idx (if first (1- to ) to))
		   (found nil))
	       (while (and (not found) (>= idx min-idx))
		 (let ((kana2-list (skkdic-get-entry
				    (substring str from idx)
				    skkdic-word-list)))
		   (if (or (and (consp kana2-list)
				(let (;; (kana-len (length kana))
				      kana2)
				  (catch 'skkdic-tag
				    (while kana2-list
				      (setq kana2 (car kana2-list))
				      (if (string-match kana2 kana)
					  (throw 'skkdic-tag t))
				      (setq kana2-list (cdr kana2-list)))))
				(or (= idx to)
				    (skkdic-breakup-string skkbuf kana str
							   idx to)))
			   (and (stringp kana2-list)
				(string-match kana2-list kana)))
		       (setq found t)
		     (setq idx (1- idx)))))
	       found))
	(and first
	     (> len 2)
	     (let ((kana2 (skkdic-get-entry
			   (substring str from (1+ from))
			   skkdic-prefix-list)))
	       (and (stringp kana2)
		    (eq (string-match kana2 kana) 0)))
	     (skkdic-breakup-string skkbuf kana str (1+ from) to))
	(and (not first)
	     (>= len 1)
	     (let ((kana2-list (skkdic-get-entry
				(substring str from to)
				skkdic-postfix-list)))
	       (and (consp kana2-list)
		    (let (kana2)
		      (catch 'skkdic-tag
			(while kana2-list
			  (setq kana2 (car kana2-list))
			  (if (string= kana2
				       (substring kana (- (length kana2))))
			      (throw 'skkdic-tag t))
			  (setq kana2-list (cdr kana2-list)))))))))))

;; Return list of candidates which excludes some from CANDIDATES.
;; Excluded candidates can be derived from another entry.

(defconst skkdic--japanese-category-set (make-category-set "j"))

(defun skkdic-reduced-candidates (skkbuf kana candidates)
  (let (elt l)
    (while candidates
      (setq elt (car candidates))
      (if (or (= (length elt) 1)
	      (and (bool-vector-subsetp
                    skkdic--japanese-category-set
                    (char-category-set (aref elt 0)))
		   (not (skkdic-breakup-string skkbuf kana elt 0 (length elt)
					       'first))))
	  (setq l (cons elt l)))
      (setq candidates (cdr candidates)))
    (nreverse l)))

(defvar skkdic-okuri-nasi-entries (list nil))
(defvar skkdic-okuri-nasi-entries-count 0)

(defun skkdic-collect-okuri-nasi ()
  (save-excursion
    (let ((progress (make-progress-reporter
                     (byte-compile-info "Collecting OKURI-NASI entries" t)
                     (point) (point-max)
                     nil 10)))
      (while (re-search-forward "^\\(\\cH+\\) \\(/\\cj.*\\)/$"
				nil t)
        (let ((kana (match-string-no-properties 1))
	      (candidates (skkdic-get-candidate-list (match-beginning 2)
						     (match-end 2))))
	  (setq skkdic-okuri-nasi-entries
		(cons (cons kana candidates) skkdic-okuri-nasi-entries))
          (progress-reporter-update progress (point))
	  (while candidates
	    (let ((entry (lookup-nested-alist (car candidates)
					      skkdic-word-list nil nil t)))
	      (if (consp (car entry))
		  (setcar entry (cons kana (car entry)))
		(set-nested-alist (car candidates) (list kana)
				  skkdic-word-list)))
            (setq candidates (cdr candidates)))))
      (setq skkdic-okuri-nasi-entries-count (length skkdic-okuri-nasi-entries))
      (progress-reporter-done progress))))

(defun skkdic-convert-okuri-nasi (skkbuf buf &optional no-reduction)
  (with-current-buffer buf
    (insert ";; Setting okuri-nasi entries.\n"
	    "(skkdic-set-okuri-nasi\n")
    (let ((l (nreverse skkdic-okuri-nasi-entries))
          (progress (make-progress-reporter
                     (byte-compile-info "Processing OKURI-NASI entries" t)
                     0 skkdic-okuri-nasi-entries-count
                     nil 10))
          (count 0))
      (while l
	(let ((kana (car (car l)))
	      (candidates (cdr (car l))))
          (setq count (1+ count))
          (progress-reporter-update progress count)
	  (if (setq candidates
                    (if no-reduction
                        candidates
                      (skkdic-reduced-candidates skkbuf kana candidates)))
	      (progn
		(insert "\"" kana)
		(while candidates
		  (insert " " (car candidates))
		  (setq candidates (cdr candidates)))
		(insert "\"\n"))))
	(setq l (cdr l)))
      (progress-reporter-done progress))
    (insert ")\n\n")))

(defun skkdic-convert (filename &optional dirname no-reduction)
  "Generate Emacs Lisp file from Japanese dictionary file FILENAME.
The format of the dictionary file should be the same as SKK dictionaries.
Saves the output as `ja-dic-filename', in directory DIRNAME (if specified).
If NO-REDUCTION is non-nil, do not reduce the dictionary vocabulary."
  (interactive "FSKK dictionary file: ")
  (let* ((skkbuf (get-buffer-create " *skkdic-unannotated*"))
	 (buf (get-buffer-create "*skkdic-work*")))
    ;; Set skkbuf to an unannotated copy of the dictionary.
    (with-current-buffer skkbuf
      (let ((coding-system-for-read 'euc-japan))
        (insert-file-contents (expand-file-name filename)))
      (re-search-forward "^[^;]")
      (while (re-search-forward ";[^\n/]*/" nil t)
	(replace-match "/" t t)))
    ;; Setup and generate the header part of working buffer.
    (with-current-buffer buf
      (erase-buffer)
      (buffer-disable-undo)
      (generate-lisp-file-heading ja-dic-filename 'skkdic-convert :code nil)
      (insert ";; Original SKK dictionary file: "
	      (file-relative-name (expand-file-name filename) dirname)
	      "\n\n"
	      ";; This file is NOT part of GNU Emacs.\n\n"
	      ";;; Start of the header of the original SKK dictionary.\n\n")
      (set-buffer skkbuf)
      (goto-char 1)
      (let (pos)
	(search-forward ";; okuri-ari")
	(forward-line 1)
	(setq pos (point))
	(set-buffer buf)
	(insert-buffer-substring skkbuf 1 pos))
      (insert "\n"
	      ";;; Code:\n\n(eval-when-compile (require 'ja-dic-cnv))\n\n")

      ;; Generate the body part of working buffer.
      (set-buffer skkbuf)
      (let ((from (point))
	    to)
	;; Convert okuri-ari entries.
	(search-forward ";; okuri-nasi")
	(beginning-of-line)
	(setq to (point))
	(narrow-to-region from to)
	(skkdic-convert-okuri-ari skkbuf buf)
	(widen)

	;; Convert okuri-nasi postfix entries.
	(goto-char to)
	(forward-line 1)
	(setq from (point))
	(re-search-forward "^\\cH")
	(setq to (match-beginning 0))
	(narrow-to-region from to)
	(skkdic-convert-postfix skkbuf buf)
	(widen)

	;; Convert okuri-nasi prefix entries.
	(goto-char to)
	(skkdic-convert-prefix skkbuf buf)

	;;
	(skkdic-collect-okuri-nasi)

	;; Convert okuri-nasi general entries.
	(skkdic-convert-okuri-nasi skkbuf buf no-reduction)

	;; Postfix
	(with-current-buffer buf
	  (goto-char (point-max))
          (generate-lisp-file-trailer ja-dic-filename :compile t)))

      ;; Save the working buffer.
      (set-buffer buf)
      (set-visited-file-name (expand-file-name ja-dic-filename dirname) t)
      (set-buffer-file-coding-system 'utf-8)
      (save-buffer 0))
    (kill-buffer skkbuf)
    (switch-to-buffer buf)))

(defun batch-skkdic-convert ()
  "Run `skkdic-convert' on the files remaining on the command line.
Use this from the command line, with `-batch';
it won't work in an interactive Emacs.
For example, invoke:
  % emacs -batch -l ja-dic-cnv -f batch-skkdic-convert SKK-JISYO.L
to generate  \"ja-dic.el\" from SKK dictionary file \"SKK-JISYO.L\".
To get complete usage, invoke:
 % emacs -batch -l ja-dic-cnv -f batch-skkdic-convert -h"
  (defvar command-line-args-left)	; Avoid compiler warning.
  (if (not noninteractive)
      (error "`batch-skkdic-convert' should be used only with -batch"))
  (if (string= (car command-line-args-left) "-h")
      (progn
	(message "To convert SKK-JISYO.L into skkdic.el:")
	(message "  %% emacs -batch -l ja-dic-cnv -f batch-skkdic-convert SKK-JISYO.L")
	(message "To convert SKK-JISYO.L into DIR/ja-dic.el:")
	(message "  %% emacs -batch -l ja-dic-cnv -f batch-skkdic-convert -dir DIR SKK-JISYO.L")
        (message "To convert SKK-JISYO.L into skkdic.el without reducing dictionary vocabulary:")
        (message "  %% emacs -batch -l ja-dic-cnv -f batch-skkdic-convert --no-reduction SKK-JISYO.L"))
    (let (targetdir filename no-reduction)
      (if (string= (car command-line-args-left) "-dir")
	  (progn
	    (setq command-line-args-left (cdr command-line-args-left))
	    (setq targetdir (expand-file-name (car command-line-args-left)))
	    (setq command-line-args-left (cdr command-line-args-left))))
      (if (string= (car command-line-args-left) "--no-reduction")
          (progn
	    (setq no-reduction t)
	    (setq command-line-args-left (cdr command-line-args-left))))
      (setq filename (expand-file-name (car command-line-args-left)))
      (skkdic-convert filename targetdir no-reduction)))
  (kill-emacs 0))


;; The following macros are expanded at byte-compiling time so that
;; compiled code can be loaded quickly.

(defun skkdic-get-kana-compact-codes (kana)
  (let* ((len (length kana))
	 (vec (make-vector len 0))
	 (i 0)
	 ch)
    (while (< i len)
      (setq ch (aref kana i))
      (aset vec i
	    (if (< ch 128)		; CH is an ASCII letter for OKURIGANA,
		(- ch)			;  represented by a negative code.
	      (if (= ch ?ー)		; `ー' is represented by 0.
		  0
		(- (logand (encode-char ch 'japanese-jisx0208) #xFF) 32))))
      (setq i (1+ i)))
    vec))

(defun skkdic-extract-conversion-data (entry)
  (string-match "^\\cj+[a-z]* " entry)
  (let ((kana (substring entry (match-beginning 0) (1- (match-end 0))))
	(i (match-end 0))
	candidates)
    (while (string-match "[^ ]+" entry i)
      (setq candidates (cons (match-string-no-properties 0 entry) candidates))
      (setq i (match-end 0)))
    (cons (skkdic-get-kana-compact-codes kana) candidates)))

(defmacro skkdic-set-okuri-ari (&rest entries)
  `(defconst skkdic-okuri-ari
     ',(let ((l entries)
	     (map '(skkdic-okuri-ari))
	     entry)
	 (while l
	   (setq entry (skkdic-extract-conversion-data (car l)))
	   (set-nested-alist (car entry) (cdr entry) map)
	   (setq l (cdr l)))
	 map)))

(defmacro skkdic-set-postfix (&rest entries)
  `(defconst skkdic-postfix
     ',(let ((l entries)
	     (map '(nil))
	     (longest 1)
	     len entry)
	 (while l
	   (setq entry (skkdic-extract-conversion-data (car l)))
	   (setq len (length (car entry)))
	   (if (> len longest)
	       (setq longest len))
	   (let ((entry2 (lookup-nested-alist (car entry) map nil nil t)))
	     (if (consp (car entry2))
		 (let ((conversions (cdr entry)))
		   (while conversions
		     (if (not (member (car conversions) (car entry2)))
			 (setcar entry2 (cons (car conversions) (car entry2))))
		     (setq conversions (cdr conversions))))
	       (set-nested-alist (car entry) (cdr entry) map)))
	   (setq l (cdr l)))
	 (setcar map longest)
	 map)))

(defmacro skkdic-set-prefix (&rest entries)
  `(defconst skkdic-prefix
     ',(let ((l entries)
	     (map '(nil))
	     (longest 1)
	     len entry)
	 (while l
	   (setq entry (skkdic-extract-conversion-data (car l)))
	   (setq len (length (car entry)))
	   (if (> len longest)
	       (setq longest len))
	   (let ((entry2 (lookup-nested-alist (car entry) map len nil t)))
	     (if (consp (car entry2))
		 (let ((conversions (cdr entry)))
		   (while conversions
		     (if (not (member (car conversions) (car entry2)))
			 (setcar entry2 (cons (car conversions) (car entry2))))
		     (setq conversions (cdr conversions))))
	       (set-nested-alist (car entry) (cdr entry) map len)))
	   (setq l (cdr l)))
	 (setcar map longest)
	 map)))

(defmacro skkdic-set-okuri-nasi (&rest entries)
  `(defconst skkdic-okuri-nasi
     ',(let ((l entries)
	     (map '(skdic-okuri-nasi))
             (progress (make-progress-reporter
                        (byte-compile-info "Extracting OKURI-NASI entries")
                        0 (length entries)))
	     (count 0)
	     entry)
	 (while l
           (progress-reporter-update progress (setq count (1+ count)))
	   (setq entry (skkdic-extract-conversion-data (car l)))
	   (set-nested-alist (car entry) (cdr entry) map)
	   (setq l (cdr l)))
         (progress-reporter-done progress)
	 map)))

(provide 'ja-dic-cnv)
;;; ja-dic-cnv.el ends here
