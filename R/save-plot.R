#' Saves plot.
#'
#' Wrapper to save plot using ggplot2::ggsave.
#'
#' @param filename character string naming a file for writing.
#' @param plot the ggplot2 plot object to be written.
#' @param ... parameters passed to ggplot2::ggsave
#' 
#' @export
save_plot <- function(filename, plot, ...) {
  ggplot2::ggsave(filename, plot, ...)
}
