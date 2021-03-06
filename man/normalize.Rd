% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/normalizeSCE.R
\docType{methods}
\name{normalize}
\alias{normalize}
\alias{normalizeSCE}
\alias{normalise}
\alias{normalize,SingleCellExperiment-method}
\alias{normalise,SingleCellExperiment-method}
\alias{normalize,SingleCellExperiment-method}
\alias{normalize}
\alias{normalise}
\title{Normalise a SingleCellExperiment object using pre-computed size factors}
\usage{
normalizeSCE(object, exprs_values = "counts", return_log = TRUE,
  log_exprs_offset = NULL, centre_size_factors = TRUE,
  size_factor_grouping = NULL)

\S4method{normalize}{SingleCellExperiment}(object, exprs_values = "counts",
  return_log = TRUE, log_exprs_offset = NULL, centre_size_factors = TRUE,
  size_factor_grouping = NULL)

normalise(...)
}
\arguments{
\item{object}{A SingleCellExperiment object.}

\item{exprs_values}{String indicating which assay contains the count data that should be used to compute log-transformed expression values.}

\item{return_log}{Logical scalar, should normalized values be returned on the log2 scale?}

\item{log_exprs_offset}{Numeric scalar specifying the offset to add when log-transforming expression values.
If \code{NULL}, value is taken from \code{metadata(object)$log.exprs.offset} if defined, otherwise 1.}

\item{centre_size_factors}{Logical scalar indicating whether size fators should be centred.}

\item{size_factor_grouping}{Factor specifying groups of cells in which size factors should be centred, see \code{\link{centreSizeFactors}} for details.}

\item{...}{Arguments passed to \code{normalize} when calling \code{normalise}.}
}
\value{
A SingleCellExperiment object containing normalized expression values in \code{"normcounts"} if \code{log=FALSE},
and log-normalized expression values in \code{"logcounts"} if \code{log=TRUE}.
All size factors will also be centred in the output object if \code{centre_size_factors=TRUE}.
}
\description{
Compute normalised expression values from count data in a SingleCellExperiment object, using the size factors stored in the object.
}
\details{
Normalized expression values are computed by dividing the counts for each cell by the size factor for that cell.
This aims to remove cell-specific scaling biases, e.g., due to differences in sequencing coverage or capture efficiency.
If \code{log=TRUE}, log-normalized values are calculated by adding \code{log_exprs_offset} to the normalized count and performing a log2 transformation.

Features marked as spike-in controls will be normalized with control-specific size factors, if these are available. 
This reflects the fact that spike-in controls are subject to different biases than those that are removed by gene-specific size factors (namely, total RNA content).
If size factors for a particular spike-in set are not available, a warning will be raised.

Size factors will be centred to have a mean of unity if \code{centre_size_factors=TRUE}, prior to calculation of normalized expression values.
This ensures that the computed \code{exprs} can be interpreted as being on the same scale as log-counts. 
It also standardizes the effect of the \code{log_exprs_offset} addition, 
and ensures that abundances are roughly comparable between features normalized with different sets of size factors.

If \code{size_factor_grouping} is specified and \code{centre_size_factors=TRUE}, this is equivalent to subsetting the SingleCellExperiment;
centering the size factors within each subset; normalizing within each subset; and then merging the subsets back together for output.
This enables convenient normalization of multiple batches separately.

Note that \code{normalize} is exactly the same as \code{normalise}.
}
\section{Warning about centred size factors}{

Generally speaking, centering does not affect relative comparisons between cells in the same \code{object}, as all size factors are scaled by the same amount. 
However, if two different \code{SingleCellExperiment} objects are run separately through \code{normalize}, the size factors in each object will be rescaled differently. 
This means that the size factors and log-expression values will \emph{not} be comparable between objects.

This lack of comparability is not always obvious. 
For example, if we subsetted an existing SingleCellExperiment object, and ran \code{normalize} separately on each subset, 
the resulting expression values in each subsetted object would \emph{not} be comparable to each other. 
This is despite the fact that all cells were originally derived from a single SingleCellExperiment object.

In general, it is advisable to only compare size factors and expression values between cells in one SingleCellExperiment object,
from a single \code{normalize} call with \code{size_factor_grouping=NULL}.
If objects are to be combined, new size factors should be computed using all cells in the combined object, followed by a single \code{normalize} call.
If \code{size_factor_grouping} is specified, expression values should only be compared \emph{within} each level of the specified factor.
}

\examples{
data("sc_example_counts")
data("sc_example_cell_info")
example_sce <- SingleCellExperiment(
    assays = list(counts = sc_example_counts), 
    colData = sc_example_cell_info
)

example_sce <- normalize(example_sce)

}
\author{
Davis McCarthy and Aaron Lun
}
