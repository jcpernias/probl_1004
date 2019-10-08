(TeX-add-style-hook
 "docs-blocks"
 (lambda ()
   (TeX-run-style-hooks
    "tcolorbox")
   (LaTeX-add-tcolorbox-newtcolorboxes
    '("bibbox" "" "" "")))
 :latex)

