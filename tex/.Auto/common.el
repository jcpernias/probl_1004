(TeX-add-style-hook
 "common"
 (lambda ()
   (TeX-add-symbols
    '("twocells" ["argument"] 2)
    '("stext" 1))
   (LaTeX-add-lengths
    "leftcell"
    "rightcell"))
 :latex)

