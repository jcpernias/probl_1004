(TeX-add-style-hook
 "docs-rules"
 (lambda ()
   (TeX-run-style-hooks
    "pgfkeys")
   (TeX-add-symbols
    '("xrule" ["argument"] 0)))
 :latex)

