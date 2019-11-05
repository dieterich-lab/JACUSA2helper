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
#' @param ... parameters forwared to plot_ecdf_column.
#' @return plot object
#'
#' @export
plot_ecdf_score <- function(result, data_desc, column = "score", ...) {
  if (nrow(result) != length(data_desc)) {
    stop("data_desc does not match number of entries of result")
  }
  check_column_exists(result, column)

  result$data_desc <- NULL
  result <- tibble::add_column(result, data_desc = data_desc)

  # add fake meta_condition to use existing plot code
  if (! META_CONDITION_COLUMN %in% names(result)) {
    result[[META_CONDITION_COLUMN]] <- as.factor("default")
  }
  # condense result:
  result <- dplyr::distinct(
    result, !!rlang::sym(META_CONDITION_COLUMN), contig, start, end, strand, !!rlang::sym(column), data_desc
  )

  plot_ecdf_column(result, column, result$data_desc, ...)
}
