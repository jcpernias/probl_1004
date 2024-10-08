%% Identification
%% ----------------------------------------------------------------------

% A very recent version of LaTeX is required to ensure that default
% input encoding is utf8. This saves to explicitely require utf8
% encoding and especial handling of some characters:
%
% \usepackage[utf8]{inputenc}
% \DeclareUnicodeCharacter{00A0}{~}

\NeedsTeXFormat{LaTeX2e}[2018/04/01]
\ProvidesClass{probl}[2018/10/15 v 0.1 Part of docs-bundle]

\RequirePackage{etoolbox}

%% Class options
%% --------------------------------------------------------------------------------
\newbool{langES}
\newbool{langEN}
\newbool{answers}

\DeclareOption{spanish}{\booltrue{langES}\boolfalse{langEN}}
\DeclareOption{english}{\booltrue{langEN}\boolfalse{langES}}
\DeclareOption{noanswers}{\boolfalse{answers}}
\DeclareOption{answers}{\booltrue{answers}}
\ExecuteOptions{spanish,noanswers}
\ProcessOptions\relax

%% Class loading
%% --------------------------------------------------------------------------------
\PassOptionsToPackage{fleqn, tbtags}{amsmath}
\LoadClassWithOptions{article}
\RequirePackage{moresize}

%% Load packages
%% --------------------------------------------------------------------------------
\RequirePackage{probl-base}

% Graphics
\RequirePackage{graphicx}
\ifbool{langES}{\newcommand*{\LANG}{es}}{}
\ifbool{langEN}{\newcommand*{\LANG}{en}}{}

% Page layout
\RequirePackage{geometry}
\geometry{twoside, hmargin={2cm,5.7cm}, bindingoffset=0.7cm, vmargin=4cm}

\RequirePackage{adjustbox}
\RequirePackage{multicol}
\setlength{\columnseprule}{0.4pt}
\setlength{\columnsep}{0.8cm}
\def\columnseprulecolor{\color{Subsection!30!White}}

% Tables
%% -----------------------------------------------------------------
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{booktabs}

\newcolumntype{R}[1]{>{\RaggedLeft\arraybackslash}p{#1}}



% Hyperlinks
%% -----------------------------------------------------------------
\RequirePackage{hyperref}%
\RequirePackage{bookmark}%

% Fix problem with bookmark
\RequirePackage{auxhook}
\AddLineBeginAux{%
  \string\providecommand{\string\BKM@Entry}[1]{}%
}

% Web links
\newcommand*{\link}[1]{\url{#1}}


% CC notice
%% -----------------------------------------------------------------

%% Two minipages side by side that fill the width of the line.
%% 1st arg (optional): width of the left cell (default 3.5cm).
%% 2nd arg: contents of the left cell.
%% 3rd arg: contents of the right cell.
\newlength{\@leftcell}
\newlength{\@rightcell}

\newcommand{\@twocells}[3][3.5cm]{
  {\scriptsize%
    \setlength{\@leftcell}{#1}%
    \setlength{\@rightcell}{\linewidth}%
    \addtolength{\@rightcell}{-\@leftcell}%
    \begin{minipage}{\@leftcell}#2\end{minipage}%
    \begin{minipage}{\@rightcell}#3\end{minipage}}}


%% License translations
\deftranslation[to=English]{CCstart}{This work is licensed under a}
\deftranslation[to=English]{CClink}{Creative Commons Attribution-ShareAlike
  4.0 International License.}
\deftranslation[to=Spanish]{CCstart}{Esta obra está bajo una}
\deftranslation[to=Spanish]{CClink}{licencia de Reconocimiento-CompartirIgual
  4.0 de Creative Commons.}


%% Inserts a page stating the CC license
\newcommand{\ccpage}{%
  \newpage%
  \vspace*{\stretch{5}}%
  \thispagestyle{empty}%
  \@twocells{\includegraphics[scale=1]{by-sa}}{%
    \translate{CCstart}
    \href{http://creativecommons.org/licenses/by-sa/4.0/}{%
      \translate{CClink}}}%
  \cleardoublepage{}}


%% TOC
%% -----------------------------------------------------------------

\RequirePackage{titletoc}
\contentsmargin{2pc}
\titlecontents{section}[0pc]
{\addvspace{1ex}\sffamily\bfseries}
{\contentslabel{1.5pc}}
{}
{\hfill\contentspage}


\titlecontents{part}
[0pc] % left
{\addvspace{1ex}\sffamily\bfseries} % above code
{} % numbered
{} % numberless
{\hfill\contentspage} % filler page


\setcounter{tocdepth}{1}


%% Title
%% --------------------------------------------------------------------------------

\RequirePackage{titling}

\pretitle{\begin{flushleft}\HUGE\sffamily\bfseries\color{Title}}
\posttitle{\par\end{flushleft}}

\preauthor{\begin{flushleft}\LARGE\sffamily\bfseries\color{Title}}
\postauthor{\par\end{flushleft}}

\predate{\begin{flushleft}\Large\sffamily\bfseries\color{Title}}
\postdate{\par\end{flushleft}}


\AtBeginDocument{%
  \color{MainText}
  \pagenumbering{roman}
  \let\oldmaketitle\maketitle
  \renewcommand{\maketitle}{%
    \oldmaketitle%
    \tableofcontents%
    \thispagestyle{empty}%
    \ccpage%
    \pagenumbering{arabic}
    \let\maketitle\oldmaketitle%
    \newcommand{\sectionbreak}{%
      \cleardoublepage\phantomsection%
      \thispagestyle{first}}}
  \maketitle
}



%% Section headings
%% -----------------------------------------------------------------
\RequirePackage[%
newparttoc,%
clearempty,%
pagestyles,%
outermarks,%
nobottomtitles*,%
compact]{titlesec}

\deftranslation[to=Spanish]{Exercise}{Ejercicio}
\deftranslation[to=English]{Exercise}{Exercise}
\newcommand*{\ExerciseName}{\translate{Exercise}}

\titleformat{name=\section}[hang]{%
  \color{Section}\huge\sffamily\bfseries}{%
  \makebox[2pc][r]{\rmfamily\slshape\HUGE\thesection.}}{1pc}{}

\titlespacing*{name=\section}{-1.25cm}{0pt}{*1.5}

\titleformat{name=\section, numberless}
{\color{Section}\huge\sffamily\bfseries}
{}{0pt}{}

\titlespacing*{name=\section, numberless}{0pc}{*7}{*1.5}

\newcommand*{\eat}[1]{}
\titleformat{name=\subsection}[hang]
{\normalfont\large\bfseries\sffamily}
{\color{Subsection}\ExerciseName\ \thesubsection}{0em}{\eat}

\titlespacing*{name=\subsection}{0pt}{*3.5}{*0.75}

\titleformat{name=\part}[hang]{%
  \color{Section}\LARGE\sffamily\bfseries}{}{0pt}{}

\titlespacing*{name=\part}{0pt}{0pt}{*1.5}

\titleclass{\part}{top}
\newcommand{\partbreak}{\cleardoublepage}

%% Page headers and footers
%% -----------------------------------------------------------------

\newpagestyle{problems}[\color{Section}\small\bfseries\sffamily]{%
  \renewcommand{\makeheadrule}{%
    \color{Section}\rule{\linewidth}{1.2pt}}
  \renewcommand{\makefootrule}{%
    \color{Section}\rule[0.8\baselineskip]{\linewidth}{1.2pt}}
  \sethead{}{}{}
  \setfoot*{}{}{\thepage}
}

\newpagestyle{first}[\color{Section}\small\bfseries\sffamily]{%
  \renewcommand{\makefootrule}{%
    \color{Section}\rule[0.8\baselineskip]{\linewidth}{1.2pt}}
  \sethead{}{}{}
  \setfoot*{}{}{\thepage}
}

\widenhead*{0.8cm}{4.5cm}
\pagestyle{problems}

%% Lists
%% -----------------------------------------------------------------

\RequirePackage{enumitem}

\setlist{noitemsep}
\setlist[1]{leftmargin=*}
\setlist[itemize,1]{label=\textbullet}
\setlist[itemize,2]{label=-}

\ifbool{langES}{%
  \setlist[enumerate,1]{label = \emph{\alph*})}
}{}
\ifbool{langEN}{%
  \setlist[enumerate,1]{label = (\alph*)}
}{}

%% Bombs
%% --------------------------------------------------------------------------------
\RequirePackage{fourier-orns}
\RequirePackage{pifont}

\newcommand*{\DANGER}{\makebox[0in][r]{%
    \color{Section}\raisebox{2pt}{\Large\bomb}\quad}}
\newcommand*{\DDANGER}{\makebox[0in][r]{%
    \color{Section}\raisebox{2pt}{\Large\bomb\,\bomb}\quad}}
% \newcommand*{\TASK}{\makebox[0in][r]{%
%     \color{Section}\raisebox{-1pt}{\Large\ding{228}}\quad}}
\newcommand*{\TASK}{}

%% Solutions
%% -----------------------------------------------------------------

\newcommand*{\SolutionsGeometry}{
  \ifbool{answers}{%
    \cleardoublepage%
    \widenhead*{0cm}{0cm}%
    \newgeometry{twoside, hmargin={1.2cm,1.2cm},
      bindingoffset=0.7cm, vmargin=4cm}}{}}

\deftranslation[to=Spanish]{Solutions}{Soluciones}
\deftranslation[to=English]{Solutions}{Solutions}

\newcommand{\@solutions}{
  % Do not include anything in toc
  \addtocontents{toc}{\string\setcounter{tocdepth}{0}}

  \part{\translate{Solutions}}
  \thispagestyle{first}

  % Change font size
  \footnotesize\selectfont%

  % Space between list items
  \setlist{itemsep=1ex}

  % Do no start a page with every section
  \renewcommand{\sectionbreak}{}

  % Reset section counter
  \setcounter{section}{0}

  % Change section heading format
  \titleformat{name=\section}[hang]{%
    \color{Section}\normalfont\large\sffamily\bfseries}{\thesection.}{1ex}{}

  \titlespacing*{name=\section}{0pt}{*3}{*2}

  \titleformat{name=\subsection}[hang]
  {\normalfont\bfseries\sffamily}
  {\color{Subsection}\ExerciseName\ \thesubsection}{0em}{\eat}

  \titlespacing*{name=\subsection}
  {0pt}{*1.5}{*1}
}

\RequirePackage{comment}
\ifbool{answers}{%
  \newenvironment{solutions}{\@solutions\begin{multicols}{2}}{\end{multicols}}%
}{\excludecomment{solutions}}
