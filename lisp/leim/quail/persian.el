;;; persian.el --- Quail package for inputting Persian/Farsi keyboard	-*- coding: utf-8; lexical-binding: t -*-

;; Copyright (C) 2011-2023 Free Software Foundation, Inc.

;; Author: Mohsen BANAN <libre@mohsen.1.banan.byname.net>
;; URL: http://mohsen.1.banan.byname.net/contact

;; Keywords: multilingual, input method, Farsi, Persian, keyboard

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

;; This file contains a collection of input methods for
;; Persian languages (Farsi, Urdu, Pashto/Afghanic, ...)
;;
;; At this time, the following input methods are specified:
;;
;;  - (farsi-isiri-9149) Persian Keyboard based on Islamic Republic of Iran's ISIRI-9147
;;  - (farsi-transliterate-banan) An intuitive transliteration keyboard for Farsi
;;
;; Additional documentation for these input methods can be found at:
;;  http://www.persoarabic.org/PLPC/120036
;;

;;; Code:

(require 'quail)

;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; farsi-isiri-9147
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; The keyboard mapping defined here is based on:
;; فنّاوریِ اطلاعات - چیدمان حروف و علائم فارسی بر صفحه کلید رایانه
;; استاندارد ملی ایران ۹۱۴۷ − چاپ اول
;;
;; Institute of Standards and Industrial Research of Iran
;; Information Technology – Layout of Persian Letters and Symbols
;; on Computer Keyboards
;; ISIRI 9147 -- 1st edition
;; Published at: http://www.isiri.org/portal/files/std/9147.pdf
;; Re-Published at: http://www.persoarabic.org/Repub/fpf-isiri-9147
;;
;;
;; Specification of Iran's Persian Character Set is also relevant:
;; فنّاوریِ اطلاعات -- تبادل و شیوه‌ی نمایش اطلاعاتِ فارسی بر اساس یونی کُد
;; استاندارد ملی ایران ۶۲۱۹ −− نسخهی نهایی
;;
;; Institute of Standards and Industrial Research of Iran
;; Information Technology – Persian Information Interchange and Display Mechanism, using Unicode
;; ISIRI-6219 Final Version
;; Published at: http://www.isiri.org/portal/files/std/6219.htm
;; Re-Published at: http://www.persoarabic.org/Repub/fpf-isiri-6219
;;
;; Layers 1, 2 and 3 of ISIRI-9147 are fully implemented with the
;; exception of the Backslash, Alt-Backslash, Shift-Space and
;; Alt-Space keys.
;;
;; The Backslash key is used to replace کلید با دگر ساز راست‌ -- the Alt or
;; Meta key.
;;
;; Layer 3 is then entered with the Backslash key and Layer 3 is
;; implemented as two letter keys as specified in ISIRI-9147.
;;
;; The character corresponding to Backslash is entered with Backslash-Backslash.
;; Alt-Backslash has been moved to Backslash-r.
;; Alt-Space has been moved to Backslash-t.
;; Shift-Space has been moved to Backslash-y.
;;
;; With these modifications, farsi-isiri-9147 is a full implementation
;; of ISIRI-9147.  Additionally, these modifications allow for this
;; implementation to be ascii input stream based -- in addition to
;; being a keyboard layout.
;;
;; If a key on Layer 1 was reserved to replace دگر ساز راست‌ (the Alt
;; or Meta key), then farsi-isiri-9147 could have claimed full
;; compliance -- without the need for the above description. Perhaps
;; this can be considered a flaw in the base ISIRI-9147 specification
;; to be addressed in the next revision.
;;


(quail-define-package
 "farsi-isiri-9147" "Persian" " ف" nil
 "Farsi keyboard based on ISIRI-9147.
  See http://www.persoarabic.org/PLPC/120036 for additional documentation."
 nil t t t t nil nil nil nil nil t)

;; Note: the rows of keys below are enclosed in Left-To-Right Override
;; embedding, to prevent them from being reordered by the Emacs
;; display engine.


;; +----------------------------------------------------------------+
;; ‭| ۱! | ۲٬ | ۳٫ | ۴﷼ | ۵٪ | ۶× | ۷، | ۸* | ۹( | ۰) | -ـ | =+ | `÷ |‬
;; +----------------------------------------------------------------+
;;   ‭| ضْ| صٌ| ثٍ| قً| فُ| غِ| عَ| هّ| خ] | ح[ | ج{ | چ} |‬
;;   +------------------------------------------------------------+
;;    ‭| ش‌ؤ | س‌ئ | ی‌ي | ب‌إ | لأ | اآ | ت‌ة | ن« | م» | ک: | گ؛ | \| |‬
;;    +-----------------------------------------------------------+
;;      ‭| ظ‌ك | طٓ| زژ | رٰ| ذB | دٔ| پء | و< | .> | /؟ |‬
;;      +-------------------------------------------+

(quail-define-rules
 ("1" ?۱)
 ("2" ?۲)
 ("3" ?۳)
 ("4" ?۴)
 ("5" ?۵)
 ("6" ?۶)
 ("7" ?۷)
 ("8" ?۸)
 ("9" ?۹)
 ("0" ?۰)
 ("-" ?-)
 ("=" ?=)
 ("`" ?\u200D)      ;; ZWJ --  ZERO WIDTH JOINER اتصال مجازى
 ("q" ?ض)
 ("w" ?ص)
 ("e" ?ث)
 ("r" ?ق)
 ("t" ?ف)
 ("y" ?غ)
 ("u" ?ع)
 ("i" ?ه)
 ("o" ?خ)
 ("p" ?ح)
 ("[" ?ج)
 ("]" ?چ)
 ("a" ?ش)
 ("s" ?س)
 ("d" ?ی)
 ("f" ?ب)
 ("g" ?ل)
 ("h" ?ا)
 ("j" ?ت)
 ("k" ?ن)
 ("l" ?م)
 (";" ?ک)
 ("'" ?گ)

 ("z" ?ظ)
 ("x" ?ط)
 ("c" ?ز)
 ("v" ?ر)
 ("b" ?ذ)
 ("n" ?د)
 ("m" ?پ)
 ("," ?و)
 ("." ?.)
 ("/" ?/)

 ("!" ?!)
 ("@" ?٬)
 ("#" ?٫)
 ("$" ?﷼)
 ("%" ?٪)
 ("^" ?×)
 ("&" ?،)
 ("*" ?*)
 ("(" ?\))
 (")" ?\()
 ("_" ?ـ)
 ("+" ?+)
 ("~" ?÷)
 ("Q" ?ْ)  ;; ساکن فارسى
 ("W" ?ٌ)  ;; دو پيش فارسى -- تنوين رفع
 ("E" ?ٍ)  ;; دو زير فارسى -- تنوين جر
 ("R" ?ً)  ;; دو زبر فارسى -- تنوين نصب
 ("T" ?ُ)  ;; پيش فارسى -- ضمه
 ("Y" ?ِ)  ;; زير فارسى -- کسره
 ("U" ?َ)  ;; زبر فارسى -- فتحه
 ("I" ?ّ)  ;; تشديد فارسى
 ("O" ?\])
 ("P" ?\[)
 ("{" ?})
 ("}" ?{)
 ("A" ?ؤ)
 ("S" ?ئ)
 ("D" ?ي)
 ("F" ?إ)
 ("G" ?أ)
 ("H" ?آ)
 ("J" ?ة)
 ("K" ?»)
 ("L" ?«)
 (":" ?:)
 ("\"" ?؛)
 ("|" ?|)
 ("Z" ?ك)
 ("X" ?ٓ)
 ("C" ?ژ)
 ("V" ?ٰ)
 ("B" ?\u200C)     ;; ZWNJ -- ZERO WIDTH NON-JOINER  فاصلهٔ مجازى
 ("N" ?ٔ)  ;; همزه فارسى بالا
 ("M" ?ء)   ;;  harf farsi hamzeh
 ("<" ?>)
 (">" ?<)
 ("?" ?؟)

 ;; Level 3 Entered with \
 ;;
 ("\\" ?\\)  ;; خط اريب وارو
 ("\\\\" ?\\)
 ("\\~" ?\u007E)
 ("\\1" ?\u0060)
 ("\\2" ?\u0040)
 ("\\3" ?\u0023)
 ("\\4" ?\u0024)
 ("\\5" ?\u0025)
 ("\\6" ?\u005E)
 ("\\7" ?\u0026)
 ("\\8" ?\u2022)
 ("\\9" ?\u200E)
 ("\\0" ?\u200F)
 ("\\-" ?\u005F)
 ("\\+" ?\u2212)
 ("\\q" ?\u00B0)
 ;;\\w" ?\u0000)
 ("\\e" ?\u20AC)
 ("\\r" ?\u2010)       ;; replacement for Alt-BSL
 ("\\t" ?\u00A0)       ;; replacement for ALT-SPC
 ("\\y" ?\u200C)       ;; replacement for SHIFT-SPC
 ;;("\\u" ?\u0000)
 ("\\i" ?\u202D)
 ("\\o" ?\u202E)
 ("\\p" ?\u202C)
 ("\\[" ?\u202A)
 ("\\]" ?\u202B)
 ;;("\\a" ?\u0000)
 ;;("\\s" ?\u0000)
 ("\\d" ?\u0649)
 ;;("\\f" ?\u0000)
 ;;("\\g" ?\u0000)
 ("\\h" ?\u0671)
 ;;("\\j" ?\u0000)
 ("\\k" ?\uFD3E)
 ("\\l" ?\uFD3F)
 ("\\;" ?\u003B)
 ("\\'" ?\u0022)
 ;;("\\z" ?\u0000)
 ;;("\\x" ?\u0000)
 ;;("\\c" ?\u0000)
 ("\\v" ?\u0656)
 ("\\b" ?\u200D)
 ("\\n" ?\u0655)
 ("\\m" ?\u2026)
 ("\\," ?\u002C)
 ("\\." ?\u0027)
 ("\\?" ?\u003F)
 ;;("\\\\"   ?\u2010)    ;; Moved to backslash r to leave room for BSL-BSL
  )

;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; farsi-transliterate-banan
;;
;; Given a Qwerty keyboard, use Persian-to-Latin transliteration knowledge
;; to reverse transliterate in persian
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  See http://www.persoarabic.org/PLPC/120036 document for more complete
;;;  documentation of keyboard bindings and usage instructions.
;;;
;;
;; ISIRI-9147 Persian keyboard is generally not well suited for Iranian-Expatriates
;; working/living in the West.
;;
;; The qwerty keyboard is usually second nature to Persian speaking expatriates and they
;; don't want to learn/adapt to ISIRI-9147.  They expect software to adapt to them.
;;
;; That is what the ``Banan Multi-Character (Reverse) Transliteration Persian Input Method'' does.
;;
;; The typical profile of the user is assumed to be one who:
;;
;;  -  can write in farsi (not just speak it).
;;  -  is fully comfortable with a qwerty latin keyboard.
;;  -  is not familiar with isir-9147 and does not wish to be trained.
;;  -  communicates and writes in a mixed globish/persian -- not pure persian.
;;  -  is intuitively familiar with transliteration of farsi/persian into latin based on two letter
;;     phonetic mapping to persian characters (e.g., gh ق --  kh خ -- sh ش -- ch چ -- zh ژ.
;;
;; This transliteration keyboard is designed to be intuitive such that
;; mapping are easy and natural to remember for a persian writer.
;; It is designed to be equivalent in capability to farsi-isiri-9147
;; and provide for inputting all characters enumerated in ISIRI-6219.
;;
;; farsi-transliterate-banan is of course phonetic oriented.  But it is very different from
;; pinglish. Pinglish is word oriented where you sound out the word with latin letters --
;; including the vowels. farsi-transliterate-banan is letter oriented where you enter the
;; latin letter/letters closest to the persian letter. And usually omit vowels.
;;
;; For some persian characters there are multiple ways of inputting
;; the same character. For example both ``i'' and ``y'' produce ی.
;; For یک ``yk'', ``y'' is more natural and for این ``ain'', ``i'' is more natural.
;;
;; The more frequently used keys are mapped to lower case. The less frequently used letter moves to
;; upper case. For example: ``s'' is س and ``S'' is ص.  ``h'' is ه and ``H''
;; is ح.
;;
;; Multi-character input is based on \, &, and / prefix
;; characters. The letter 'h' is used as a postfix for the following two character mappings:
;; gh ق --  kh خ -- sh ش -- ch چ -- zh ژ  -- Th ة -- Yh ى.
;;
;;
;; Prefix letter \ is used for two character inputs when an alternate form of a letter
;; is desired for example '\-' is: '÷' when '-' is: '-'.
;;
;; Prefix letter & is used for multi-character inputs when special characters are
;; desired based on their abbreviate name. For example you can enter &lrm; to enter the
;; ``LEFT-TO-RIGHT MARK'' character.
;;
;; Prefix letter / is used to provide two characters. / is: ``ZERO WIDTH NON-JOINER''
;; and // is /.
;;
;; The letter 'h' is used in a number of two character postfix mappings,
;; for example ``sh'' ش. So if you need the sequence of ``s'' and ``h'' you
;; need to repeat the ``s''. For example: سهم = 's' 's' 'h' 'm'.
;;


(quail-define-package
 "farsi-transliterate-banan" "Persian" "ب" t
 "Intuitive transliteration keyboard layout for persian/farsi.
  See http://www.persoarabic.org/PLPC/120036 for additional documentation."
 nil t t t t nil nil nil nil nil t)


(quail-define-rules
;;;;;;;;;;;  isiri-6219 Table 5 -- جدول ۵ - حروِفِ اصلیِ فارسی
 ("W"  ?ء)        ;; hamzeh
 ("A"  ?آ)        ;; U+0622   & ARABIC LETTER ALEF WITH MADDA ABOVE & الف با  کلاه
 ("a"  ?ا)        ;; U+0627   & ARABIC LETTER ALEF  & الف
 ("\\a" ?أ)
 ("b"  ?ب)        ;; U+0628   & ARABIC LETTER BEH  &
 ("p"  ?پ)        ;; U+067e   & ARABIC LETTER PEH  &
 ("t"  ?ت)
 ("tt"  ?ت)
 ("c"  ?ث)
 ("cc"  ?ث)
 ("j"  ?ج)
 ("ch" ?چ)
 ("H"  ?ح)
 ("hh"  ?ح)
 ("kh" ?خ)
 ("d"  ?د)
 ("Z"  ?ذ)
 ("r"  ?ر)
 ("z"  ?ز)
 ("zz"  ?ز)
 ("zh" ?ژ)
 ("s"  ?س)
 ("ss"  ?س)
 ("sh" ?ش)
 ("S"  ?ص)
 ("x"  ?ض)
 ("T"  ?ط)
 ("TT"  ?ط)
 ("X"  ?ظ)
 ("w"  ?ع)
 ("q"  ?غ)
 ("G"  ?غ)
 ("Gh"  ?غ)
 ("GG"  ?غ)
 ("f"  ?ف)
 ("Q"  ?ق)
 ("gh" ?ق)
 ("k"  ?ک)
 ("kk"  ?ک)
 ("g"  ?گ)
 ("gg"  ?گ)
 ("l"  ?ل)
 ("m"  ?م)
 ("n"  ?ن)
 ("v"  ?و)
 ("u"  ?و)
 ("V" ?ؤ)
 ("h"  ?ه)
 ("y"  ?ی)
 ("i"  ?ی)
 ("I" ?ئ)


;;;;;;;;;;;  isiri-6219 Table 6 -- جدول ۶ - حروِفِ  عربی
 ("F" ?إ)
 ("D" ?\u0671)     ;; (insert-char #x0671)ٱ   named: حرفِ الفِ وصل
 ("K"  ?ك)         ;;  Arabic kaf
 ("Th" ?ة)         ;; ta marbuteh
 ("Y"  ?ي)
 ("YY"  ?ي)
 ("Yh"  ?ى)

;;;;;;;;;;;  isiri-6219 Table 4 -- جدول ۴ -  ارقام و علائم ریاضی
 ("0"  ?۰)
 ("1"  ?۱)
 ("2"  ?۲)
 ("3"  ?۳)
 ("4"  ?۴)
 ("5"  ?۵)
 ("6"  ?۶)
 ("7"  ?۷)
 ("8"  ?۸)
 ("9"  ?۹)

 ("\\/" ?\u066B)     ;; (insert-char #x066B)٫   named: ممیزِ فارسی
 ("\\," ?\u066C)     ;; (insert-char #x066C)٬   named: جداکننده‌ی هزارهای فارسی
 ("%" ?\u066A)       ;; (insert-char #x066A)٪   named: درصدِ فارسی
 ("+" ?\u002B)     ;; (insert-char #x002B)+   named: علامتِ به‌اضافه
 ("-" ?\u2212)     ;; (insert-char #x2212)−   named: علامتِ منها
 ("\\*" ?\u00D7)     ;; (insert-char #x00D7)×   named: علامتِ ضرب
 ("\\-" ?\u00F7)    ;; (insert-char #x00F7)÷   named: علامتِ تقسیم
 ("<" ?\u003C)     ;; (insert-char #x003C)<   named: علامتِ کوچکتر
 ("=" ?\u003D)     ;; (insert-char #x003D)=   named: علامتِ مساوی
 (">" ?\u003E)     ;; (insert-char #x003E)>   named: علامتِ بزرگتر


;;;;;;;;;;;  isiri-6219 Table 2 -- جدول ۲ -  علائم نقطه گذاریِ مشترک
 ;;; Space
 ("."  ?.)  ;;
 (":" ?\u003A)     ;; (insert-char #x003A):   named:
 ("!" ?\u0021)     ;; (insert-char #x0021)!   named:
 ("\\." ?\u2026)     ;; (insert-char #x2026)…   named:
 ("\\-" ?\u2010)     ;; (insert-char #x2010)‐   named:
 ("-" ?\u002D)     ;; (insert-char #x002D)-   named:
 ("|" ?|)
 ;;("\\\\" ?\)
 ("//" ?/)
 ("*" ?\u002A)     ;; (insert-char #x002A)*   named:
 ("(" ?\u0028)     ;; (insert-char #x0028)(   named:
 (")" ?\u0029)     ;; (insert-char #x0029))   named:
 ("[" ?\u005B)     ;; (insert-char #x005B)[   named:
 ("[" ?\u005D)     ;; (insert-char #x005D)]   named:
 ("{" ?\u007B)     ;; (insert-char #x007B){   named:
 ("}" ?\u007D)     ;; (insert-char #x007D)}   named:
 ("\\<" ?\u00AB)     ;; (insert-char #x00AB)«   named:
 ("\\>" ?\u00BB)     ;; (insert-char #x00BB)»   named:
 ("N" ?\u00AB)     ;; (insert-char #x00AB)«   named:
 ("M" ?\u00BB)     ;; (insert-char #x00BB)»   named:

;;;;;;;;;;;  isiri-6219 Table 3 -- جدول ۳ -  علائم نقطه گذاریِ فارسی
 ("," ?،)  ;; farsi
 (";"  ?؛)  ;;
 ("?"  ?؟)  ;; alamat soal
 ("_"  ?ـ)  ;;


;;;;;;;;;;;  isiri-6219 Table 1 -- جدول ۱ -  نویسه‌های کنترلی
 ;; LF
 ;; CR
 ("&zwnj;" ?\u200C) ;; (insert-char #x200C)‌   named: فاصله‌ی مجازی
 ("/" ?\u200C)      ;;
 ("&zwj;" ?\u200D)  ;; (insert-char #x200D)‍   named: اتصالِ مجازی
 ("J" ?\u200D)      ;;
 ("&lrm;" ?\u200E)  ;; (insert-char #x200E)‎   named: نشانه‌ی چپ‌به‌راست
 ("&rlm;" ?\u200F)  ;; (insert-char #x200F)‏   named: نشانه‌ی راست‌به‌چپ
 ("&ls;" ?\u2028)   ;; (insert-char #x2028)    named: جداکننده‌ی سطرها
 ("&ps;" ?\u2028)   ;; (insert-char #x2029)    named: جداکننده‌ی بندها
 ("&lre;" ?\u202A)   ;; (insert-char #x202A)‪   named: زیرمتنِ چپ‌به‌راست
 ("&rle;" ?\u202B)   ;; (insert-char #x202B)   named: زیرمتنِ راست‌به‌چپ
 ("&pdf;" ?\u202C)   ;; (insert-char #x202C)   named: پایانِ زیرمتن
 ("&lro;" ?\u202D)   ;; (insert-char #x202D)   named: زیرمتنِ اکیداً چپ‌به‌راست
 ("&rlo;" ?\u202D)   ;; (insert-char #x202E)   named: زیرمتنِ اکیداً راست‌به‌چپ
 ("&bom;" ?\uFEFF)   ;; (insert-char #xFEFF)   named: نشانه‌ی ترتیبِ بایت‌ها


;;;;;;;;;;;  isiri-6219 Table 7 -- جدول ۷ -  نشانه‌هایِ فارسی
 ("^"  ?َ)  ;; zbar ;; زبر فارسى
 ("e"  ?ِ)  ;; zir   زير فارسى
 ("o"  ?ُ)  ;; peesh ;; پيش فارسى -- ضمه
 ("E"  ?ٍ)  ;; eizan ;; دو زير فارسى -- تنوين جر
 ("#"  ?ً)  ;; دو زبر
 ("O" ?ٌ)  ;; دو پيش فارسى -- تنوين رفع
 ("~"  ?ّ)  ;; tashdid ;;  تشديد فارسى
 ("@" ?ْ)   ;; ساکن فارسى
 ("U" ?\u0653)  ;; (insert-char #x0653)ٓ   named: مدِ فارسی
 ("`" ?ٔ)  ;; همزه فارسى بالا
 ("C" ?\u0655)  ;; (insert-char #x0655)ٕ   named: همزه فارسى پایین
 ("$" ?\u0670)  ;; (insert-char #x0670)ٰ   named: الفِ مقصوره‌ی فارسی


;;;;;;;;;;;  isiri-6219 Table 8 - Forbidden Characters -- جدول ۸ - نویسه‌هایِ ممنوع
;;  ;; he ye (insert-char 1728)  (insert-char #x06c0) kills emacs-24.0.90
;; arabic digits 0-9


;;;;;;;  Latin Extensions
 ("\\" ?\\)  ;; خط اريب وارو
 ("\\\\" ?\\)
 ("\\~" ?~)
 ("\\@" ?@)
 ("\\#" ?#)
 ("\\$" ?\uFDFC)  ;; (insert-char #xFDFC)﷼   named:
 ("\\^" ?^)
 ("\\1" ?1)
 ("\\2" ?2)
 ("\\3" ?3)
 ("\\4" ?4)
 ("\\5" ?5)
 ("\\6" ?6)
 ("\\7" ?7)
 ("\\8" ?8)
 ("\\9" ?9)
 ("\\0" ?0)

)

;;; persian.el ends here
