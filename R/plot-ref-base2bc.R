#' Plot distribution of base changes.
#' 
#' TODO
#' 
#' The user is responsible for correct filtering and grouping of the 
#' \code{result} object.
#' \code{data_desc} is used to provide a descriptive name for each observation.
#' 
#' TODO make column replicate optional
#' 
#' @importFrom tibble add_column
#' @importFrom magrittr %>%
#' @importFrom rlang sym
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param column character string to be used for plotting.
#' @return ggplot2 plot object.
#'
#' @export
plot_ref_base2bc <- function(result, column = "ref_base2bc") {
  p <- ggplot2::ggplot(result, ggplot2::aes(x = !!rlang::sym(column), fill = !!rlang::sym(column))) +
    ggplot2::geom_bar() +
    ggplot2::xlab("Base change")  +
    ggplot2::scale_fill_discrete(name = "Base change") +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1))

  if ("meta_condition" %in% names(result)) {
    p <- p + ggplot2::facet_wrap(~ meta_condition)
  }

  p
}
