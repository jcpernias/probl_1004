(TeX-add-style-hook
 "docs-colors"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("xcolor" "svgnames")))
   (TeX-run-style-hooks
    "xcolor")
   (LaTeX-add-xcolor-definecolors
    "solarizedBase03"
    "solarizedBase02"
    "solarizedBase01"
    "solarizedBase00"
    "solarizedBase0"
    "solarizedBase1"
    "solarizedBase2"
    "solarizedBase3"
    "solarizedYellow"
    "solarizedOrange"
    "solarizedRed"
    "solarizedMagenta"
    "solarizedViolet"
    "solarizedBlue"
    "solarizedCyan"
    "solarizedGreen"
    "MainText"
    "Title"
    "Section"
    "Subsection"
    "Paragraph"
    "Subparagraph"))
 :latex)

