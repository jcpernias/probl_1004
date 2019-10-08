(TeX-add-style-hook
 "units"
 (lambda ()
   (TeX-run-style-hooks
    "siunitx")
   (TeX-add-symbols
    '("units" ["argument"] 1)
    '("wage" ["argument"] 1)
    '("price" ["argument"] 1)
    '("stext" 1)
    '("hours" 1)
    '("money" 1)))
 :latex)

