(TeX-add-style-hook
 "docs-marks"
 (lambda ()
   (TeX-run-style-hooks
    "ifthen"
    "bm"
    "translator")
   (TeX-add-symbols
    '("points" 1)
    "hmmax"
    "bmmax"))
 :latex)

