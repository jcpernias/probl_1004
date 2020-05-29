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
\RequirePackage{docs-base}
\RequirePackage{docs-colors}

% Page layout
\RequirePackage{geometry}
\geometry{twoside, hmargin={2cm,5.7cm}, bindingoffset=0.7cm, vmargin=4cm}
\RequirePackage[strict]{changepage}
\RequirePackage{parskip}

\RequirePackage{adjustbox}
\RequirePackage{multicol}
\setlength{\columnseprule}{0.4pt}
\setlength{\columnsep}{0.8cm}
\def\columnseprulecolor{\color{Subsection!30!White}}

\RequirePackage{docs-math}

% Tables
%% -----------------------------------------------------------------
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{booktabs}

\newcolumntype{R}[1]{>{\RaggedLeft\arraybackslash}p{#1}}


\RequirePackage{docs-hyper}
\RequirePackage{docs-cclic}




%% TOC
%% -----------------------------------------------------------------

\RequirePackage{titletoc}
\contentsmargin{1.5pc}
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
    %\cleardoublepage{}%
    \ccpage%
    \pagenumbering{arabic}
    %\oldmaketitle
    \let\maketitle\oldmaketitle%
    % \preto\section{\clearpage{\cleardoublepage}}
    \newcommand{\sectionbreak}{\clearpage{\cleardoublepage}\thispagestyle{first}}}
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

\deftranslation[to=Spanish]{Solutions}{Soluciones}
\deftranslation[to=English]{Solutions}{Solutions}
\newcommand*{\SolutionsName}{\translate{Solutions}}


%\newcommand{\sectionbreak}{\cleardoublepage}
%\preto\section{\ifnum\value{section}=0 \else\clearpage{\cleardoublepage}\fi}

\titleformat{name=\section}[hang]{%
  \color{Section}\LARGE\sffamily\bfseries}{%
  \makebox[1.25cm][l]{\rmfamily\slshape\HUGE\thesection}}{0pt}{}

\titlespacing*{name=\section}{-1.25cm}{0pt}{*1.5}

\titleformat{name=\section, numberless}
{\color{Section}\LARGE\sffamily\bfseries}
{}{0pt}{}

\titlespacing*{name=\section, numberless}{0pc}{*7}{*1.5}

\newcommand*{\eat}[1]{}
\titleformat{name=\subsection}[hang]
{\normalfont\large\bfseries\sffamily}
{\color{Subsection}\ExerciseName\ \thesubsection}{0em}{\eat}

\titlespacing*{name=\subsection}
{0pt}{*4}{*1.5}


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

%% Solutions
%% -----------------------------------------------------------------
\newcommand{\@solutions}{
  \cleardoublepage
  \widenhead*{0cm}{0cm}
  \newgeometry{twoside, hmargin={1.2cm,1.2cm}, bindingoffset=0.7cm,
    vmargin=4cm}


  % Do not include anything in toc
  \addtocontents{toc}{\string\setcounter{tocdepth}{0}}

  \part{\SolutionsName}
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
