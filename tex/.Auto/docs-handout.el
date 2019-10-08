(TeX-add-style-hook
 "docs-handout"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("titlesec" "pagestyles" "outermarks" "nobottomtitles*" "compact" "noindentafter")))
   (TeX-run-style-hooks
    "beamerarticle"
    "hyphsubst"
    "geometry"
    "enumitem"
    "titlesec"
    "titletoc"
    "titling")
   (TeX-add-symbols
    "headfmt"
    "footfmt"
    "olddescription"
    "oldenddescription"
    "doctitle"
    "oldmaketitle"
    "maketitle")
   (LaTeX-add-environments
    "description")
   (LaTeX-add-pagestyles
    "fancy"
    "first"))
 :latex)

