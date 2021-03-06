% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/areSizeFactorsCentred.R
\name{centreSizeFactors}
\alias{centreSizeFactors}
\title{Centre size factors at unity}
\usage{
centreSizeFactors(object, centre = 1, grouping = NULL)
}
\arguments{
\item{object}{A SingleCellExperiment object containing any number (or zero) sets of size factors.}

\item{centre}{A numeric scalar, the value around which all sets of size factors should be centred.}

\item{grouping}{A factor specifying the grouping of cells, where size factors are centred to unity within each group.}
}
\value{
A SingleCellExperiment with modified size factors that are centred at unity.
}
\description{
Scales all size factors so that the average size factor across cells is equal to 1.
}
\details{
Centering of size factors at unity ensures that division by size factors yields values on the same scale as the raw counts.
This is important for the interpretation of the normalized values, as well as comaprisons between features normalized with different size factors (e.g., spike-ins).

Specification of \code{grouping} centres the size factors within each level of the provided factor.
This is useful if different batches are sequenced at different depth, by preserving the scale of counts within each batch.
}
\examples{

data("sc_example_counts")
data("sc_example_cell_info")
example_sce <- SingleCellExperiment(
    assays = list(counts = sc_example_counts), 
    colData = sc_example_cell_info
)

sizeFactors(example_sce) <- runif(ncol(example_sce))
sizeFactors(example_sce, "ERCC") <- runif(ncol(example_sce))
example_sce <- centreSizeFactors(example_sce)

mean(sizeFactors(example_sce))
mean(sizeFactors(example_sce, "ERCC"))

}
\seealso{
\code{\link{areSizeFactorsCentred}}
}
\author{
Aaron Lun
}
