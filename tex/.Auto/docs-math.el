(TeX-add-style-hook
 "docs-math"
 (lambda ()
   (TeX-run-style-hooks
    "latexsym"
    "amssymb"
    "mathtools")
   (TeX-add-symbols
    '("qqtext" 1)
    '("qtext" 1)
    '("stext" 1)))
 :latex)

