(TeX-add-style-hook
 "exam"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "a4paper" "12pt")))
   (TeX-run-style-hooks
    "latex2e"
    "etoolbox"
    "article"
    "art12"
    "docs-base"
    "docs-pages"
    "docs-math"
    "docs-colors"
    "docs-rules"
    "docs-lists"
    "docs-units"
    "docs-marks"
    "docs-tables"
    "docs-hyper"))
 :latex)

