\name{QCdba-methods}
\docType{methods}
\alias{QCdba}
\alias{QCdba-methods}
\alias{QCdba,ChIPQCexperiment-method}
\title{Retrieve the \code{\link[DiffBind]{DBA-object}} object associated with an experiment}
\description{
Retrieve the \code{\link[DiffBind]{DBA-object}} object associated with a \code{\link{ChIPQCexperiment}} object.
}
\section{Methods}{
\describe{

\item{\code{signature(object = "ChIPQCexperiment")}}{

Retrieves the \code{\link[DiffBind]{DBA-object}} object associated with a \code{\link{ChIPQCexperiment}}. This object can be used with \code{\link[DiffBind]{DiffBind}} functions to further analyse a ChIP-seq experiment, including performing a differential binding analysis.
}
}}
\keyword{methods}
\keyword{ ~~ other possible keyword(s) ~~ }
\keyword{methods}
\author{Rory Stark and Thomas Carroll}

\seealso{
\link{ChIPQC-package}, \link{ChIPQCexperiment}, \link[DiffBind]{DiffBind}, \link[DiffBind]{dba}
}
\examples{
data(tamoxifen_QC)
tamoxifenDBA = QCdba(tamoxifen)
## library(DiffBind)
## tamoxifenDBA
}