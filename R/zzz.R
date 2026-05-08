## Silence R CMD check NOTEs about NSE column names used in ggplot2
## aes()/aes_string() calls inside the QC plotting functions. These
## are column names of data frames built and consumed locally; the
## static checker cannot see into aes() calls and would otherwise
## flag them as undefined globals.
utils::globalVariables(c(
    "CC_Score", "CountsInPeaks", "Depth", "Distance",
    "FRIBL", "FRIP", "GenomicIntervals", "Reads",
    "SSD", "Sample", "Shift_Size", "Signal",
    "log10_bp", "log2_Enrichment"
))
