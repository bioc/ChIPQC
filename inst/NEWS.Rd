\name{ChIPQCNews}
\title{ChIPQC News}
\encoding{UTF-8}

\section{Version 1.48.1}{
 \itemize{
  \item{Formally deprecate \code{ChIPQCreport()} per Bioconductor
        deprecation guidelines: the function now emits a
        \code{.Deprecated()} warning and returns invisibly. The
        \pkg{Nozzle.R1} CRAN package it depended on is no longer
        available, so HTML report generation is no longer possible.
        Per Bioconductor policy the function will be made defunct
        in the next release cycle. The original source is preserved
        in \code{inst/legacy/report.r} for reference. See
        \code{?'ChIPQC-deprecated'} for replacements (QC accessor
        methods; \code{deeptools} for visual reports).}
  \item{Remove \pkg{Nozzle.R1} from \code{Imports:} (no longer
        reachable from any executed code path).}
  \item{Add \code{zzz.R} to the \code{Collate:} field (R 4.6 strict
        Collate enforcement).}
  \item{Reduce \code{R CMD check} NOTE noise: import \code{is} from
        \pkg{methods}, \code{geom_point} from \pkg{ggplot2}, and
        \code{multicoreWorkers}/\code{snowWorkers} from
        \pkg{BiocParallel}; register the data-frame column names
        used in \code{ggplot2::aes()} calls (\code{Sample},
        \code{FRIP}, \code{FRIBL}, etc.) via
        \code{utils::globalVariables()}. No behaviour change.}
  \item{Fix \code{\\itemize} \eqn{\to} \code{\\describe} in
        \code{man/ChIPQC.Rd} and \code{man/ChIPQCsample-class.Rd}:
        items used \code{\\item\{label\}\{description\}} (a
        \code{\\describe} semantic) inside an \code{\\itemize}
        wrapper, producing roughly 40 ``Lost braces'' NOTEs. The
        rendered output also improves (proper definition list
        rather than malformed bullets).}
  }
}

\section{Version 1.35.1}{
 \itemize{
  \item{rollup bugfixes}
  }
}

\section{Version 1.33.1}{
 \itemize{
  \item{Make use of BiocParallel more robust - now a Depends}
  \item{Bugfix for(is.na(peaks)) issue}
  }
}

\section{Version 1.31.2}{
 \itemize{
  \item{bugfixes}
  \item{handle larger plots}
  }
}

\section{Version 1.25.1}{
 \itemize{
  \item{Update to maintain compatibility with DiffBind 3.0}
  }
}

\section{Version 1.13.2}{
 \itemize{
  \item{Fix build issue}
  }
}

\section{Version 1.13.2}{
 \itemize{
  \item{Fixed bug when specifying consensus peakset as GRanges}
  }
}

\section{Version 1.9.2}{
 \itemize{
  \item{Dependancy cleanup; update handling of how control samples are added}
  }
}

\section{Version 1.7.2}{
 \itemize{
  \item{Convert data objects for DiffBind compatibility}
  }
}

\section{Version 1.7.1}{
 \itemize{
  \item{Maintain compatibility with changes in DiffBind}
  }
}

\section{Version 1.1.2}{
 \itemize{
  \item{Big fixes/man page fixes}
  }
}

\section{Version 1.0.1}{
 \itemize{
  \item{Changed defaults: annotation, facetBy}
  \item{Bugfixes handling sample lists without peaks}
  }
}

\section{Version 1.0.0}{
 \itemize{
  \item{Initial release.}
  }
}
