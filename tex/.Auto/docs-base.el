(TeX-add-style-hook
 "docs-base"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8") ("babel" "english" "spanish" "es-noindentfirst") ("translator" "english" "spanish") ("fontenc" "T1") ("wasysym" "nointegrals") ("csquotes" "autostyle=true" "spanish=spanish" "english=american") ("ulem" "normalem")))
   (TeX-run-style-hooks
    "inputenc"
    "etoolbox"
    "babel"
    "translator"
    "fontenc"
    "kpfonts"
    "marvosym"
    "wasysym"
    "csquotes"
    "ragged2e"
    "ulem"
    "graphicx"
    "microtype"))
 :latex)

