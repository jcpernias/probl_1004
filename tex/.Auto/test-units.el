(TeX-add-style-hook
 "test-units"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "12pt" "a4paper" "spanish")))
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art12"
    "babel"
    "docs-units"))
 :latex)

