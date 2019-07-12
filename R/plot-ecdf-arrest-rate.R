#' Plot cumulative arrest rate.
#' 
#' Plots cumulative distribution of arrest rate for single and multiple JACUSA2 result objects.
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param data_desc vector of characters strings providing details about the sample.
#' @param arrest_rate_column character sting specifing the name of the column.
#' @return ggplot2 plot object.
#' 
#' @export
plot_ecdf_arrest_rate <- function(result, data_desc, arrest_rate_column = "arrest_rate") {
  check_jacusa_method(result, c(RT_ARREST_METHOD_TYPE, LRT_ARREST_METHOD_TYPE))
  p <- plot_ecdf_column(result, arrest_rate_column, data_desc, name) + 
    ggplot2::xlab("Arrest rate")

  p
}
