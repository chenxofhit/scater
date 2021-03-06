% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calculate-expression.R
\name{nexprs}
\alias{nexprs}
\title{Count the number of expressed genes per cell}
\usage{
nexprs(object, detection_limit = 0, exprs_values = "counts",
  byrow = FALSE, subset_row = NULL, subset_col = NULL)
}
\arguments{
\item{object}{a \code{\link{SingleCellExperiment}} object or a numeric
matrix of expression values.}

\item{detection_limit}{numeric scalar providing the value above which 
observations are deemed to be expressed. Defaults to 
\code{object@detection_limit}.}

\item{exprs_values}{character scalar indicating whether the count data
(\code{"counts"}), the log-transformed count data (\code{"logcounts"}),
transcript-per-million (\code{"tpm"}), counts-per-million (\code{"cpm"}) or
FPKM (\code{"fpkm"}) should be used to define if an observation is expressed
or not. Defaults to the first available value of those options in the
order shown. However, if \code{is_exprs(object)} is present, it will be
used directly; \code{exprs_values} and \code{detection_limit} are ignored.}

\item{byrow}{logical scalar indicating if \code{TRUE} to count expressing
cells per feature (i.e. gene) and if \code{FALSE} to count expressing
features (i.e. genes) per cell.}

\item{subset_row}{logical, integeror character vector indicating which rows
(i.e. features/genes) to use.}

\item{subset_col}{logical, integer or character vector indicating which columns
(i.e., cells) to use.}
}
\value{
If \code{byrow=TRUE}, an integer vector containing the number of cells 
expressing each feature, of the same length as the number of features in 
\code{subset_row} (all features in \code{exprs_mat} if \code{subset_row=NULL}).

If \code{byrow=FALSE}, an integer vector containing the number of genes 
expressed in each cell, of the same length as the number of cells specified in
\code{subset_col} (all cells in \code{exprs_mat} if \code{subset_col=NULL}).
}
\description{
An efficient internal function that avoids the need to construct
'is_exprs_mat' by counting the number of expressed genes per cell on the fly.
}
\details{
Setting \code{subset_row} or \code{subset_col} is equivalent to 
subsetting \code{object} before calling \code{nexprs}, but more efficient
as a new copy of the matrix is not constructed.
}
\examples{
data("sc_example_counts")
data("sc_example_cell_info")
example_sce <- SingleCellExperiment(
assays = list(counts = sc_example_counts), colData = sc_example_cell_info)
nexprs(example_sce)[1:10]
nexprs(example_sce, byrow = TRUE)[1:10]

}
