(TeX-add-style-hook
 "syllabus"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "a4paper" "12pt")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("titlesec" "pagestyles" "outermarks" "nobottomtitles*" "compact")))
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
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
    "docs-tables"
    "docs-hyper"
    "titletoc"
    "titling"
    "titlesec")
   (TeX-add-symbols
    "oldmaketitle"
    "maketitle"))
 :latex)

