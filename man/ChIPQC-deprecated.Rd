\name{ChIPQC-deprecated}
\alias{ChIPQC-deprecated}
\title{Deprecated functions in package \sQuote{ChIPQC}}

\description{
  These functions are provided for compatibility with older versions of
  \sQuote{ChIPQC} only, and will be defunct at the next release.
}

\details{

  The following functions are deprecated and will be made defunct in the
  next Bioconductor release cycle:

  \itemize{

    \item{\code{\link{ChIPQCreport}}: there is no replacement function.
      The \pkg{Nozzle.R1} CRAN package that \code{ChIPQCreport}
      depended on for HTML report generation is no longer available
      and cannot be installed. ChIP-seq quality metrics are still
      available through the exported accessor methods
      (\code{\link{QCmetrics}}, \code{\link{coveragehistogram}},
      \code{\link{crosscoverage}}, \code{\link{flagtagcounts}},
      \code{\link{fragmentlength}}, \code{\link{ssd}},
      \code{\link{frip}}, etc.). For visual ChIP-seq QC reports, the
      \href{https://deeptools.readthedocs.io/}{\code{deeptools}}
      Python package is the de facto standard. The original
      \code{ChIPQCreport} source code is preserved in
      \code{inst/legacy/report.r} and can be accessed via
      \code{system.file("legacy/report.r", package = "ChIPQC")} for
      reference and possible future revival.}

  }
}

\keyword{utilities}
