#' Save plot to disc
#'
#' TODO
#'
#' @param filename character vector TODO
#' @param plot object to be plotted TODO
#' @param ... parameters passed to 
#' 
#' @export
save_plot <- function(filename, plot, ...) {
  ggplot2::ggsave(filename, plot, ...)
}
