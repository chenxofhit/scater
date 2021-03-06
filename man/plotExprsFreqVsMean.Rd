% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plotExprsFreqVsMean.R
\name{plotExprsFreqVsMean}
\alias{plotExprsFreqVsMean}
\title{Plot frequency against mean for each feature}
\usage{
plotExprsFreqVsMean(object, freq_exprs, mean_exprs, controls,
  by_show_single = FALSE, show_smooth = TRUE, show_se = TRUE, ...)
}
\arguments{
\item{object}{A SingleCellExperiment object.}

\item{freq_exprs}{Specification of the row-level metadata field containing the number of expressing cells per feature, see \code{?"\link{scater-vis-var}"} for possible values.
Note that only metadata fields will be searched, \code{assays} will not be used.
If not supplied or \code{NULL}, this defaults to \code{"n_cells_by_counts"} or equivalent for compacted data.}

\item{mean_exprs}{Specification of the row-level metadata field containing the mean expression of each feature, see \code{?"\link{scater-vis-var}"} for possible values.
Again, only metadata fields will be searched, \code{assays} will not be used.
If not supplied or \code{NULL}, this defaults to \code{"mean_counts"} or equivalent for compacted data.}

\item{controls}{Specification of the row-level metadata column indicating whether a feature is a control, see \code{?"\link{scater-vis-var}"} for possible values.
Only metadata fields will be searched, \code{assays} will not be used.
If not supplied, this defaults to \code{"is_feature_control"} or equivalent for compacted data.}

\item{by_show_single}{Logical scalar specifying whether a single-level factor for \code{controls} should be used for colouring, see \code{?"\link{scater-vis-var}"} for details.}

\item{show_smooth}{Logical scalar, should a smoothed fit (through feature controls if available; all features otherwise) be shown on the plot? 
See \code{\link[ggplot2]{geom_smooth}} for details.}

\item{show_se}{Logical scalar, should the standard error be shown for a smoothed fit?}

\item{...}{Further arguments passed to \code{\link{plotRowData}}.}
}
\value{
A ggplot object.
}
\description{
Plot the frequency of expression (i.e., percentage of expressing cells) against the mean expression level for each feature in a SingleCellExperiment object.
}
\details{
This function plots gene expression frequency versus mean expression level, which can be useful to assess the effects of technical dropout in the dataset. 
We fit a non-linear least squares curve for the relationship between expression frequency and mean expression.
We use this curve to define the number of genes above high technical dropout and the numbers of genes that are expressed in at least 50\% and at least 25\% of cells. 

The plot will attempt to colour the points based on whether the corresponding features are labelled as feature controls in \code{object}.
This can be turned off by setting \code{controls=NULL}.
}
\examples{
data("sc_example_counts")
data("sc_example_cell_info")
example_sce <- SingleCellExperiment(
    assays = list(counts = sc_example_counts), 
    colData = sc_example_cell_info
)
example_sce <- normalize(example_sce)

example_sce <- calculateQCMetrics(example_sce, 
    feature_controls = list(set1 = 1:500))
plotExprsFreqVsMean(example_sce)

plotExprsFreqVsMean(example_sce, size_by = "is_feature_control")

}
\seealso{
\code{\link{plotRowData}}
}
