## ============================================================================
## ChIPQCreport() -- formally deprecated as of ChIPQC 1.48.1
##
## The Nozzle.R1 CRAN package, which the original implementation used to
## generate tile-based HTML reports, was archived from CRAN and is no
## longer installable. As a result, ChIPQCreport() can no longer perform
## its function.
##
## Per Bioconductor's deprecation guidelines, ChIPQCreport() is marked
## DEPRECATED in this release cycle. It will be made DEFUNCT in the
## next release cycle, and removed entirely in the cycle after that.
##
## The original ~1000 lines of report-generation source code is preserved
## verbatim in inst/legacy/report.r for reference; access it via
##   system.file("legacy/report.r", package = "ChIPQC")
##
## Replacements for users:
##   - For QC data: use the exported accessor methods directly
##     (QCmetrics, coveragehistogram, crosscoverage, flagtagcounts,
##      fragmentlength, ssd, frip, readlength, etc.).
##   - For visual ChIP-seq QC reports: deeptools
##     (https://deeptools.readthedocs.io/) is the de facto standard.
##
## See ?'ChIPQC-deprecated' for full details.
## ============================================================================

setGeneric("ChIPQCreport", function(object="ChIPQCexperiment", facet=TRUE,
                                    reportName="ChIPQC", reportFolder="ChIPQCreport",
                                    facetBy=c("Tissue","Factor"),
                                    colourBy=c("Replicate"),
                                    lineBy=NULL,
                                    addMetaData=NULL)
  standardGeneric("ChIPQCreport"))

.chipqc_report_deprecated_msg <- paste0(
    "'ChIPQCreport' is deprecated. ",
    "The 'Nozzle.R1' CRAN package it depended on is no longer available, ",
    "so HTML reports can no longer be generated. ",
    "Original source preserved at ",
    "system.file('legacy/report.r', package = 'ChIPQC'). ",
    "For QC data, use accessor methods (QCmetrics, coveragehistogram, etc.); ",
    "for visual reports, see 'deeptools' (https://deeptools.readthedocs.io/). ",
    "See ?'ChIPQC-deprecated' for full details.")

setMethod("ChIPQCreport", "ChIPQCexperiment",
          function(object, facet=TRUE,
                   reportName="ChIPQC", reportFolder="ChIPQCreport",
                   facetBy=c("Tissue","Factor","Condition","Treatment"),
                   colourBy=c("Replicate"),
                   lineBy=NULL,
                   addMetaData=NULL) {
    .Deprecated(msg = .chipqc_report_deprecated_msg, package = "ChIPQC")
    invisible(NULL)
})

setMethod("ChIPQCreport", "list",
          function(object, facet=TRUE,
                   reportName="ChIPQC", reportFolder="ChIPQCreport",
                   facetBy=c("Tissue","Factor","Condition","Treatment"),
                   colourBy=c("Replicate"),
                   lineBy=NULL,
                   addMetaData=NULL) {
    .Deprecated(msg = .chipqc_report_deprecated_msg, package = "ChIPQC")
    invisible(NULL)
})

setMethod("ChIPQCreport", "ChIPQCsample",
          function(object,
                   reportName="ChIPQC", reportFolder="ChIPQCreport") {
    .Deprecated(msg = .chipqc_report_deprecated_msg, package = "ChIPQC")
    invisible(NULL)
})
