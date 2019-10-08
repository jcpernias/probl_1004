(TeX-add-style-hook
 "docs-tables"
 (lambda ()
   (TeX-run-style-hooks
    "array"
    "tabularx"
    "booktabs"))
 :latex)

