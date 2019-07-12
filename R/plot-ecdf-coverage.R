#' Plot cumulative read coverage.
#' 
#' Plots cumulative distribution of read coverate for single and multiple JACUSA2 result objects.
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param data_desc vector of characters strings providing details about the sample.
#' @param coverage_column character sting specifing the name of the column.
#' @return ggplot2 plot object.
#' 
#' @export
plot_ecdf_coverage <- function(result, data_desc, coverage_column = "coverage") {
  p <- plot_ecdf_column(result, coverage, data_desc) + 
    ggplot2::xlab("Coverage")

  p
}
