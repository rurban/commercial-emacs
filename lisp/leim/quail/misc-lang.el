;;; misc-lang.el --- Quail package for inputting Miscellaneous characters  -*- lexical-binding: t; -*-

;; Copyright (C) 2022-2023 Free Software Foundation, Inc.

;; Author: समीर सिंह Sameer Singh <lumarzeli30@gmail.com>
;; Keywords: multilingual, input method, i18n, Miscellaneous

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

;; Input methods for Miscellaneous languages.

;;; Code:

(require 'quail)

(quail-define-package
 "hanifi-rohingya" "Hanifi Rohingya" "𐴌𐴟" t "Hanifi Rohingya phonetic input method.

 `\\=`' is used to switch levels instead of Alt-Gr.
" nil t t t t nil nil nil nil nil t)

(quail-define-rules
 ("1"  ?𐴱)
 ("`1" ?1)
 ("2"  ?𐴲)
 ("`2" ?2)
 ("3"  ?𐴳)
 ("`3" ?3)
 ("4"  ?𐴴)
 ("`4" ?4)
 ("5"  ?𐴵)
 ("`5" ?5)
 ("6"  ?𐴶)
 ("`6" ?6)
 ("7"  ?𐴷)
 ("`7" ?7)
 ("8"  ?𐴸)
 ("`8" ?8)
 ("9"  ?𐴹)
 ("`9" ?9)
 ("0"  ?𐴰)
 ("`0" ?0)
 ("q"  ?𐴄)
 ("w"  ?𐴋)
 ("W"  ?𐴍)
 ("e"  ?𐴠)
 ("E"  ?𐴤)
 ("r"  ?𐴌)
 ("R"  ?𐴥)
 ("t"  ?𐴃)
 ("T"  ?𐴦)
 ("y"  ?𐴘)
 ("Y"  ?𐴙)
 ("u"  ?𐴟)
 ("U"  ?𐴧)
 ("i"  ?𐴞)
 ("o"  ?𐴡)
 ("p"  ?𐴂)
 ("a"  ?𐴀)
 ("A"  ?𐴝)
 ("s"  ?𐴏)
 ("S"  ?𐴐)
 ("d"  ?𐴊)
 ("f"  ?𐴉)
 ("F"  ?𐴢)
 ("g"  ?𐴒)
 ("h"  ?𐴇)
 ("j"  ?𐴅)
 ("k"  ?𐴑)
 ("K"  ?𐴈)
 ("l"  ?𐴓)
 ("z"  ?𐴎)
 ("c"  ?𐴆)
 ("C"  #x200C) ; ZWNJ
 ("v"  ?𐴖)
 ("V"  ?𐴗)
 ("`v" ?𐴜)
 ("b"  ?𐴁)
 ("n"  ?𐴕)
 ("N"  ?𐴚)
 ("`n" ?𐴛)
 ("`N" ?𐴣)
 ("m"  ?𐴔))

;; The Kharoṣṭhī input method is based on the Kyoto-Harvard input
;; conventions for Sanskrit, extended for Kharoṣṭhī special characters.
;; Author: Stefan Baums <baums@gandhari.org>.
(quail-define-package
 "kharoshthi" "Kharoshthi" "𐨑" nil
 "Kharoṣṭhī input method." nil t t t t nil nil nil nil nil t)

(quail-define-rules
 ("a" ["𐨀"])
 ("i" ["𐨀𐨁"])
 ("u" ["𐨀𐨂"])
 ("R" ["𐨀𐨃"])
 ("e" ["𐨀𐨅"])
 ("o" ["𐨀𐨆"])

 ("k" ["𐨐𐨿"])
 ("ka" ["𐨐"])
 ("ki" ["𐨐𐨁"])
 ("ku" ["𐨐𐨂"])
 ("kR" ["𐨐𐨃"])
 ("ke" ["𐨐𐨅"])
 ("ko" ["𐨐𐨆"])
 ("k_" ["𐨐𐨹𐨿"])
 ("k_a" ["𐨐𐨹"])
 ("k_i" ["𐨐𐨹𐨁"])
 ("k_u" ["𐨐𐨹𐨂"])
 ("k_R" ["𐨐𐨹𐨃"])
 ("k_e" ["𐨐𐨹𐨅"])
 ("k_o" ["𐨐𐨹𐨆"])
 ("k=" ["𐨐𐨿𐨸"])
 ("k=a" ["𐨐𐨸"])
 ("k=i" ["𐨐𐨸𐨁"])
 ("k=u" ["𐨐𐨸𐨂"])
 ("k=R" ["𐨐𐨸𐨃"])
 ("k=e" ["𐨐𐨸𐨅"])
 ("k=o" ["𐨐𐨸𐨆"])
 ("k_=" ["𐨐𐨹𐨿𐨸"])
 ("k_=a" ["𐨐𐨹𐨸"])
 ("k_=i" ["𐨐𐨹𐨸𐨁"])
 ("k_=u" ["𐨐𐨹𐨸𐨂"])
 ("k_=R" ["𐨐𐨹𐨸𐨃"])
 ("k_=e" ["𐨐𐨹𐨸𐨅"])
 ("k_=o" ["𐨐𐨹𐨸𐨆"])

 ("kh" ["𐨑𐨿"])
 ("kha" ["𐨑"])
 ("khi" ["𐨑𐨁"])
 ("khu" ["𐨑𐨂"])
 ("khR" ["𐨑𐨃"])
 ("khe" ["𐨑𐨅"])
 ("kho" ["𐨑𐨆"])
 ("kh_" ["𐨑𐨹𐨿"])
 ("kh_a" ["𐨑𐨹"])
 ("kh_i" ["𐨑𐨹𐨁"])
 ("kh_u" ["𐨑𐨹𐨂"])
 ("kh_R" ["𐨑𐨹𐨃"])
 ("kh_e" ["𐨑𐨹𐨅"])
 ("kh_o" ["𐨑𐨹𐨆"])
 ("kh=" ["𐨑𐨿𐨸"])
 ("kh=a" ["𐨑𐨸"])
 ("kh=i" ["𐨑𐨸𐨁"])
 ("kh=u" ["𐨑𐨸𐨂"])
 ("kh=R" ["𐨑𐨸𐨃"])
 ("kh=e" ["𐨑𐨸𐨅"])
 ("kh=o" ["𐨑𐨸𐨆"])
 ("kh_=" ["𐨑𐨹𐨿𐨸"])
 ("kh_=a" ["𐨑𐨹𐨸"])
 ("kh_=i" ["𐨑𐨹𐨸𐨁"])
 ("kh_=u" ["𐨑𐨹𐨸𐨂"])
 ("kh_=R" ["𐨑𐨹𐨸𐨃"])
 ("kh_=e" ["𐨑𐨹𐨸𐨅"])
 ("kh_=o" ["𐨑𐨹𐨸𐨆"])

 ("g" ["𐨒𐨿"])
 ("ga" ["𐨒"])
 ("gi" ["𐨒𐨁"])
 ("gu" ["𐨒𐨂"])
 ("gR" ["𐨒𐨃"])
 ("ge" ["𐨒𐨅"])
 ("go" ["𐨒𐨆"])
 ("g_" ["𐨒𐨹𐨿"])
 ("g_a" ["𐨒𐨹"])
 ("g_i" ["𐨒𐨹𐨁"])
 ("g_u" ["𐨒𐨹𐨂"])
 ("g_R" ["𐨒𐨹𐨃"])
 ("g_e" ["𐨒𐨹𐨅"])
 ("g_o" ["𐨒𐨹𐨆"])
 ("g=" ["𐨒𐨿𐨸"])
 ("g=a" ["𐨒𐨸"])
 ("g=i" ["𐨒𐨸𐨁"])
 ("g=u" ["𐨒𐨸𐨂"])
 ("g=R" ["𐨒𐨸𐨃"])
 ("g=e" ["𐨒𐨸𐨅"])
 ("g=o" ["𐨒𐨸𐨆"])
 ("g_=" ["𐨒𐨹𐨿𐨸"])
 ("g_=a" ["𐨒𐨹𐨸"])
 ("g_=i" ["𐨒𐨹𐨸𐨁"])
 ("g_=u" ["𐨒𐨹𐨸𐨂"])
 ("g_=R" ["𐨒𐨹𐨸𐨃"])
 ("g_=e" ["𐨒𐨹𐨸𐨅"])
 ("g_=o" ["𐨒𐨹𐨸𐨆"])

 ("gh" ["𐨓𐨿"])
 ("gha" ["𐨓"])
 ("ghi" ["𐨓𐨁"])
 ("ghu" ["𐨓𐨂"])
 ("ghR" ["𐨓𐨃"])
 ("ghe" ["𐨓𐨅"])
 ("gho" ["𐨓𐨆"])
 ("gh_" ["𐨓𐨹𐨿"])
 ("gh_a" ["𐨓𐨹"])
 ("gh_i" ["𐨓𐨹𐨁"])
 ("gh_u" ["𐨓𐨹𐨂"])
 ("gh_R" ["𐨓𐨹𐨃"])
 ("gh_e" ["𐨓𐨹𐨅"])
 ("gh_o" ["𐨓𐨹𐨆"])
 ("gh=" ["𐨓𐨿𐨸"])
 ("gh=a" ["𐨓𐨸"])
 ("gh=i" ["𐨓𐨸𐨁"])
 ("gh=u" ["𐨓𐨸𐨂"])
 ("gh=R" ["𐨓𐨸𐨃"])
 ("gh=e" ["𐨓𐨸𐨅"])
 ("gh=o" ["𐨓𐨸𐨆"])
 ("gh_=" ["𐨓𐨹𐨿𐨸"])
 ("gh_=a" ["𐨓𐨹𐨸"])
 ("gh_=i" ["𐨓𐨹𐨸𐨁"])
 ("gh_=u" ["𐨓𐨹𐨸𐨂"])
 ("gh_=R" ["𐨓𐨹𐨸𐨃"])
 ("gh_=e" ["𐨓𐨹𐨸𐨅"])
 ("gh_=o" ["𐨓𐨹𐨸𐨆"])

 ("c" ["𐨕𐨿"])
 ("ca" ["𐨕"])
 ("ci" ["𐨕𐨁"])
 ("cu" ["𐨕𐨂"])
 ("cR" ["𐨕𐨃"])
 ("ce" ["𐨕𐨅"])
 ("co" ["𐨕𐨆"])
 ("c_" ["𐨕𐨹𐨿"])
 ("c_a" ["𐨕𐨹"])
 ("c_i" ["𐨕𐨹𐨁"])
 ("c_u" ["𐨕𐨹𐨂"])
 ("c_R" ["𐨕𐨹𐨃"])
 ("c_e" ["𐨕𐨹𐨅"])
 ("c_o" ["𐨕𐨹𐨆"])
 ("c=" ["𐨕𐨿𐨸"])
 ("c=a" ["𐨕𐨸"])
 ("c=i" ["𐨕𐨸𐨁"])
 ("c=u" ["𐨕𐨸𐨂"])
 ("c=R" ["𐨕𐨸𐨃"])
 ("c=e" ["𐨕𐨸𐨅"])
 ("c=o" ["𐨕𐨸𐨆"])
 ("c_=" ["𐨕𐨹𐨿𐨸"])
 ("c_=a" ["𐨕𐨹𐨸"])
 ("c_=i" ["𐨕𐨹𐨸𐨁"])
 ("c_=u" ["𐨕𐨹𐨸𐨂"])
 ("c_=R" ["𐨕𐨹𐨸𐨃"])
 ("c_=e" ["𐨕𐨹𐨸𐨅"])
 ("c_=o" ["𐨕𐨹𐨸𐨆"])

 ("ch" ["𐨖𐨿"])
 ("cha" ["𐨖"])
 ("chi" ["𐨖𐨁"])
 ("chu" ["𐨖𐨂"])
 ("chR" ["𐨖𐨃"])
 ("che" ["𐨖𐨅"])
 ("cho" ["𐨖𐨆"])
 ("ch_" ["𐨖𐨹𐨿"])
 ("ch_a" ["𐨖𐨹"])
 ("ch_i" ["𐨖𐨹𐨁"])
 ("ch_u" ["𐨖𐨹𐨂"])
 ("ch_R" ["𐨖𐨹𐨃"])
 ("ch_e" ["𐨖𐨹𐨅"])
 ("ch_o" ["𐨖𐨹𐨆"])
 ("ch=" ["𐨖𐨿𐨸"])
 ("ch=a" ["𐨖𐨸"])
 ("ch=i" ["𐨖𐨸𐨁"])
 ("ch=u" ["𐨖𐨸𐨂"])
 ("ch=R" ["𐨖𐨸𐨃"])
 ("ch=e" ["𐨖𐨸𐨅"])
 ("ch=o" ["𐨖𐨸𐨆"])
 ("ch_=" ["𐨖𐨹𐨿𐨸"])
 ("ch_=a" ["𐨖𐨹𐨸"])
 ("ch_=i" ["𐨖𐨹𐨸𐨁"])
 ("ch_=u" ["𐨖𐨹𐨸𐨂"])
 ("ch_=R" ["𐨖𐨹𐨸𐨃"])
 ("ch_=e" ["𐨖𐨹𐨸𐨅"])
 ("ch_=o" ["𐨖𐨹𐨸𐨆"])

 ("j" ["𐨗𐨿"])
 ("ja" ["𐨗"])
 ("ji" ["𐨗𐨁"])
 ("ju" ["𐨗𐨂"])
 ("jR" ["𐨗𐨃"])
 ("je" ["𐨗𐨅"])
 ("jo" ["𐨗𐨆"])
 ("j_" ["𐨗𐨹𐨿"])
 ("j_a" ["𐨗𐨹"])
 ("j_i" ["𐨗𐨹𐨁"])
 ("j_u" ["𐨗𐨹𐨂"])
 ("j_R" ["𐨗𐨹𐨃"])
 ("j_e" ["𐨗𐨹𐨅"])
 ("j_o" ["𐨗𐨹𐨆"])
 ("j=" ["𐨗𐨿𐨸"])
 ("j=a" ["𐨗𐨸"])
 ("j=i" ["𐨗𐨸𐨁"])
 ("j=u" ["𐨗𐨸𐨂"])
 ("j=R" ["𐨗𐨸𐨃"])
 ("j=e" ["𐨗𐨸𐨅"])
 ("j=o" ["𐨗𐨸𐨆"])
 ("j_=" ["𐨗𐨹𐨿𐨸"])
 ("j_=a" ["𐨗𐨹𐨸"])
 ("j_=i" ["𐨗𐨹𐨸𐨁"])
 ("j_=u" ["𐨗𐨹𐨸𐨂"])
 ("j_=R" ["𐨗𐨹𐨸𐨃"])
 ("j_=e" ["𐨗𐨹𐨸𐨅"])
 ("j_=o" ["𐨗𐨹𐨸𐨆"])

 ("jh" ["𐨰𐨿"])
 ("jha" ["𐨰"])
 ("jhi" ["𐨰𐨁"])
 ("jhu" ["𐨰𐨂"])
 ("jhR" ["𐨰𐨃"])
 ("jhe" ["𐨰𐨅"])
 ("jho" ["𐨰𐨆"])
 ("jh_" ["𐨰𐨹𐨿"])
 ("jh_a" ["𐨰𐨹"])
 ("jh_i" ["𐨰𐨹𐨁"])
 ("jh_u" ["𐨰𐨹𐨂"])
 ("jh_R" ["𐨰𐨹𐨃"])
 ("jh_e" ["𐨰𐨹𐨅"])
 ("jh_o" ["𐨰𐨹𐨆"])
 ("jh=" ["𐨰𐨿𐨸"])
 ("jh=a" ["𐨰𐨸"])
 ("jh=i" ["𐨰𐨸𐨁"])
 ("jh=u" ["𐨰𐨸𐨂"])
 ("jh=R" ["𐨰𐨸𐨃"])
 ("jh=e" ["𐨰𐨸𐨅"])
 ("jh=o" ["𐨰𐨸𐨆"])
 ("jh_=" ["𐨰𐨹𐨿𐨸"])
 ("jh_=a" ["𐨰𐨹𐨸"])
 ("jh_=i" ["𐨰𐨹𐨸𐨁"])
 ("jh_=u" ["𐨰𐨹𐨸𐨂"])
 ("jh_=R" ["𐨰𐨹𐨸𐨃"])
 ("jh_=e" ["𐨰𐨹𐨸𐨅"])
 ("jh_=o" ["𐨰𐨹𐨸𐨆"])

 ("J" ["𐨙𐨿"])
 ("Ja" ["𐨙"])
 ("Ji" ["𐨙𐨁"])
 ("Ju" ["𐨙𐨂"])
 ("JR" ["𐨙𐨃"])
 ("Je" ["𐨙𐨅"])
 ("Jo" ["𐨙𐨆"])
 ("J_" ["𐨙𐨹𐨿"])
 ("J_a" ["𐨙𐨹"])
 ("J_i" ["𐨙𐨹𐨁"])
 ("J_u" ["𐨙𐨹𐨂"])
 ("J_R" ["𐨙𐨹𐨃"])
 ("J_e" ["𐨙𐨹𐨅"])
 ("J_o" ["𐨙𐨹𐨆"])
 ("J=" ["𐨙𐨿𐨸"])
 ("J=a" ["𐨙𐨸"])
 ("J=i" ["𐨙𐨸𐨁"])
 ("J=u" ["𐨙𐨸𐨂"])
 ("J=R" ["𐨙𐨸𐨃"])
 ("J=e" ["𐨙𐨸𐨅"])
 ("J=o" ["𐨙𐨸𐨆"])
 ("J_=" ["𐨙𐨹𐨿𐨸"])
 ("J_=a" ["𐨙𐨹𐨸"])
 ("J_=i" ["𐨙𐨹𐨸𐨁"])
 ("J_=u" ["𐨙𐨹𐨸𐨂"])
 ("J_=R" ["𐨙𐨹𐨸𐨃"])
 ("J_=e" ["𐨙𐨹𐨸𐨅"])
 ("J_=o" ["𐨙𐨹𐨸𐨆"])

 ("T" ["𐨚𐨿"])
 ("Ta" ["𐨚"])
 ("Ti" ["𐨚𐨁"])
 ("Tu" ["𐨚𐨂"])
 ("TR" ["𐨚𐨃"])
 ("Te" ["𐨚𐨅"])
 ("To" ["𐨚𐨆"])
 ("T_" ["𐨚𐨹𐨿"])
 ("T_a" ["𐨚𐨹"])
 ("T_i" ["𐨚𐨹𐨁"])
 ("T_u" ["𐨚𐨹𐨂"])
 ("T_R" ["𐨚𐨹𐨃"])
 ("T_e" ["𐨚𐨹𐨅"])
 ("T_o" ["𐨚𐨹𐨆"])
 ("T=" ["𐨚𐨿𐨸"])
 ("T=a" ["𐨚𐨸"])
 ("T=i" ["𐨚𐨸𐨁"])
 ("T=u" ["𐨚𐨸𐨂"])
 ("T=R" ["𐨚𐨸𐨃"])
 ("T=e" ["𐨚𐨸𐨅"])
 ("T=o" ["𐨚𐨸𐨆"])
 ("T_=" ["𐨚𐨹𐨿𐨸"])
 ("T_=a" ["𐨚𐨹𐨸"])
 ("T_=i" ["𐨚𐨹𐨸𐨁"])
 ("T_=u" ["𐨚𐨹𐨸𐨂"])
 ("T_=R" ["𐨚𐨹𐨸𐨃"])
 ("T_=e" ["𐨚𐨹𐨸𐨅"])
 ("T_=o" ["𐨚𐨹𐨸𐨆"])

 ("Th" ["𐨛𐨿"])
 ("Tha" ["𐨛"])
 ("Thi" ["𐨛𐨁"])
 ("Thu" ["𐨛𐨂"])
 ("ThR" ["𐨛𐨃"])
 ("The" ["𐨛𐨅"])
 ("Tho" ["𐨛𐨆"])
 ("Th_" ["𐨛𐨹𐨿"])
 ("Th_a" ["𐨛𐨹"])
 ("Th_i" ["𐨛𐨹𐨁"])
 ("Th_u" ["𐨛𐨹𐨂"])
 ("Th_R" ["𐨛𐨹𐨃"])
 ("Th_e" ["𐨛𐨹𐨅"])
 ("Th_o" ["𐨛𐨹𐨆"])
 ("Th=" ["𐨛𐨿𐨸"])
 ("Th=a" ["𐨛𐨸"])
 ("Th=i" ["𐨛𐨸𐨁"])
 ("Th=u" ["𐨛𐨸𐨂"])
 ("Th=R" ["𐨛𐨸𐨃"])
 ("Th=e" ["𐨛𐨸𐨅"])
 ("Th=o" ["𐨛𐨸𐨆"])
 ("Th_=" ["𐨛𐨹𐨿𐨸"])
 ("Th_=a" ["𐨛𐨹𐨸"])
 ("Th_=i" ["𐨛𐨹𐨸𐨁"])
 ("Th_=u" ["𐨛𐨹𐨸𐨂"])
 ("Th_=R" ["𐨛𐨹𐨸𐨃"])
 ("Th_=e" ["𐨛𐨹𐨸𐨅"])
 ("Th_=o" ["𐨛𐨹𐨸𐨆"])

 ("D" ["𐨜𐨿"])
 ("Da" ["𐨜"])
 ("Di" ["𐨜𐨁"])
 ("Du" ["𐨜𐨂"])
 ("DR" ["𐨜𐨃"])
 ("De" ["𐨜𐨅"])
 ("Do" ["𐨜𐨆"])
 ("D_" ["𐨜𐨹𐨿"])
 ("D_a" ["𐨜𐨹"])
 ("D_i" ["𐨜𐨹𐨁"])
 ("D_u" ["𐨜𐨹𐨂"])
 ("D_R" ["𐨜𐨹𐨃"])
 ("D_e" ["𐨜𐨹𐨅"])
 ("D_o" ["𐨜𐨹𐨆"])
 ("D=" ["𐨜𐨿𐨸"])
 ("D=a" ["𐨜𐨸"])
 ("D=i" ["𐨜𐨸𐨁"])
 ("D=u" ["𐨜𐨸𐨂"])
 ("D=R" ["𐨜𐨸𐨃"])
 ("D=e" ["𐨜𐨸𐨅"])
 ("D=o" ["𐨜𐨸𐨆"])
 ("D_=" ["𐨜𐨹𐨿𐨸"])
 ("D_=a" ["𐨜𐨹𐨸"])
 ("D_=i" ["𐨜𐨹𐨸𐨁"])
 ("D_=u" ["𐨜𐨹𐨸𐨂"])
 ("D_=R" ["𐨜𐨹𐨸𐨃"])
 ("D_=e" ["𐨜𐨹𐨸𐨅"])
 ("D_=o" ["𐨜𐨹𐨸𐨆"])

 ("Dh" ["𐨝𐨿"])
 ("Dha" ["𐨝"])
 ("Dhi" ["𐨝𐨁"])
 ("Dhu" ["𐨝𐨂"])
 ("DhR" ["𐨝𐨃"])
 ("Dhe" ["𐨝𐨅"])
 ("Dho" ["𐨝𐨆"])
 ("Dh_" ["𐨝𐨹𐨿"])
 ("Dh_a" ["𐨝𐨹"])
 ("Dh_i" ["𐨝𐨹𐨁"])
 ("Dh_u" ["𐨝𐨹𐨂"])
 ("Dh_R" ["𐨝𐨹𐨃"])
 ("Dh_e" ["𐨝𐨹𐨅"])
 ("Dh_o" ["𐨝𐨹𐨆"])
 ("Dh=" ["𐨝𐨿𐨸"])
 ("Dh=a" ["𐨝𐨸"])
 ("Dh=i" ["𐨝𐨸𐨁"])
 ("Dh=u" ["𐨝𐨸𐨂"])
 ("Dh=R" ["𐨝𐨸𐨃"])
 ("Dh=e" ["𐨝𐨸𐨅"])
 ("Dh=o" ["𐨝𐨸𐨆"])
 ("Dh_=" ["𐨝𐨹𐨿𐨸"])
 ("Dh_=a" ["𐨝𐨹𐨸"])
 ("Dh_=i" ["𐨝𐨹𐨸𐨁"])
 ("Dh_=u" ["𐨝𐨹𐨸𐨂"])
 ("Dh_=R" ["𐨝𐨹𐨸𐨃"])
 ("Dh_=e" ["𐨝𐨹𐨸𐨅"])
 ("Dh_=o" ["𐨝𐨹𐨸𐨆"])

 ("N" ["𐨞𐨿"])
 ("Na" ["𐨞"])
 ("Ni" ["𐨞𐨁"])
 ("Nu" ["𐨞𐨂"])
 ("NR" ["𐨞𐨃"])
 ("Ne" ["𐨞𐨅"])
 ("No" ["𐨞𐨆"])
 ("N_" ["𐨞𐨹𐨿"])
 ("N_a" ["𐨞𐨹"])
 ("N_i" ["𐨞𐨹𐨁"])
 ("N_u" ["𐨞𐨹𐨂"])
 ("N_R" ["𐨞𐨹𐨃"])
 ("N_e" ["𐨞𐨹𐨅"])
 ("N_o" ["𐨞𐨹𐨆"])
 ("N=" ["𐨞𐨿𐨸"])
 ("N=a" ["𐨞𐨸"])
 ("N=i" ["𐨞𐨸𐨁"])
 ("N=u" ["𐨞𐨸𐨂"])
 ("N=R" ["𐨞𐨸𐨃"])
 ("N=e" ["𐨞𐨸𐨅"])
 ("N=o" ["𐨞𐨸𐨆"])
 ("N_=" ["𐨞𐨹𐨿𐨸"])
 ("N_=a" ["𐨞𐨹𐨸"])
 ("N_=i" ["𐨞𐨹𐨸𐨁"])
 ("N_=u" ["𐨞𐨹𐨸𐨂"])
 ("N_=R" ["𐨞𐨹𐨸𐨃"])
 ("N_=e" ["𐨞𐨹𐨸𐨅"])
 ("N_=o" ["𐨞𐨹𐨸𐨆"])

 ("t" ["𐨟𐨿"])
 ("ta" ["𐨟"])
 ("ti" ["𐨟𐨁"])
 ("tu" ["𐨟𐨂"])
 ("tR" ["𐨟𐨃"])
 ("te" ["𐨟𐨅"])
 ("to" ["𐨟𐨆"])
 ("t_" ["𐨟𐨹𐨿"])
 ("t_a" ["𐨟𐨹"])
 ("t_i" ["𐨟𐨹𐨁"])
 ("t_u" ["𐨟𐨹𐨂"])
 ("t_R" ["𐨟𐨹𐨃"])
 ("t_e" ["𐨟𐨹𐨅"])
 ("t_o" ["𐨟𐨹𐨆"])
 ("t=" ["𐨟𐨿𐨸"])
 ("t=a" ["𐨟𐨸"])
 ("t=i" ["𐨟𐨸𐨁"])
 ("t=u" ["𐨟𐨸𐨂"])
 ("t=R" ["𐨟𐨸𐨃"])
 ("t=e" ["𐨟𐨸𐨅"])
 ("t=o" ["𐨟𐨸𐨆"])
 ("t_=" ["𐨟𐨹𐨿𐨸"])
 ("t_=a" ["𐨟𐨹𐨸"])
 ("t_=i" ["𐨟𐨹𐨸𐨁"])
 ("t_=u" ["𐨟𐨹𐨸𐨂"])
 ("t_=R" ["𐨟𐨹𐨸𐨃"])
 ("t_=e" ["𐨟𐨹𐨸𐨅"])
 ("t_=o" ["𐨟𐨹𐨸𐨆"])

 ("th" ["𐨠𐨿"])
 ("tha" ["𐨠"])
 ("thi" ["𐨠𐨁"])
 ("thu" ["𐨠𐨂"])
 ("thR" ["𐨠𐨃"])
 ("the" ["𐨠𐨅"])
 ("tho" ["𐨠𐨆"])
 ("th_" ["𐨠𐨹𐨿"])
 ("th_a" ["𐨠𐨹"])
 ("th_i" ["𐨠𐨹𐨁"])
 ("th_u" ["𐨠𐨹𐨂"])
 ("th_R" ["𐨠𐨹𐨃"])
 ("th_e" ["𐨠𐨹𐨅"])
 ("th_o" ["𐨠𐨹𐨆"])
 ("th=" ["𐨠𐨿𐨸"])
 ("th=a" ["𐨠𐨸"])
 ("th=i" ["𐨠𐨸𐨁"])
 ("th=u" ["𐨠𐨸𐨂"])
 ("th=R" ["𐨠𐨸𐨃"])
 ("th=e" ["𐨠𐨸𐨅"])
 ("th=o" ["𐨠𐨸𐨆"])
 ("th_=" ["𐨠𐨹𐨿𐨸"])
 ("th_=a" ["𐨠𐨹𐨸"])
 ("th_=i" ["𐨠𐨹𐨸𐨁"])
 ("th_=u" ["𐨠𐨹𐨸𐨂"])
 ("th_=R" ["𐨠𐨹𐨸𐨃"])
 ("th_=e" ["𐨠𐨹𐨸𐨅"])
 ("th_=o" ["𐨠𐨹𐨸𐨆"])

 ("d" ["𐨡𐨿"])
 ("da" ["𐨡"])
 ("di" ["𐨡𐨁"])
 ("du" ["𐨡𐨂"])
 ("dR" ["𐨡𐨃"])
 ("de" ["𐨡𐨅"])
 ("do" ["𐨡𐨆"])
 ("d_" ["𐨡𐨹𐨿"])
 ("d_a" ["𐨡𐨹"])
 ("d_i" ["𐨡𐨹𐨁"])
 ("d_u" ["𐨡𐨹𐨂"])
 ("d_R" ["𐨡𐨹𐨃"])
 ("d_e" ["𐨡𐨹𐨅"])
 ("d_o" ["𐨡𐨹𐨆"])
 ("d=" ["𐨡𐨿𐨸"])
 ("d=a" ["𐨡𐨸"])
 ("d=i" ["𐨡𐨸𐨁"])
 ("d=u" ["𐨡𐨸𐨂"])
 ("d=R" ["𐨡𐨸𐨃"])
 ("d=e" ["𐨡𐨸𐨅"])
 ("d=o" ["𐨡𐨸𐨆"])
 ("d_=" ["𐨡𐨹𐨿𐨸"])
 ("d_=a" ["𐨡𐨹𐨸"])
 ("d_=i" ["𐨡𐨹𐨸𐨁"])
 ("d_=u" ["𐨡𐨹𐨸𐨂"])
 ("d_=R" ["𐨡𐨹𐨸𐨃"])
 ("d_=e" ["𐨡𐨹𐨸𐨅"])
 ("d_=o" ["𐨡𐨹𐨸𐨆"])

 ("dh" ["𐨢𐨿"])
 ("dha" ["𐨢"])
 ("dhi" ["𐨢𐨁"])
 ("dhu" ["𐨢𐨂"])
 ("dhR" ["𐨢𐨃"])
 ("dhe" ["𐨢𐨅"])
 ("dho" ["𐨢𐨆"])
 ("dh_" ["𐨢𐨹𐨿"])
 ("dh_a" ["𐨢𐨹"])
 ("dh_i" ["𐨢𐨹𐨁"])
 ("dh_u" ["𐨢𐨹𐨂"])
 ("dh_R" ["𐨢𐨹𐨃"])
 ("dh_e" ["𐨢𐨹𐨅"])
 ("dh_o" ["𐨢𐨹𐨆"])
 ("dh=" ["𐨢𐨿𐨸"])
 ("dh=a" ["𐨢𐨸"])
 ("dh=i" ["𐨢𐨸𐨁"])
 ("dh=u" ["𐨢𐨸𐨂"])
 ("dh=R" ["𐨢𐨸𐨃"])
 ("dh=e" ["𐨢𐨸𐨅"])
 ("dh=o" ["𐨢𐨸𐨆"])
 ("dh_=" ["𐨢𐨹𐨿𐨸"])
 ("dh_=a" ["𐨢𐨹𐨸"])
 ("dh_=i" ["𐨢𐨹𐨸𐨁"])
 ("dh_=u" ["𐨢𐨹𐨸𐨂"])
 ("dh_=R" ["𐨢𐨹𐨸𐨃"])
 ("dh_=e" ["𐨢𐨹𐨸𐨅"])
 ("dh_=o" ["𐨢𐨹𐨸𐨆"])

 ("n" ["𐨣𐨿"])
 ("na" ["𐨣"])
 ("ni" ["𐨣𐨁"])
 ("nu" ["𐨣𐨂"])
 ("nR" ["𐨣𐨃"])
 ("ne" ["𐨣𐨅"])
 ("no" ["𐨣𐨆"])
 ("n_" ["𐨣𐨹𐨿"])
 ("n_a" ["𐨣𐨹"])
 ("n_i" ["𐨣𐨹𐨁"])
 ("n_u" ["𐨣𐨹𐨂"])
 ("n_R" ["𐨣𐨹𐨃"])
 ("n_e" ["𐨣𐨹𐨅"])
 ("n_o" ["𐨣𐨹𐨆"])
 ("n=" ["𐨣𐨿𐨸"])
 ("n=a" ["𐨣𐨸"])
 ("n=i" ["𐨣𐨸𐨁"])
 ("n=u" ["𐨣𐨸𐨂"])
 ("n=R" ["𐨣𐨸𐨃"])
 ("n=e" ["𐨣𐨸𐨅"])
 ("n=o" ["𐨣𐨸𐨆"])
 ("n_=" ["𐨣𐨹𐨿𐨸"])
 ("n_=a" ["𐨣𐨹𐨸"])
 ("n_=i" ["𐨣𐨹𐨸𐨁"])
 ("n_=u" ["𐨣𐨹𐨸𐨂"])
 ("n_=R" ["𐨣𐨹𐨸𐨃"])
 ("n_=e" ["𐨣𐨹𐨸𐨅"])
 ("n_=o" ["𐨣𐨹𐨸𐨆"])

 ("p" ["𐨤𐨿"])
 ("pa" ["𐨤"])
 ("pi" ["𐨤𐨁"])
 ("pu" ["𐨤𐨂"])
 ("pR" ["𐨤𐨃"])
 ("pe" ["𐨤𐨅"])
 ("po" ["𐨤𐨆"])
 ("p_" ["𐨤𐨹𐨿"])
 ("p_a" ["𐨤𐨹"])
 ("p_i" ["𐨤𐨹𐨁"])
 ("p_u" ["𐨤𐨹𐨂"])
 ("p_R" ["𐨤𐨹𐨃"])
 ("p_e" ["𐨤𐨹𐨅"])
 ("p_o" ["𐨤𐨹𐨆"])
 ("p=" ["𐨤𐨿𐨸"])
 ("p=a" ["𐨤𐨸"])
 ("p=i" ["𐨤𐨸𐨁"])
 ("p=u" ["𐨤𐨸𐨂"])
 ("p=R" ["𐨤𐨸𐨃"])
 ("p=e" ["𐨤𐨸𐨅"])
 ("p=o" ["𐨤𐨸𐨆"])
 ("p_=" ["𐨤𐨹𐨿𐨸"])
 ("p_=a" ["𐨤𐨹𐨸"])
 ("p_=i" ["𐨤𐨹𐨸𐨁"])
 ("p_=u" ["𐨤𐨹𐨸𐨂"])
 ("p_=R" ["𐨤𐨹𐨸𐨃"])
 ("p_=e" ["𐨤𐨹𐨸𐨅"])
 ("p_=o" ["𐨤𐨹𐨸𐨆"])

 ("ph" ["𐨥𐨿"])
 ("pha" ["𐨥"])
 ("phi" ["𐨥𐨁"])
 ("phu" ["𐨥𐨂"])
 ("phR" ["𐨥𐨃"])
 ("phe" ["𐨥𐨅"])
 ("pho" ["𐨥𐨆"])
 ("ph_" ["𐨥𐨹𐨿"])
 ("ph_a" ["𐨥𐨹"])
 ("ph_i" ["𐨥𐨹𐨁"])
 ("ph_u" ["𐨥𐨹𐨂"])
 ("ph_R" ["𐨥𐨹𐨃"])
 ("ph_e" ["𐨥𐨹𐨅"])
 ("ph_o" ["𐨥𐨹𐨆"])
 ("ph=" ["𐨥𐨿𐨸"])
 ("ph=a" ["𐨥𐨸"])
 ("ph=i" ["𐨥𐨸𐨁"])
 ("ph=u" ["𐨥𐨸𐨂"])
 ("ph=R" ["𐨥𐨸𐨃"])
 ("ph=e" ["𐨥𐨸𐨅"])
 ("ph=o" ["𐨥𐨸𐨆"])
 ("ph_=" ["𐨥𐨹𐨿𐨸"])
 ("ph_=a" ["𐨥𐨹𐨸"])
 ("ph_=i" ["𐨥𐨹𐨸𐨁"])
 ("ph_=u" ["𐨥𐨹𐨸𐨂"])
 ("ph_=R" ["𐨥𐨹𐨸𐨃"])
 ("ph_=e" ["𐨥𐨹𐨸𐨅"])
 ("ph_=o" ["𐨥𐨹𐨸𐨆"])

 ("b" ["𐨦𐨿"])
 ("ba" ["𐨦"])
 ("bi" ["𐨦𐨁"])
 ("bu" ["𐨦𐨂"])
 ("bR" ["𐨦𐨃"])
 ("be" ["𐨦𐨅"])
 ("bo" ["𐨦𐨆"])
 ("b_" ["𐨦𐨹𐨿"])
 ("b_a" ["𐨦𐨹"])
 ("b_i" ["𐨦𐨹𐨁"])
 ("b_u" ["𐨦𐨹𐨂"])
 ("b_R" ["𐨦𐨹𐨃"])
 ("b_e" ["𐨦𐨹𐨅"])
 ("b_o" ["𐨦𐨹𐨆"])
 ("b=" ["𐨦𐨿𐨸"])
 ("b=a" ["𐨦𐨸"])
 ("b=i" ["𐨦𐨸𐨁"])
 ("b=u" ["𐨦𐨸𐨂"])
 ("b=R" ["𐨦𐨸𐨃"])
 ("b=e" ["𐨦𐨸𐨅"])
 ("b=o" ["𐨦𐨸𐨆"])
 ("b_=" ["𐨦𐨹𐨿𐨸"])
 ("b_=a" ["𐨦𐨹𐨸"])
 ("b_=i" ["𐨦𐨹𐨸𐨁"])
 ("b_=u" ["𐨦𐨹𐨸𐨂"])
 ("b_=R" ["𐨦𐨹𐨸𐨃"])
 ("b_=e" ["𐨦𐨹𐨸𐨅"])
 ("b_=o" ["𐨦𐨹𐨸𐨆"])

 ("bh" ["𐨧𐨿"])
 ("bha" ["𐨧"])
 ("bhi" ["𐨧𐨁"])
 ("bhu" ["𐨧𐨂"])
 ("bhR" ["𐨧𐨃"])
 ("bhe" ["𐨧𐨅"])
 ("bho" ["𐨧𐨆"])
 ("bh_" ["𐨧𐨹𐨿"])
 ("bh_a" ["𐨧𐨹"])
 ("bh_i" ["𐨧𐨹𐨁"])
 ("bh_u" ["𐨧𐨹𐨂"])
 ("bh_R" ["𐨧𐨹𐨃"])
 ("bh_e" ["𐨧𐨹𐨅"])
 ("bh_o" ["𐨧𐨹𐨆"])
 ("bh=" ["𐨧𐨿𐨸"])
 ("bh=a" ["𐨧𐨸"])
 ("bh=i" ["𐨧𐨸𐨁"])
 ("bh=u" ["𐨧𐨸𐨂"])
 ("bh=R" ["𐨧𐨸𐨃"])
 ("bh=e" ["𐨧𐨸𐨅"])
 ("bh=o" ["𐨧𐨸𐨆"])
 ("bh_=" ["𐨧𐨹𐨿𐨸"])
 ("bh_=a" ["𐨧𐨹𐨸"])
 ("bh_=i" ["𐨧𐨹𐨸𐨁"])
 ("bh_=u" ["𐨧𐨹𐨸𐨂"])
 ("bh_=R" ["𐨧𐨹𐨸𐨃"])
 ("bh_=e" ["𐨧𐨹𐨸𐨅"])
 ("bh_=o" ["𐨧𐨹𐨸𐨆"])

 ("m" ["𐨨𐨿"])
 ("ma" ["𐨨"])
 ("mi" ["𐨨𐨁"])
 ("mu" ["𐨨𐨂"])
 ("mR" ["𐨨𐨃"])
 ("me" ["𐨨𐨅"])
 ("mo" ["𐨨𐨆"])
 ("m_" ["𐨨𐨹𐨿"])
 ("m_a" ["𐨨𐨹"])
 ("m_i" ["𐨨𐨹𐨁"])
 ("m_u" ["𐨨𐨹𐨂"])
 ("m_R" ["𐨨𐨹𐨃"])
 ("m_e" ["𐨨𐨹𐨅"])
 ("m_o" ["𐨨𐨹𐨆"])
 ("m=" ["𐨨𐨿𐨸"])
 ("m=a" ["𐨨𐨸"])
 ("m=i" ["𐨨𐨸𐨁"])
 ("m=u" ["𐨨𐨸𐨂"])
 ("m=R" ["𐨨𐨸𐨃"])
 ("m=e" ["𐨨𐨸𐨅"])
 ("m=o" ["𐨨𐨸𐨆"])
 ("m_=" ["𐨨𐨹𐨿𐨸"])
 ("m_=a" ["𐨨𐨹𐨸"])
 ("m_=i" ["𐨨𐨹𐨸𐨁"])
 ("m_=u" ["𐨨𐨹𐨸𐨂"])
 ("m_=R" ["𐨨𐨹𐨸𐨃"])
 ("m_=e" ["𐨨𐨹𐨸𐨅"])
 ("m_=o" ["𐨨𐨹𐨸𐨆"])

 ("y" ["𐨩𐨿"])
 ("ya" ["𐨩"])
 ("yi" ["𐨩𐨁"])
 ("yu" ["𐨩𐨂"])
 ("yR" ["𐨩𐨃"])
 ("ye" ["𐨩𐨅"])
 ("yo" ["𐨩𐨆"])
 ("y_" ["𐨩𐨹𐨿"])
 ("y_a" ["𐨩𐨹"])
 ("y_i" ["𐨩𐨹𐨁"])
 ("y_u" ["𐨩𐨹𐨂"])
 ("y_R" ["𐨩𐨹𐨃"])
 ("y_e" ["𐨩𐨹𐨅"])
 ("y_o" ["𐨩𐨹𐨆"])
 ("y=" ["𐨩𐨿𐨸"])
 ("y=a" ["𐨩𐨸"])
 ("y=i" ["𐨩𐨸𐨁"])
 ("y=u" ["𐨩𐨸𐨂"])
 ("y=R" ["𐨩𐨸𐨃"])
 ("y=e" ["𐨩𐨸𐨅"])
 ("y=o" ["𐨩𐨸𐨆"])
 ("y_=" ["𐨩𐨹𐨿𐨸"])
 ("y_=a" ["𐨩𐨹𐨸"])
 ("y_=i" ["𐨩𐨹𐨸𐨁"])
 ("y_=u" ["𐨩𐨹𐨸𐨂"])
 ("y_=R" ["𐨩𐨹𐨸𐨃"])
 ("y_=e" ["𐨩𐨹𐨸𐨅"])
 ("y_=o" ["𐨩𐨹𐨸𐨆"])

 ("r" ["𐨪𐨿"])
 ("ra" ["𐨪"])
 ("ri" ["𐨪𐨁"])
 ("ru" ["𐨪𐨂"])
 ("rR" ["𐨪𐨃"])
 ("re" ["𐨪𐨅"])
 ("ro" ["𐨪𐨆"])
 ("r_" ["𐨪𐨹𐨿"])
 ("r_a" ["𐨪𐨹"])
 ("r_i" ["𐨪𐨹𐨁"])
 ("r_u" ["𐨪𐨹𐨂"])
 ("r_R" ["𐨪𐨹𐨃"])
 ("r_e" ["𐨪𐨹𐨅"])
 ("r_o" ["𐨪𐨹𐨆"])
 ("r=" ["𐨪𐨿𐨸"])
 ("r=a" ["𐨪𐨸"])
 ("r=i" ["𐨪𐨸𐨁"])
 ("r=u" ["𐨪𐨸𐨂"])
 ("r=R" ["𐨪𐨸𐨃"])
 ("r=e" ["𐨪𐨸𐨅"])
 ("r=o" ["𐨪𐨸𐨆"])
 ("r_=" ["𐨪𐨹𐨿𐨸"])
 ("r_=a" ["𐨪𐨹𐨸"])
 ("r_=i" ["𐨪𐨹𐨸𐨁"])
 ("r_=u" ["𐨪𐨹𐨸𐨂"])
 ("r_=R" ["𐨪𐨹𐨸𐨃"])
 ("r_=e" ["𐨪𐨹𐨸𐨅"])
 ("r_=o" ["𐨪𐨹𐨸𐨆"])

 ("l" ["𐨫𐨿"])
 ("la" ["𐨫"])
 ("li" ["𐨫𐨁"])
 ("lu" ["𐨫𐨂"])
 ("lR" ["𐨫𐨃"])
 ("le" ["𐨫𐨅"])
 ("lo" ["𐨫𐨆"])
 ("l_" ["𐨫𐨹𐨿"])
 ("l_a" ["𐨫𐨹"])
 ("l_i" ["𐨫𐨹𐨁"])
 ("l_u" ["𐨫𐨹𐨂"])
 ("l_R" ["𐨫𐨹𐨃"])
 ("l_e" ["𐨫𐨹𐨅"])
 ("l_o" ["𐨫𐨹𐨆"])
 ("l=" ["𐨫𐨿𐨸"])
 ("l=a" ["𐨫𐨸"])
 ("l=i" ["𐨫𐨸𐨁"])
 ("l=u" ["𐨫𐨸𐨂"])
 ("l=R" ["𐨫𐨸𐨃"])
 ("l=e" ["𐨫𐨸𐨅"])
 ("l=o" ["𐨫𐨸𐨆"])
 ("l_=" ["𐨫𐨹𐨿𐨸"])
 ("l_=a" ["𐨫𐨹𐨸"])
 ("l_=i" ["𐨫𐨹𐨸𐨁"])
 ("l_=u" ["𐨫𐨹𐨸𐨂"])
 ("l_=R" ["𐨫𐨹𐨸𐨃"])
 ("l_=e" ["𐨫𐨹𐨸𐨅"])
 ("l_=o" ["𐨫𐨹𐨸𐨆"])

 ("v" ["𐨬𐨿"])
 ("va" ["𐨬"])
 ("vi" ["𐨬𐨁"])
 ("vu" ["𐨬𐨂"])
 ("vR" ["𐨬𐨃"])
 ("ve" ["𐨬𐨅"])
 ("vo" ["𐨬𐨆"])
 ("v_" ["𐨬𐨹𐨿"])
 ("v_a" ["𐨬𐨹"])
 ("v_i" ["𐨬𐨹𐨁"])
 ("v_u" ["𐨬𐨹𐨂"])
 ("v_R" ["𐨬𐨹𐨃"])
 ("v_e" ["𐨬𐨹𐨅"])
 ("v_o" ["𐨬𐨹𐨆"])
 ("v=" ["𐨬𐨿𐨸"])
 ("v=a" ["𐨬𐨸"])
 ("v=i" ["𐨬𐨸𐨁"])
 ("v=u" ["𐨬𐨸𐨂"])
 ("v=R" ["𐨬𐨸𐨃"])
 ("v=e" ["𐨬𐨸𐨅"])
 ("v=o" ["𐨬𐨸𐨆"])
 ("v_=" ["𐨬𐨹𐨿𐨸"])
 ("v_=a" ["𐨬𐨹𐨸"])
 ("v_=i" ["𐨬𐨹𐨸𐨁"])
 ("v_=u" ["𐨬𐨹𐨸𐨂"])
 ("v_=R" ["𐨬𐨹𐨸𐨃"])
 ("v_=e" ["𐨬𐨹𐨸𐨅"])
 ("v_=o" ["𐨬𐨹𐨸𐨆"])

 ("z" ["𐨭𐨿"])
 ("za" ["𐨭"])
 ("zi" ["𐨭𐨁"])
 ("zu" ["𐨭𐨂"])
 ("z" ["𐨭𐨃"])
 ("ze" ["𐨭𐨅"])
 ("zo" ["𐨭𐨆"])
 ("z_" ["𐨭𐨹𐨿"])
 ("z_a" ["𐨭𐨹"])
 ("z_i" ["𐨭𐨹𐨁"])
 ("z_u" ["𐨭𐨹𐨂"])
 ("z_R" ["𐨭𐨹𐨃"])
 ("z_e" ["𐨭𐨹𐨅"])
 ("z_o" ["𐨭𐨹𐨆"])
 ("z=" ["𐨭𐨿𐨸"])
 ("z=a" ["𐨭𐨸"])
 ("z=i" ["𐨭𐨸𐨁"])
 ("z=u" ["𐨭𐨸𐨂"])
 ("z=R" ["𐨭𐨸𐨃"])
 ("z=e" ["𐨭𐨸𐨅"])
 ("z=o" ["𐨭𐨸𐨆"])
 ("z_=" ["𐨭𐨹𐨿𐨸"])
 ("z_=a" ["𐨭𐨹𐨸"])
 ("z_=i" ["𐨭𐨹𐨸𐨁"])
 ("z_=u" ["𐨭𐨹𐨸𐨂"])
 ("z_=R" ["𐨭𐨹𐨸𐨃"])
 ("z_=e" ["𐨭𐨹𐨸𐨅"])
 ("z_=o" ["𐨭𐨹𐨸𐨆"])

 ("S" ["𐨮𐨿"])
 ("Sa" ["𐨮"])
 ("Si" ["𐨮𐨁"])
 ("Su" ["𐨮𐨂"])
 ("SR" ["𐨮𐨃"])
 ("Se" ["𐨮𐨅"])
 ("So" ["𐨮𐨆"])
 ("S_" ["𐨮𐨹𐨿"])
 ("S_a" ["𐨮𐨹"])
 ("S_i" ["𐨮𐨹𐨁"])
 ("S_u" ["𐨮𐨹𐨂"])
 ("S_R" ["𐨮𐨹𐨃"])
 ("S_e" ["𐨮𐨹𐨅"])
 ("S_o" ["𐨮𐨹𐨆"])
 ("S=" ["𐨮𐨿𐨸"])
 ("S=a" ["𐨮𐨸"])
 ("S=i" ["𐨮𐨸𐨁"])
 ("S=u" ["𐨮𐨸𐨂"])
 ("S=R" ["𐨮𐨸𐨃"])
 ("S=e" ["𐨮𐨸𐨅"])
 ("S=o" ["𐨮𐨸𐨆"])
 ("S_=" ["𐨮𐨹𐨿𐨸"])
 ("S_=a" ["𐨮𐨹𐨸"])
 ("S_=i" ["𐨮𐨹𐨸𐨁"])
 ("S_=u" ["𐨮𐨹𐨸𐨂"])
 ("S_=R" ["𐨮𐨹𐨸𐨃"])
 ("S_=e" ["𐨮𐨹𐨸𐨅"])
 ("S_=o" ["𐨮𐨹𐨸𐨆"])

 ("s" ["𐨯𐨿"])
 ("sa" ["𐨯"])
 ("si" ["𐨯𐨁"])
 ("su" ["𐨯𐨂"])
 ("sR" ["𐨯𐨃"])
 ("se" ["𐨯𐨅"])
 ("so" ["𐨯𐨆"])
 ("s_" ["𐨯𐨹𐨿"])
 ("s_a" ["𐨯𐨹"])
 ("s_i" ["𐨯𐨹𐨁"])
 ("s_u" ["𐨯𐨹𐨂"])
 ("s_R" ["𐨯𐨹𐨃"])
 ("s_e" ["𐨯𐨹𐨅"])
 ("s_o" ["𐨯𐨹𐨆"])
 ("s=" ["𐨯𐨿𐨸"])
 ("s=a" ["𐨯𐨸"])
 ("s=i" ["𐨯𐨸𐨁"])
 ("s=u" ["𐨯𐨸𐨂"])
 ("s=R" ["𐨯𐨸𐨃"])
 ("s=e" ["𐨯𐨸𐨅"])
 ("s=o" ["𐨯𐨸𐨆"])
 ("s_=" ["𐨯𐨹𐨿𐨸"])
 ("s_=a" ["𐨯𐨹𐨸"])
 ("s_=i" ["𐨯𐨹𐨸𐨁"])
 ("s_=u" ["𐨯𐨹𐨸𐨂"])
 ("s_=R" ["𐨯𐨹𐨸𐨃"])
 ("s_=e" ["𐨯𐨹𐨸𐨅"])
 ("s_=o" ["𐨯𐨹𐨸𐨆"])

 ("h" ["𐨱𐨿"])
 ("ha" ["𐨱"])
 ("hi" ["𐨱𐨁"])
 ("hu" ["𐨱𐨂"])
 ("hR" ["𐨱𐨃"])
 ("he" ["𐨱𐨅"])
 ("ho" ["𐨱𐨆"])
 ("h_" ["𐨱𐨹𐨿"])
 ("h_a" ["𐨱𐨹"])
 ("h_i" ["𐨱𐨹𐨁"])
 ("h_u" ["𐨱𐨹𐨂"])
 ("h_R" ["𐨱𐨹𐨃"])
 ("h_e" ["𐨱𐨹𐨅"])
 ("h_o" ["𐨱𐨹𐨆"])
 ("h=" ["𐨱𐨿𐨸"])
 ("h=a" ["𐨱𐨸"])
 ("h=i" ["𐨱𐨸𐨁"])
 ("h=u" ["𐨱𐨸𐨂"])
 ("h=R" ["𐨱𐨸𐨃"])
 ("h=e" ["𐨱𐨸𐨅"])
 ("h=o" ["𐨱𐨸𐨆"])
 ("h_=" ["𐨱𐨹𐨿𐨸"])
 ("h_=a" ["𐨱𐨹𐨸"])
 ("h_=i" ["𐨱𐨹𐨸𐨁"])
 ("h_=u" ["𐨱𐨹𐨸𐨂"])
 ("h_=R" ["𐨱𐨹𐨸𐨃"])
 ("h_=e" ["𐨱𐨹𐨸𐨅"])
 ("h_=o" ["𐨱𐨹𐨸𐨆"])

 ("k'" ["𐨲𐨿"])
 ("k'a" ["𐨲"])
 ("k'i" ["𐨲𐨁"])
 ("k'u" ["𐨲𐨂"])
 ("k'R" ["𐨲𐨃"])
 ("k'e" ["𐨲𐨅"])
 ("k'o" ["𐨲𐨆"])
 ("k'_" ["𐨲𐨹𐨿"])
 ("k'_a" ["𐨲𐨹"])
 ("k'_i" ["𐨲𐨹𐨁"])
 ("k'_u" ["𐨲𐨹𐨂"])
 ("k'_R" ["𐨲𐨹𐨃"])
 ("k'_e" ["𐨲𐨹𐨅"])
 ("k'_o" ["𐨲𐨹𐨆"])
 ("k'=" ["𐨲𐨿𐨸"])
 ("k'=a" ["𐨲𐨸"])
 ("k'=i" ["𐨲𐨸𐨁"])
 ("k'=u" ["𐨲𐨸𐨂"])
 ("k'=R" ["𐨲𐨸𐨃"])
 ("k'=e" ["𐨲𐨸𐨅"])
 ("k'=o" ["𐨲𐨸𐨆"])
 ("k'_=" ["𐨲𐨹𐨿𐨸"])
 ("k'_=a" ["𐨲𐨹𐨸"])
 ("k'_=i" ["𐨲𐨹𐨸𐨁"])
 ("k'_=u" ["𐨲𐨹𐨸𐨂"])
 ("k'_=R" ["𐨲𐨹𐨸𐨃"])
 ("k'_=e" ["𐨲𐨹𐨸𐨅"])
 ("k'_=o" ["𐨲𐨹𐨸𐨆"])

 ("T'" ["𐨴𐨿"])
 ("T'a" ["𐨴"])
 ("T'i" ["𐨴𐨁"])
 ("T'u" ["𐨴𐨂"])
 ("T'R" ["𐨴𐨃"])
 ("T'e" ["𐨴𐨅"])
 ("T'o" ["𐨴𐨆"])
 ("T'_" ["𐨴𐨹𐨿"])
 ("T'_a" ["𐨴𐨹"])
 ("T'_i" ["𐨴𐨹𐨁"])
 ("T'_u" ["𐨴𐨹𐨂"])
 ("T'_R" ["𐨴𐨹𐨃"])
 ("T'_e" ["𐨴𐨹𐨅"])
 ("T'_o" ["𐨴𐨹𐨆"])
 ("T'=" ["𐨴𐨿𐨸"])
 ("T'=a" ["𐨴𐨸"])
 ("T'=i" ["𐨴𐨸𐨁"])
 ("T'=u" ["𐨴𐨸𐨂"])
 ("T'=R" ["𐨴𐨸𐨃"])
 ("T'=e" ["𐨴𐨸𐨅"])
 ("T'=o" ["𐨴𐨸𐨆"])
 ("T'_=" ["𐨴𐨹𐨿𐨸"])
 ("T'_=a" ["𐨴𐨹𐨸"])
 ("T'_=i" ["𐨴𐨹𐨸𐨁"])
 ("T'_=u" ["𐨴𐨹𐨸𐨂"])
 ("T'_=R" ["𐨴𐨹𐨸𐨃"])
 ("T'_=e" ["𐨴𐨹𐨸𐨅"])
 ("T'_=o" ["𐨴𐨹𐨸𐨆"])

 ("Th'" ["𐨳𐨿"])
 ("Th'a" ["𐨳"])
 ("Th'i" ["𐨳𐨁"])
 ("Th'u" ["𐨳𐨂"])
 ("Th'R" ["𐨳𐨃"])
 ("Th'e" ["𐨳𐨅"])
 ("Th'o" ["𐨳𐨆"])
 ("Th'_" ["𐨳𐨹𐨿"])
 ("Th'_a" ["𐨳𐨹"])
 ("Th'_i" ["𐨳𐨹𐨁"])
 ("Th'_u" ["𐨳𐨹𐨂"])
 ("Th'_R" ["𐨳𐨹𐨃"])
 ("Th'_e" ["𐨳𐨹𐨅"])
 ("Th'_o" ["𐨳𐨹𐨆"])
 ("Th'=" ["𐨳𐨿𐨸"])
 ("Th'=a" ["𐨳𐨸"])
 ("Th'=i" ["𐨳𐨸𐨁"])
 ("Th'=u" ["𐨳𐨸𐨂"])
 ("Th'=R" ["𐨳𐨸𐨃"])
 ("Th'=e" ["𐨳𐨸𐨅"])
 ("Th'=o" ["𐨳𐨸𐨆"])
 ("Th'_=" ["𐨳𐨹𐨿𐨸"])
 ("Th'_=a" ["𐨳𐨹𐨸"])
 ("Th'_=i" ["𐨳𐨹𐨸𐨁"])
 ("Th'_=u" ["𐨳𐨹𐨸𐨂"])
 ("Th'_=R" ["𐨳𐨹𐨸𐨃"])
 ("Th'_=e" ["𐨳𐨹𐨸𐨅"])
 ("Th'_=o" ["𐨳𐨹𐨸𐨆"])

 ("vh" ["𐨵𐨿"])
 ("vha" ["𐨵"])
 ("vhi" ["𐨵𐨁"])
 ("vhu" ["𐨵𐨂"])
 ("vhR" ["𐨵𐨃"])
 ("vhe" ["𐨵𐨅"])
 ("vho" ["𐨵𐨆"])
 ("vh_" ["𐨵𐨹𐨿"])
 ("vh_a" ["𐨵𐨹"])
 ("vh_i" ["𐨵𐨹𐨁"])
 ("vh_u" ["𐨵𐨹𐨂"])
 ("vh_R" ["𐨵𐨹𐨃"])
 ("vh_e" ["𐨵𐨹𐨅"])
 ("vh_o" ["𐨵𐨹𐨆"])
 ("vh=" ["𐨵𐨿𐨸"])
 ("vh=a" ["𐨵𐨸"])
 ("vh=i" ["𐨵𐨸𐨁"])
 ("vh=u" ["𐨵𐨸𐨂"])
 ("vh=R" ["𐨵𐨸𐨃"])
 ("vh=e" ["𐨵𐨸𐨅"])
 ("vh=o" ["𐨵𐨸𐨆"])
 ("vh_=" ["𐨵𐨹𐨿𐨸"])
 ("vh_=a" ["𐨵𐨹𐨸"])
 ("vh_=i" ["𐨵𐨹𐨸𐨁"])
 ("vh_=u" ["𐨵𐨹𐨸𐨂"])
 ("vh_=R" ["𐨵𐨹𐨸𐨃"])
 ("vh_=e" ["𐨵𐨹𐨸𐨅"])
 ("vh_=o" ["𐨵𐨹𐨸𐨆"])

 ("M" ?𐨎)
 ("H" ?𐨏)
 ("\\" ?𐨌)
 (";;" ?𐨍)

 ("1" ?𐩀)
 ("2" ?𐩁)
 ("3" ?𐩂)
 ("4" ?𐩃)
 ("10" ?𐩄)
 ("20" ?𐩅)
 ("100" ?𐩆)
 ("1000" ?𐩇)

 (".." ?𐩐)
 (".o" ?𐩑)
 (".O" ?𐩒)
 (".E" ?𐩓)
 (".X" ?𐩔)
 (".L" ?𐩕)
 (".|" ?𐩖)
 (".||" ?𐩗)
 (".=" ?𐩘))

(quail-define-package
 "adlam" "Adlam" "𞤀" t "Adlam input method.

 `\\=`' is used to switch levels instead of Alt-Gr.
" nil t t t t nil nil nil nil nil t)

(quail-define-rules
 ("1"  ?𞥑)
 ("`!" ?𞥞)
 ("2"  ?𞥒)
 ("3"  ?𞥓)
 ("4"  ?𞥔)
 ("5"  ?𞥕)
 ("6"  ?𞥖)
 ("7"  ?𞥗)
 ("8"  ?𞥘)
 ("9"  ?𞥙)
 ("0"  ?𞥐)
 ("q"  ?𞤹)
 ("Q"  ?𞤗)
 ("`q" ?𞥆)
 ("w"  ?𞤱)
 ("W"  ?𞤏)
 ("`w" ?𞥈)
 ("`W" ?𞥉)
 ("e"  ?𞤫)
 ("E"  ?𞤉)
 ("`e" ?𞥅)
 ("r"  ?𞤪)
 ("R"  ?𞤈)
 ("t"  ?𞤼)
 ("T"  ?𞤚)
 ("y"  ?𞤴)
 ("Y"  ?𞤒)
 ("`y" ?𞤰)
 ("`Y" ?𞤎)
 ("u"  ?𞤵)
 ("U"  ?𞤓)
 ("i"  ?𞤭)
 ("I"  ?𞤋)
 ("o"  ?𞤮)
 ("O"  ?𞤌)
 ("p"  ?𞤨)
 ("P"  ?𞤆)
 ("a"  ?𞤢)
 ("A"  ?𞤀)
 ("`a" ?𞥄)
 ("s"  ?𞤧)
 ("S"  ?𞤅)
 ("`s" ?𞥃)
 ("`S" ?𞤡)
 ("d"  ?𞤣)
 ("D"  ?𞤁)
 ("`d" ?𞤯)
 ("`D" ?𞤍)
 ("f"  ?𞤬)
 ("F"  ?𞤊)
 ("g"  ?𞤺)
 ("G"  ?𞤘)
 ("`g" ?𞥀)
 ("`G" ?𞤞)
 ("h"  ?𞤸)
 ("H"  ?𞤖)
 ("`h" ?𞥇)
 ("j"  ?𞤶)
 ("J"  ?𞤔)
 ("k"  ?𞤳)
 ("K"  ?𞤑)
 ("`k" ?𞤿)
 ("`K" ?𞤝)
 ("l"  ?𞤤)
 ("L"  ?𞤂)
 ("z"  ?𞥁)
 ("Z"  ?𞤟)
 ("`z" ?𞥂)
 ("`Z" ?𞤠)
 ("x"  ?𞤽)
 ("X"  ?𞤛)
 ("c"  ?𞤷)
 ("C"  ?𞤕)
 ("`c" #x200C) ; ZWNJ
 ("v"  ?𞤾)
 ("V"  ?𞤜)
 ("`v" ?𞥊)
 ("b"  ?𞤦)
 ("B"  ?𞤄)
 ("`b" ?𞤩)
 ("`B" ?𞤇)
 ("n"  ?𞤲)
 ("N"  ?𞤐)
 ("`n" ?𞤻)
 ("`N" ?𞤙)
 ("m"  ?𞤥)
 ("M"  ?𞤃)
 ("`m" ?𞥋)
 ("`/" ?𞥟))

(quail-define-package
 "mende-kikakui" "Mende Kikakui" "𞠗" nil
 "Mende Kikakui input method." nil t t t t nil nil nil nil nil t)

(quail-define-rules
 ("1"    ?𞣇)
 ("2"    ?𞣈)
 ("3"    ?𞣉)
 ("4"    ?𞣊)
 ("5"    ?𞣋)
 ("6"    ?𞣌)
 ("7"    ?𞣍)
 ("8"    ?𞣎)
 ("9"    ?𞣏)

 (".1"   ?𞣐)
 (".2"   ?𞣑)
 (".3"   ?𞣒)
 (".4"   ?𞣓)
 (".5"   ?𞣔)
 (".6"   ?𞣕)
 (".7"   ?𞣖)

 ("ki"   ?𞠀)
 ("ka"   ?𞠁)
 ("ku"   ?𞠂)
 ("kee"  ?𞠃)
 ("ke"   ?𞠄)
 ("koo"  ?𞠅)
 ("ko"   ?𞠆)
 ("kua"  ?𞠇)

 ("wi"   ?𞠈)
 ("wa"   ?𞠉)
 ("wu"   ?𞠊)
 ("wee"  ?𞠋)
 ("we"   ?𞠌)
 ("woo"  ?𞠍)
 ("wo"   ?𞠎)
 ("wui"  ?𞠏)
 ("wei"  ?𞠐)

 ("wvi"  ?𞠑)
 ("wua"  ?𞠒)
 ("wve"  ?𞠓)

 ("min"  ?𞠔)
 ("man"  ?𞠕)
 ("mun"  ?𞠖)
 ("men"  ?𞠗)
 ("mon"  ?𞠘)
 ("muan" ?𞠙)
 ("muen" ?𞠚)

 ("bi"   ?𞠛)
 ("ba"   ?𞠜)
 ("bu"   ?𞠝)
 ("bee"  ?𞠞)
 ("be"   ?𞠟)
 ("boo"  ?𞠠)
 ("bo"   ?𞠡)

 ("i"    ?𞠢)
 ("a"    ?𞠣)
 ("u"    ?𞠤)
 ("ee"   ?𞠥)
 ("e"    ?𞠦)
 ("oo"   ?𞠧)
 ("o"    ?𞠨)
 ("ei"   ?𞠩)
 ("in"   ?𞠪)
 ("inn"  ?𞠫)
 ("an"   ?𞠬)
 ("en"   ?𞠭)

 ("si"   ?𞠮)
 ("sa"   ?𞠯)
 ("su"   ?𞠰)
 ("see"  ?𞠱)
 ("se"   ?𞠲)
 ("soo"  ?𞠳)
 ("so"   ?𞠴)
 ("sia"  ?𞠵)

 ("li"   ?𞠶)
 ("la"   ?𞠷)
 ("lu"   ?𞠸)
 ("lee"  ?𞠹)
 ("le"   ?𞠺)
 ("loo"  ?𞠻)
 ("lo"   ?𞠼)
 ("lle"  ?𞠽)

 ("di"   ?𞠾)
 ("da"   ?𞠿)
 ("du"   ?𞡀)
 ("dee"  ?𞡁)
 ("doo"  ?𞡂)
 ("do"   ?𞡃)

 ("ti"   ?𞡄)
 ("ta"   ?𞡅)
 ("tu"   ?𞡆)
 ("tee"  ?𞡇)
 ("te"   ?𞡈)
 ("too"  ?𞡉)
 ("to"   ?𞡊)

 ("ji"   ?𞡋)
 ("ja"   ?𞡌)
 ("ju"   ?𞡍)
 ("jee"  ?𞡎)
 ("je"   ?𞡏)
 ("joo"  ?𞡐)
 ("jo"   ?𞡑)
 ("jjo"  ?𞡒)

 ("yi"   ?𞡓)
 ("ya"   ?𞡔)
 ("yu"   ?𞡕)
 ("yee"  ?𞡖)
 ("ye"   ?𞡗)
 ("yoo"  ?𞡘)
 ("yo"   ?𞡙)

 ("fi"   ?𞡚)
 ("fa"   ?𞡛)
 ("fu"   ?𞡜)
 ("fee"  ?𞡝)
 ("fe"   ?𞡞)
 ("foo"  ?𞡟)
 ("fo"   ?𞡠)
 ("fua"  ?𞡡)
 ("fan"  ?𞡢)

 ("nin"  ?𞡣)
 ("nan"  ?𞡤)
 ("nun"  ?𞡥)
 ("nen"  ?𞡦)
 ("non"  ?𞡧)

 ("hi"   ?𞡨)
 ("ha"   ?𞡩)
 ("hu"   ?𞡪)
 ("hee"  ?𞡫)
 ("he"   ?𞡬)
 ("hoo"  ?𞡭)
 ("ho"   ?𞡮)
 ("heei" ?𞡯)
 ("hoou" ?𞡰)
 ("hin"  ?𞡱)
 ("han"  ?𞡲)
 ("hun"  ?𞡳)
 ("hen"  ?𞡴)
 ("hon"  ?𞡵)
 ("huan" ?𞡶)

 ("nggi"   ?𞡷)
 ("ngga"   ?𞡸)
 ("nggu"   ?𞡹)
 ("nggee"  ?𞡺)
 ("ngge"   ?𞡻)
 ("nggoo"  ?𞡼)
 ("nggo"   ?𞡽)
 ("nggaa"  ?𞡾)
 ("nggua"  ?𞡿)
 ("nngge"  ?𞢀)
 ("nnggoo" ?𞢁)
 ("nnggo"  ?𞢂)

 ("gi"    ?𞢃)
 ("ga"    ?𞢄)
 ("gu"    ?𞢅)
 ("gee"   ?𞢆)
 ("guei"  ?𞢇)
 ("guan"  ?𞢈)

 ("ngen"  ?𞢉)
 ("ngon"  ?𞢊)
 ("nguan" ?𞢋)

 ("pi"    ?𞢌)
 ("pa"    ?𞢍)
 ("pu"    ?𞢎)
 ("pee"   ?𞢏)
 ("pe"    ?𞢐)
 ("poo"   ?𞢑)
 ("po"    ?𞢒)

 ("mbi"   ?𞢓)
 ("mba"   ?𞢔)
 ("mbu"   ?𞢕)
 ("mbee"  ?𞢖)
 ("mmbee" ?𞢗)
 ("mbe"   ?𞢘)
 ("mboo"  ?𞢙)
 ("mbo"   ?𞢚)
 ("mbuu"  ?𞢛)
 ("mmbe"  ?𞢜)
 ("mmboo" ?𞢝)
 ("mmbo"  ?𞢞)

 ("kpi"   ?𞢟)
 ("kpa"   ?𞢠)
 ("kpu"   ?𞢡)
 ("kpee"  ?𞢢)
 ("kpe"   ?𞢣)
 ("kpoo"  ?𞢤)
 ("kpo"   ?𞢥)

 ("gbi"   ?𞢦)
 ("gba"   ?𞢧)
 ("gbu"   ?𞢨)
 ("gbee"  ?𞢩)
 ("gbe"   ?𞢪)
 ("gboo"  ?𞢫)
 ("gbo"   ?𞢬)

 ("ra"    ?𞢭)

 ("ndi"   ?𞢮)
 ("nda"   ?𞢯)
 ("ndu"   ?𞢰)
 ("ndee"  ?𞢱)
 ("nde"   ?𞢲)
 ("ndoo"  ?𞢳)
 ("ndo"   ?𞢴)

 ("nja"   ?𞢵)
 ("nju"   ?𞢶)
 ("njee"  ?𞢷)
 ("njoo"  ?𞢸)

 ("vi"    ?𞢹)
 ("va"    ?𞢺)
 ("vu"    ?𞢻)
 ("vee"   ?𞢼)
 ("ve"    ?𞢽)
 ("voo"   ?𞢾)
 ("vo"    ?𞢿)

 ("nyin"  ?𞣀)
 ("nyan"  ?𞣁)
 ("nyun"  ?𞣂)
 ("nyen"  ?𞣃)
 ("nyon"  ?𞣄))

(quail-define-package
 "gothic" "Gothic" "𐌰" nil
 "Input method for the ancient Gothic script."
 nil t t t t nil nil nil nil nil t)

(quail-define-rules
 ("q"  ?𐌵)
 ("w"  ?𐍅)
 ("e"  ?𐌴)
 ("r"  ?𐍂)
 ("t"  ?𐍄)
 ("y"  ?𐌸)
 ("u"  ?𐌿)
 ("i"  ?𐌹)
 ("o"  ?𐍉)
 ("p"  ?𐍀)
 ("a"  ?𐌰)
 ("s"  ?𐍃)
 ("d"  ?𐌳)
 ("f"  ?𐍆)
 ("g"  ?𐌲)
 ("h"  ?𐌷)
 ("j"  ?𐌾)
 ("k"  ?𐌺)
 ("l"  ?𐌻)
 ("z"  ?𐌶)
 ("x"  ?𐍇)
 ("c"  ?𐍈)
 ("v"  ?𐍁)
 ("V"  ?𐍊)
 ("b"  ?𐌱)
 ("n"  ?𐌽)
 ("m"  ?𐌼))

(quail-define-package
 "coptic" "Coptic" "Ⲁ" nil "Coptic input method.

 `\\=`' is used to switch levels instead of Alt-Gr."
 nil t t t t nil nil nil nil nil t)

(quail-define-rules
 ("1"   ?𐋡)
 ("`1"  ?1)
 ("`!"  ?𐋠)
 ("2"   ?𐋢)
 ("`2"  ?2)
 ("3"   ?𐋣)
 ("`3"  ?3)
 ("4"   ?𐋤)
 ("`4"  ?4)
 ("5"   ?𐋥)
 ("`5"  ?5)
 ("6"   ?𐋦)
 ("`6"  ?6)
 ("7"   ?𐋧)
 ("`7"  ?7)
 ("8"   ?𐋨)
 ("`8"  ?8)
 ("9"   ?𐋩)
 ("`9"  ?9)
 ("10"  ?𐋪)
 ("20"  ?𐋫)
 ("30"  ?𐋬)
 ("40"  ?𐋭)
 ("50"  ?𐋮)
 ("60"  ?𐋯)
 ("70"  ?𐋰)
 ("80"  ?𐋱)
 ("90"  ?𐋲)
 ("100" ?𐋳)
 ("200" ?𐋴)
 ("300" ?𐋵)
 ("400" ?𐋶)
 ("500" ?𐋷)
 ("600" ?𐋸)
 ("700" ?𐋹)
 ("800" ?𐋺)
 ("900" ?𐋻)
 ("1/2" ?⳽)

 ("q"  ?ⲑ)
 ("Q"  ?Ⲑ)
 ("w"  ?ⲱ)
 ("W"  ?Ⲱ)
 ("e"  ?ⲉ)
 ("E"  ?Ⲉ)
 ("r"  ?ⲣ)
 ("R"  ?Ⲣ)
 ("t"  ?ⲧ)
 ("T"  ?Ⲧ)
 ("ti" ?ϯ)
 ("Ti" ?Ϯ)
 ("y"  ?ⲏ)
 ("Y"  ?Ⲏ)
 ("u"  ?ⲩ)
 ("U"  ?Ⲩ)
 ("i"  ?ⲓ)
 ("I"  ?Ⲓ)
 ("o"  ?ⲟ)
 ("O"  ?Ⲟ)
 ("p"  ?ⲡ)
 ("P"  ?Ⲡ)
 ("ps" ?ⲯ)
 ("Ps" ?Ⲯ)
 ("a"  ?ⲁ)
 ("A"  ?Ⲁ)
 ("s"  ?ⲥ)
 ("S"  ?Ⲥ)
 ("`s" ?ⲋ)
 ("`S" ?Ⲋ)
 ("sh" ?ϣ)
 ("Sh" ?Ϣ)
 ("d"  ?ⲇ)
 ("D"  ?Ⲇ)
 ("f"  ?ⲫ)
 ("F"  ?Ⲫ)
 ("g"  ?ⲅ)
 ("G"  ?Ⲅ)
 ("h"  ?ϩ)
 ("H"  ?Ϩ)
 ("j"  ?ϫ)
 ("J"  ?Ϫ)
 ("k"  ?ⲕ)
 ("K"  ?Ⲕ)
 ("kh" ?ⲭ)
 ("Kh" ?Ⲭ)
 ("l"  ?ⲗ)
 ("L"  ?Ⲗ)
 ("z"  ?ⲍ)
 ("Z"  ?Ⲍ)
 ("x"  ?ⲝ)
 ("X"  ?Ⲝ)
 ("`x" ?ϧ)
 ("`X" ?Ϧ)
 ("c"  ?ϭ)
 ("C"  ?Ϭ)
 ("v"  ?ϥ)
 ("V"  ?Ϥ)
 ("b"  ?ⲃ)
 ("B"  ?Ⲃ)
 ("n"  ?ⲛ)
 ("N"  ?Ⲛ)
 ("`n" ?⳯)
 ("m"  ?ⲙ)
 ("M"  ?Ⲙ)

 ("`," ?⳰)
 ("`<" ?⳱)
 ("`."  ?⳾)
 ("`/" ?⳿))

(provide 'misc-lang)
;;; misc-lang.el ends here
