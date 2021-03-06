% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calculateQCMetrics.R
\name{calculateQCMetrics}
\alias{calculateQCMetrics}
\title{Calculate QC metrics}
\usage{
calculateQCMetrics(object, exprs_values = "counts", feature_controls = NULL,
  cell_controls = NULL, percent_top = c(50, 100, 200, 500),
  detection_limit = 0, use_spikes = TRUE, compact = FALSE)
}
\arguments{
\item{object}{A SingleCellExperiment object containing expression values, usually counts.}

\item{exprs_values}{A string indicating which \code{assays} in the \code{object} should be used to define expression.}

\item{feature_controls}{A named list containing one or more vectors (a character vector of feature names, a logical vector, or a numeric vector of indices),
used to identify feature controls such as ERCC spike-in sets or mitochondrial genes.}

\item{cell_controls}{A named list containing one or more vectors (a character vector of cell (sample) names, a logical vector, or a numeric vector of indices),
used to identify cell controls, e.g., blank wells or bulk controls.}

\item{percent_top}{An integer vector. 
Each element is treated as a number of top genes to compute the percentage of library size occupied by the most highly expressed genes in each cell.
See \code{pct_X_top_Y_features} below for more details.}

\item{detection_limit}{A numeric scalar to be passed to \code{\link{nexprs}}, specifying the lower detection limit for expression.}

\item{use_spikes}{A logical scalar indicating whether existing spike-in sets in \code{object} should be automatically added to \code{feature_controls}, see \code{?\link{isSpike}}.}

\item{compact}{A logical scalar indicating whether the metrics should be returned in a compact format as a nested DataFrame.}
}
\value{
A SingleCellExperiment object containing QC metrics in the row and column metadata.
}
\description{
Compute quality control (QC) metrics for each feature and cell in a SingleCellExperiment object, accounting for specified control sets.
}
\details{
This function calculates useful quality control metrics to help with pre-processing of data and identification of potentially problematic features and cells. 

Underscores in \code{assayNames(object)} and in \code{feature_controls} or \code{cell_controls} can cause theoretically cause ambiguities in the names of the output metrics.
While problems are highly unlikely, users are advised to avoid underscores when naming their controls/assays.
}
\section{Cell-level QC metrics}{

Denote the value of \code{exprs_values} as \code{X}. 
Cell-level metrics are:
\describe{
\item{\code{total_X}:}{Sum of expression values for each cell (i.e., the library size, when counts are the expression values).}
\item{\code{log10_total_X}:}{Log10-transformed \code{total_X} after adding a pseudo-count of 1.}
\item{\code{total_features_by_X}:}{The number of features that have expression values above the detection limit.}
\item{\code{log10_total_features_by_X}:}{Log10-transformed \code{total_features_by_X} after adding a pseudo-count of 1.}
\item{\code{pct_X_in_top_Y_features}:}{The percentage of the total that is contained within the top \code{Y} most highly expressed features in each cell.
This is only reported when there are more than \code{Y} features. 
The top numbers are specified via \code{percent_top}.}
}

If any controls are specified in \code{feature_controls}, the above metrics will be recomputed using only the features in each control set. 
The name of the set is appended to the name of the recomputed metric, e.g., \code{total_X_F}.
A \code{pct_X_F} metric is also calculated for each set, representing the percentage of expression values assigned to features in \code{F}.

In addition to the user-specified control sets, two other sets are automatically generated when \code{feature_controls} is non-empty.
The first is the \code{"feature_control"} set, containing a union of all feature control sets;
and the second is an \code{"endogenous"} set, containing all genes not in any control set. 
Metrics are also computed for these sets in the same manner described above, suffixed with \code{_feature_control} and \code{_endogenous} instead of \code{_F}.

Finally, there is the \code{is_cell_control} field, which indicates whether each cell has been defined as a cell control by \code{cell_controls}. 
If multiple sets of cell controls are defined (e.g., blanks or bulk libraries), a metric \code{is_cell_control_C} is produced for each cell control set \code{C}.
The union of all sets is stored in \code{is_cell_control}.

All of these cell-level QC metrics are added as columns to the \code{colData} slot of the SingleCellExperiment object.
This allows them to be inspected by the user and makes them readily available for other functions to use.
}

\section{Feature-level QC metrics}{

Denote the value of \code{exprs_values} as \code{X}. 
Feature-level metrics are:
\describe{
\item{\code{mean_X}:}{Mean expression value for each gene across all cells.}
\item{\code{log10_mean_X}:}{Log10-mean expression value for each gene across all cells.}
\item{\code{n_cells_by_X}:}{Number of cells with expression values above the detection limit for each gene.}
\item{\code{pct_dropout_by_X}:}{Percentage of cells with expression values  below the detection limit for each gene.}
\item{\code{total_X}:}{Sum of expression values for each gene across all cells.}
\item{\code{log10_total_X}:}{Log10-sum of expression values for each gene across all cells.}
}

If any controls are specified in \code{cell_controls}, the above metrics will be recomputed using only the cells in each control set. 
The name of the set is appended to the name of the recomputed metric, e.g., \code{total_X_C}.
A \code{pct_X_C} metric is also calculated for each set, representing the percentage of expression values assigned to cells in \code{C}.

In addition to the user-specified control sets, two other sets are automatically generated when \code{cell_controls} is non-empty. 
The first is the \code{"cell_control"} set, containing a union of all cell control sets;
and the second is an \code{"non_control"} set, containing all genes not in any control set. 
Metrics are computed for these sets in the same manner described above, suffixed with \code{_cell_control} and \code{_non_control} instead of\code{_C}.

Finally, there is the \code{is_feature_control} field, which indicates whether each feature has been defined as a control by \code{feature_controls}. 
If multiple sets of feature controls are defined (e.g., ERCCs, mitochondrial genes), a metric \code{is_feature_control_F} is produced for each feature control set \code{F}.
The union of all sets is stored in \code{is_feature_control}.

These feature-level QC metrics are added as columns to the \code{rowData} slot of the SingleCellExperiment object.
They can be inspected by the user and are readily available for other functions to use.
}

\section{Compacted output}{

If \code{compact=TRUE}, the QC metrics are stored in the \code{"scater_qc"} field of the \code{colData} and \code{rowData} as a nested DataFrame. 
This avoids cluttering the metadata with QC metrics, especially if many results are to be stored in a single SingleCellExperiment object. 

Assume we have a feature control set \code{F} and a cell control set \code{C}.
The nesting structure in \code{scater_qc} in the \code{colData} is:
\preformatted{  scater_qc
  |-- is_cell_control
  |-- is_cell_control_C
  |-- all
  |   |-- total_counts
  |   |-- total_features_by_counts
  |   \-- ...
  +-- endogenous
  |   |-- total_counts
  |   |-- total_features_by_counts
      |-- pct_counts
  |   \-- ...
  +-- feature_control
  |   |-- total_counts
  |   |-- total_features_by_counts
      |-- pct_counts
  |   \-- ...
  \-- feature_control_F
      |-- total_counts
      |-- total_features_by_counts
      |-- pct_counts
      \-- ...
}
The nesting in \code{scater_qc} in the \code{rowData} is:
\preformatted{  scater_qc
  |-- is_feature_control
  |-- is_feature_control_F
  |-- all
  |   |-- total_counts
  |   |-- total_features_by_counts
  |   \-- ...
  +-- non_control 
  |   |-- total_counts
  |   |-- total_features_by_counts
      |-- pct_counts
  |   \-- ...
  +-- cell_control
  |   |-- total_counts
  |   |-- total_features_by_counts
      |-- pct_counts
  |   \-- ...
  \-- cell_control_C
      |-- total_counts
      |-- total_features_by_counts
      |-- pct_counts
      \-- ...
}

No suffixing of the metric names by the control names is performed here. 
This is not necessary when each control set has its own nested DataFrame.
}

\section{Renamed metrics}{

Several metric names have been changed in \pkg{scater} 1.7.5:
\itemize{
  \item \code{total_features} was changed to \code{total_features_by_X} 
  where \code{X} is the \code{exprs_values}. This avoids ambiguities if 
  \code{calculateQCMetrics} is called multiple times with different \code{exprs_values}.
  \item \code{n_cells_X} was changed to \code{n_cells_by_X}, to provide
  a more sensible name for the metric.
  \item \code{pct_dropout_X} was changed to \code{pct_dropout_by_X}.
  \item \code{pct_X_top_Y_features} was changed to \code{pct_X_in_top_Y_features}.
}

All of the old metric names will be kept alongside the new metric names when \code{compact=FALSE}.
Otherwise, only the new metric names will be stored.
The old metric names may be removed in future releases of \pkg{scater}.
}

\examples{
data("sc_example_counts")
data("sc_example_cell_info")
example_sce <- SingleCellExperiment(
    assays = list(counts = sc_example_counts), 
    colData = sc_example_cell_info
)
example_sce <- calculateQCMetrics(example_sce)

## with a set of feature controls defined
example_sce <- calculateQCMetrics(example_sce, 
feature_controls = list(set1 = 1:40))

## with a named set of feature controls defined
example_sce <- calculateQCMetrics(example_sce, 
     feature_controls = list(ERCC = 1:40))

}
\author{
Davis McCarthy, with (many!) modifications by Aaron Lun
}
