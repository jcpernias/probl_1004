(TeX-add-style-hook
 "figure"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("standalone" "12pt" "tikz" "crop")))
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "etoolbox"
    "standalone"
    "standalone12"
    "docs-base"
    "docs-math"
    "docs-colors"
    "docs-units"
    "docs-hyper")
   (TeX-add-symbols
    "pgfmatrixendcode"
    "pgfmatrixemptycode")
   (LaTeX-add-xcolor-definecolors
    "colorIMg"
    "colorIMe"
    "colorCMg"
    "colorCMe"
    "colorCMgLP"
    "colorCMeLP"
    "colorR1"
    "colorR2"
    "pmatfill"
    "proffill"
    "deadfill"
    "prodsurplus"
    "conssurplus"
    "expendfill"
    "fillA"
    "fillB"
    "fillC"
    "betterfill"
    "worsefill"))
 :latex)

