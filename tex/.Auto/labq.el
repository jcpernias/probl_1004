(TeX-add-style-hook
 "labq"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "a4paper" "12pt")))
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
    "docs-hyper"
    "titling"
    "rerunfilecheck"
    "newfile"
    "translator")
   (TeX-add-symbols
    '("safeinput" 1)
    "outfile"
    "printinstructions"
    "headerfile"
    "printheader")
   (LaTeX-add-environments
    "instructions"
    "header"))
 :latex)

