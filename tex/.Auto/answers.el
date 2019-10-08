(TeX-add-style-hook
 "answers"
 (lambda ()
   (TeX-run-style-hooks
    "tcolorbox"
    "verbatim")
   (TeX-add-symbols
    "ClearPage"
    "ClearPageShort")
   (LaTeX-add-environments
    "answer"
    "shortanswer")
   (LaTeX-add-tcolorbox-newtcolorboxes
    '("bibbox" "" "" "")
    '("answer" "" "" "")
    '("shortanswer" "" "" ""))
   (LaTeX-add-tcbuselibraries
    "breakable, skins"))
 :latex)

