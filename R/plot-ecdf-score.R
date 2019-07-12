#' Plot cumulative score.
#' 
#' TODO use plot_ecdf_column, adjust to make meta_condition, condition, and replicate dependent
#' 
#' @importFrom tibble add_column
#' @importFrom magrittr %>%
#' @importFrom rlang syms
#' @param result object created by \code{read_result()} or \code{read_results()}
#' @param data_desc vector of strings providing details
#' @param column character string specifies column of score
#' @return plot object
#'
#' @export
plot_ecdf_score <- function(result, data_desc, column = "score") {
  if (nrow(result) != length(data_desc)) {
    stop("data_desc does not match number of entries of result")
  }

  check_column_exists(result, column)

  result <- tibble::add_column(result, data_desc = data_desc)

  # add fake meta_condition to use existing plot code
  if (! "meta_condition" %in% names(results)) {
    result$meta_condition <- "default"
  }

  # condense result:
  result <- dplyr::distinct(
    result, meta_condition, contig, start, end, strand, score, data_desc
  )

  meta_desc <- dplyr::distinct(
    result, meta_condition, data_desc
  )

  limits <- as.vector(meta_desc[["meta_condition"]])
  labels <- as.vector(meta_desc[["data_desc"]])

  p <- ggplot2::ggplot(
    result, 
    ggplot2::aes(
      x = !!rlang::sym(column), 
      colour = meta_condition
    )) +
    ggplot2::scale_colour_manual(
      name = "Data desription",
      labels = labels,
      limits = limits,
      values = meta_desc[["meta_condition"]] %>% as.integer()
    ) +
    ggplot2::xlab(field) +
    ggplot2::ylab("Density") +
    ggplot2::stat_ecdf(geom = "step")

  p
}
