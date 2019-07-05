#' Save plot
#'
#' Saves plot using ggplot2::ggsave.
#'
#' @param filename character vector
#' @param plot object to be saved
#' @param ... parameters passed to ggplot2::ggsave
#' 
#' @export
save_plot <- function(filename, plot, ...) {
  ggplot2::ggsave(filename, plot, ...)
}
