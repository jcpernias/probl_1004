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
\newbool{shortanswers}

\boolfalse{answers}
\boolfalse{shortanswers}

\DeclareOption{Spanish}{\booltrue{langES}\boolfalse{langEN}}
\DeclareOption{English}{\booltrue{langEN}\boolfalse{langES}}
\DeclareOption{noanswers}{\boolfalse{answers}\boolfalse{shortanswers}}
\DeclareOption{answers}{\booltrue{answers}\boolfalse{shortanswers}}
\DeclareOption{shortanswers}{\boolfalse{answers}\booltrue{shortanswers}}
\DeclareOption*{%
  \ClassError{syllabus}{Unknown option `\CurrentOption'}{%
    Check the options passed to the `syllabus' class}}
\ExecuteOptions{Spanish}
\ProcessOptions*\relax

%% Class loading
%% --------------------------------------------------------------------------------
\LoadClass[a4paper, 11pt, twoside]{article}
\RequirePackage[11pt]{moresize}

%% Load packages
%% --------------------------------------------------------------------------------
\RequirePackage{docs-base}
\RequirePackage{docs-colors}

% Page layout
%\RequirePackage{docs-pages}
\RequirePackage{geometry}
\geometry{twoside, hmargin={2cm,5.7cm}, bindingoffset=0.7cm, vmargin=4cm}
%\geometry{vmargin=4cm,hmargin=3.6cm}
\RequirePackage[strict]{changepage}
\RequirePackage{parskip}

\RequirePackage{docs-math}
%\RequirePackage{docs-rules}
%\RequirePackage{docs-lists}
\RequirePackage{docs-units}
\RequirePackage{docs-tables}
\RequirePackage{docs-hyper}
\RequirePackage{docs-cclic}
\RequirePackage{docs-answers}



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
    \preto\section{\clearpage{\cleardoublepage}}
  }
  \maketitle
}



%% Section headings
%% -----------------------------------------------------------------
\RequirePackage[%
newparttoc,%
pagestyles,%
outermarks,%
nobottomtitles*,%
compact]{titlesec}

\deftranslation[to=Spanish]{Exercise}{Ejercicio}
\deftranslation[to=English]{Exercise}{Exercise}
\newcommand*{\ExerciseName}{\translate{Exercise}}

%\newcommand{\sectionbreak}{\cleardoublepage}
%\preto\section{\ifnum\value{section}=0 \else\clearpage{\cleardoublepage}\fi}

\titleformat{name=\section}[hang]{%
  \color{Section}\LARGE\sffamily\bfseries}{%
  \makebox[1.25cm][l]{\rmfamily\slshape\HUGE\thesection}}{0pt}{}

\titlespacing*{name=\section}{-1.25cm}{*7}{*1.5}

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

\titlespacing*{name=\part}{0pt}{*7}{*1.5}
%% Page headers and footers
%% -----------------------------------------------------------------

%\usepackage[outermarks]{titleps}
\newcommand*{\headfmt}{\small\bfseries\scshape\sffamily}
\newcommand*{\footfmt}{\small\bfseries\sffamily}

\newpagestyle{fancy}{%
  % \sethead[\headfmt\color{Section}\thesection{} \sectiontitle\filright][][] % even
  %         {}{}{\headfmt\color{Subsection}\ExerciseName\ \thesubsection}    % odd
  \setfoot*{}{}{\footfmt\thepage}   % odd
}
\newpagestyle{first}{%
  \setfoot*{}{}{\footfmt\thepage}   % odd
}
%\widenhead[2cm][0pt]{0pt}{0pt}
\pagestyle{fancy}





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
