#' Plot distribution of base substitutions.
#' 
#' Plots the distribution of base substitutions.
#' The user is responsible for correct filtering and grouping of the 
#' \code{result} object.
#' 
#' @importFrom tibble add_column
#' @importFrom magrittr %>%
#' @importFrom rlang sym
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param column character string to be used for plotting.
#' @return ggplot2 plot object.
#' @examples
#' library(magrittr)
#' data(rdd)
#' # 1st condition is gDNA - we use it to define ref_base
#' result <- redefine_ref_base(rdd, condition = 1)
#' result <- add_sub(rdd)
#' # filter by coverage and score
#' filtered <- result %>% 
#'   filter_by_coverage(min_coverage = 10) %>% 
#'   filter_by_min_score(min_score = 2)
#' plot_sub(filtered) + ggplot2::facet_grid(replicate ~ .)
#' @export
plot_sub <- function(result, column = "sub") {
  check_column_exists(result, column)
  p <- ggplot2::ggplot(result, ggplot2::aes(x = !!rlang::sym(column), fill = !!rlang::sym(column))) +
    ggplot2::geom_bar() +
    ggplot2::xlab("Base substitution")  +
    ggplot2::scale_fill_discrete(name = "Base substitution") +
    ggplot2::theme(
      legend.position = "bottom", 
      axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust=1)
    )

  p
}
