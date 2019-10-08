(TeX-add-style-hook
 "docs-answers"
 (lambda ()
   (TeX-run-style-hooks
    "tcolorbox"
    "verbatim"
    "etoolbox")
   (TeX-add-symbols
    "ClearPage"
    "ClearPageShort")
   (LaTeX-add-environments
    "answer"
    "shortanswer")
   (LaTeX-add-tcolorbox-newtcolorboxes
    '("answer" "" "" "")
    '("shortanswer" "" "" ""))
   (LaTeX-add-tcbuselibraries
    "breakable, skins"))
 :latex)

