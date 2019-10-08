(TeX-add-style-hook
 "marks"
 (lambda ()
   (TeX-run-style-hooks
    "units")
   (TeX-add-symbols
    '("points" 1)
    "PointsLabel"))
 :latex)

