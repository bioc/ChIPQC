\name{ChIPQCreport-methods}
\docType{methods}
\alias{ChIPQCreport-methods}
\alias{ChIPQCreport}
\alias{ChIPQCreport,ChIPQCexperiment-method}
\alias{ChIPQCreport,ChIPQCsample-method}
\alias{ChIPQCreport,list-method}
\title{Generate a summary QC report}
\description{
Generate an HTML summary QC report.
}
\section{Methods}{
\describe{

\item{\code{signature(experiment = "ChIPQCexperiment", facet=TRUE, 
                      reportName="ChIPQC", reportFolder="ChIPQCreport",
                      facetBy=c("Tissue","Factor","Condition","Treatment"),
                      colourBy=c("Replicate"))}}{

Generates an summary QC report for the experiment in HTML format.

\tabular{ll}{
experiment \tab \code{\link{ChIPQCexperiment}} object\cr
facet \tab logical indicating whether or not to facet using experimental metadata.\cr
reportName \tab filename of main report file (.html).\cr
reportFolder \tab directory name where plot graphics will be saved\cr
facetBy \tab metadata fields to use for faceting\cr
colourBy \tab metadata field to color by\cr
}
}


\item{\code{signature(experiment = "list", facet=TRUE, 
                      reportName="ChIPQC", reportFolder="ChIPQCreport",
                      facetBy=c("Sample"),
                      colourBy=c("Sample"))}}{

Generates an summary QC report for a list of ChIPQCsample objects in HTML format.

\tabular{ll}{
experiment \tab \code{\link{list}} object\cr
facet \tab logical indicating whether or not to facet using experimental metadata.\cr
reportName \tab filename of main report file (.html).\cr
reportFolder \tab directory name where plot graphics will be saved\cr
facetBy \tab metadata fields to use for faceting\cr
colourBy \tab metadata field to color by\cr
}
}


\item{\code{signature(sample = "ChIPQCsample", 
                      reportName="ChIPQC", reportFolder="ChIPQCreport",)}}{
 
Generate a summary QC report for a sample in HTML format.
 
\tabular{ll}{
sample \tab \code{\link{ChIPQCsample}} object\cr
reportName \tab filename of main report file (.html).\cr
reportFolder \tab directory name where plot graphics will be saved\cr
}
}
}}

\note{
\code{ChIPQCreport} is deprecated as of ChIPQC 1.48.1. The
\code{Nozzle.R1} CRAN package it depended on for HTML report
generation is no longer available. See
\code{?'ChIPQC-deprecated'} for replacements (QC accessor
methods; \code{deeptools} for visual reports). The original
implementation is preserved at
\code{system.file("legacy/report.r", package = "ChIPQC")}.
}

\keyword{methods}
\author{Thomas Carroll and Rory Stark}

\seealso{
\link{ChIPQC-package}, \link{ChIPQCexperiment}, \link{ChIPQCsample}
}

