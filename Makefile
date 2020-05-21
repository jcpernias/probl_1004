SHELL := /bin/sh

subject_code := 1004
probl_units := all
probl_figs := 1 2 3 4 5 6 7 8 9


TEXI2DVI_SILENT := -q
# TEXI2DVI_SILENT :=

## Directories
## ================================================================================

rootdir := .
builddir := $(rootdir)/build
outdir := $(rootdir)/pdf
elispdir := $(rootdir)/elisp
pythondir := $(rootdir)/python
texdir := $(rootdir)/tex
depsdir := $(rootdir)/.deps
imgdir := $(rootdir)/img
figdir := $(rootdir)/figures

## Programs
## ================================================================================

emacsbin := /usr/local/bin/emacs
texi2dvibin := /usr/local/opt/texinfo/bin/texi2dvi
envbin  := /usr/local/opt/coreutils/libexec/gnubin/env
pythonbin := /usr/local/bin/python3

## Variables
## ================================================================================

EMACS := $(emacsbin) -Q -nw --batch
emacs_loads := --load=$(elispdir)/setup-org.el \
	--load=$(elispdir)/parser.el
org_to_latex := --eval "(tolatex (file-name-as-directory \"$(builddir)\"))"
tangle := --eval "(tangle-to (file-name-as-directory \"$(builddir)\"))"

TEXI2DVI := $(envbin) TEXI2DVI_USE_RECORDER=yes \
	$(texi2dvibin) --batch $(TEXI2DVI_SILENT) \
	-I $(texdir) --pdf --build=tidy \
	--build-dir=$(notdir $(builddir))

MAKEORGDEPS := $(pythonbin) $(pythondir)/makeorgdeps.py
MAKETEXDEPS := $(pythonbin) $(pythondir)/maketexdeps.py
MAKEFIGDEPS := $(pythonbin) $(pythondir)/makefigdeps.py

with_ans_es := $(addsuffix _$(subject_code)-es, \
	$(addprefix with-ans-probl-, $(probl_units)))
with_ans_en := $(addsuffix _$(subject_code)-en, \
	$(addprefix with-ans-probl-, $(probl_units)))

no_ans_es := $(addsuffix _$(subject_code)-es, \
	$(addprefix no-ans-probl-, $(probl_units)))
no_ans_en := $(addsuffix _$(subject_code)-en, \
	$(addprefix no-ans-probl-, $(probl_units)))

docs_es := $(no_ans_es) $(with_ans_es)
# docs_en := $(no_ans_en) $(with_ans_en)
docs_en := $(no_ans_en)

docs_base := $(docs_es) $(docs_en)
docs_pdf := $(addprefix $(outdir)/, $(addsuffix .pdf, $(docs_base)))

tex_check_dirs := $(builddir) $(figdir) $(depsdir)

## Automatic dependencies
## ================================================================================
docs_deps := $(addprefix $(depsdir)/, \
	$(addsuffix .pdf.d, $(docs_base)))

tex_deps := $(addprefix $(depsdir)/probl-, \
	$(addsuffix _$(subject_code)-es.tex.d, $(probl_units))) \
	$(addprefix $(depsdir)/probl-, \
	$(addsuffix _$(subject_code)-en.tex.d, $(probl_units)))

probl_figs_deps := $(addprefix $(depsdir)/probl-,\
	$(addsuffix _$(subject_code)-figs.d, $(probl_figs)))

all_deps := $(docs_deps) $(tex_deps) $(probl_figs_deps)

FIGURES :=

INCLUDEDEPS := yes

# Do not include dependency files if make goal is some kind of clean
ifneq (,$(findstring clean,$(MAKECMDGOALS)))
INCLUDEDEPS := no
endif

# $(call probl-wrapper,ans-option,tex-src,lang) -> write to a file
define probl-wrapper
\PassOptionsToClass{$1}{probl}
\AtBeginDocument{\graphicspath{{$(realpath $(figdir))/}{$(realpath $(imgdir))/}}}
\RequirePackage{etoolbox}
\AtEndPreamble{\InputIfFileExists{$(subject_code)-macros.tex}{}{}}
\input{$(realpath $(builddir))/$2-$3}
endef

# $(call fig-wrapper,answer,spanish-or-english,fig-basename) -> write to a file
define fig-wrapper
\documentclass[$1,$2]{figure}
\InputIfFileExists{$(subject_code)-macros.tex}{}{}
\begin{document}
\input{$(realpath $(builddir))/$3}
\end{document}
endef

vpath %.pdf $(figdir)
vpath %.png $(imgdir)
vpath %.jpg $(imgdir)

## Rules
## ================================================================================

all: $(docs_pdf)

# dependencies for latex file
$(depsdir)/%.tex.d: $(rootdir)/%.org | $(depsdir)
	$(MAKEORGDEPS) -o $@ -t $(builddir)/$*.tex $<

# probl to latex
.PRECIOUS: $(builddir)/probl-%.tex
$(builddir)/probl-%.tex: $(rootdir)/probl-%.org | $(builddir)
	$(EMACS) $(emacs_loads) --visit=$< $(org_to_latex)

# probl wrappers
.PRECIOUS: $(builddir)/no-ans-probl-%-es.tex
$(builddir)/no-ans-probl-%-es.tex: $(builddir)/probl-%-es.tex | $(figdir)
	$(file > $@,$(call probl-wrapper,noanswers,probl-$*,es))

.PRECIOUS: $(builddir)/with-ans-probl-%-es.tex
$(builddir)/with-ans-probl-%-es.tex: $(builddir)/probl-%-es.tex | $(figdir)
	$(file > $@,$(call probl-wrapper,answers,probl-$*,es))

.PRECIOUS: $(builddir)/no-ans-probl-%-en.tex
$(builddir)/no-ans-probl-%-en.tex: $(builddir)/probl-%-en.tex | $(figdir)
	$(file > $@,$(call probl-wrapper,noanswers,probl-$*,en))

.PRECIOUS: $(builddir)/with-ans-probl-%-en.tex
$(builddir)/with-ans-probl-%-en.tex: $(builddir)/probl-%-en.tex | $(figdir)
	$(file > $@,$(call probl-wrapper,answers,probl-$*,en))

## latex to pdf
$(outdir)/%.pdf: $(builddir)/%.tex $(texdir)/probl.cls | $(outdir)
	$(TEXI2DVI) --output=$@ $<

# pdf dependencies
$(depsdir)/%.pdf.d: $(builddir)/%.tex | $(outdir) $(depsdir)
	$(MAKETEXDEPS) -o $@ -t $(outdir)/$*.pdf $<

# figure wrappers
.PRECIOUS: $(builddir)/fig-%-en.tex
$(builddir)/fig-%-en.tex: $(builddir)/fig-%.tex
	$(file > $@,$(call fig-wrapper,noanswer,English,fig-$*))

.PRECIOUS: $(builddir)/fig-%-es.tex
$(builddir)/fig-%-es.tex: $(builddir)/fig-%.tex
	$(file > $@,$(call fig-wrapper,noanswer,Spanish,fig-$*))

.PRECIOUS: $(builddir)/fig-ans-%-en.tex
$(builddir)/fig-ans-%-en.tex: $(builddir)/fig-ans-%.tex
	$(file > $@,$(call fig-wrapper,answer,English,fig-ans-$*))

.PRECIOUS: $(builddir)/fig-ans-%-es.tex
$(builddir)/fig-ans-%-es.tex: $(builddir)/fig-ans-%.tex
	$(file > $@,$(call fig-wrapper,answer,Spanish,fig-ans-$*))


# figure latex to pdf
$(figdir)/fig-%.pdf: $(builddir)/fig-%.tex | $(figdir)
	$(TEXI2DVI) --output=$@ $<

$(depsdir)/%-figs.d: %-figs.org | $(depsdir)
	$(MAKEFIGDEPS) -o $@ $<

## automatic dependencies
ifeq ($(INCLUDEDEPS),yes)
include $(all_deps)
endif

## Auxiliary directories
## --------------------------------------------------------------------------------

$(outdir):
	mkdir $(outdir)

$(builddir):
	mkdir $(builddir)

$(depsdir):
	mkdir $(depsdir)

$(figdir):
	mkdir $(figdir)

## Cleaning rules
## --------------------------------------------------------------------------------

.PHONY: clean
clean:
	-@rm -rf $(figdir)
	-@rm -rf $(builddir)
	-@rm -rf $(depsdir)

.PHONY: veryclean
veryclean: clean
	-@rm -rf $(outdir)
