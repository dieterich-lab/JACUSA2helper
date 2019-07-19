#' Plot cumulative score.
#'
#' The user is responsible for correct filtering and grouping of the 
#' \code{result} object.
#' \code{data_desc} is used to provide a descriptive name for each observation. 
#'
#' @importFrom tibble add_column
#' @importFrom magrittr %>%
#' @importFrom rlang sym
#' @param result object created by \code{read_result()} or \code{read_results()}
#' @param data_desc vector of strings providing details
#' @param column character string specifies column of score.
#' @return plot object
#'
#' @export
plot_ecdf_score <- function(result, data_desc, column = "score") {
  if (nrow(result) != length(data_desc)) {
    stop("data_desc does not match number of entries of result")
  }
  check_column_exists(result, column)

  result$data_desc <- NULL
  result <- tibble::add_column(result, data_desc = data_desc)

  # add fake meta_condition to use existing plot code
  if (! "meta_condition" %in% names(result)) {
    result$meta_condition <- as.factor("default")
  }
  # condense result:
  result <- dplyr::distinct(
    result, meta_condition, contig, start, end, strand, !!rlang::sym(column), data_desc
  )

  plot_ecdf_column(result, column, result$data_desc)
}
