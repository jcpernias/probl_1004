(TeX-add-style-hook
 "docs-units"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("textcomp" "full")))
   (TeX-run-style-hooks
    "textcomp"
    "siunitx")
   (TeX-add-symbols
    '("units" ["argument"] 1)
    '("wage" ["argument"] 1)
    '("price" ["argument"] 1)
    '("hours" 1)
    '("money" 1)))
 :latex)

