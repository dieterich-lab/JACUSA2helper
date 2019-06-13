#' Plot cumulative read coverage
#' 
#' TODO
#' 
#' @param j2 object create by \code{read_result()}
#' @return plot object
#'
#' @export
plot_ecdf_coverage <- function(j2) {
  if (is.null(j2$coverage)) {
    j2 <- add_coverage(j2)
  }

  .plot_ecdf_column(j2, "coverage") +
    ggplot2::xlab("Read coverage")
  
}

# helper for plotting arbitrary columns from JACUSA2 object and 
# stratify by condition and replicate
.plot_ecdf_column <- function(j2, column) {
  conditions <- length(unique(j2$condition))
  replicates <- length(unique(j2$replicate))
  
  if (is.null(j2[[.DATA_DESC]])) {
    j2[[.DATA_DESC]] <- paste0("Cond. ", j2$condition, "  Rep. ", j2$replicate)
  }
  
  legend.title <- "Sample"
  # add description
  tmp_df <- data.frame(
    sample = as.factor(paste0(j2$condition, j2$replicate)), 
    data_desc = j2$data_desc,
    stringsAsFactors = FALSE
  )
  
  # FIXME
  labels <- dplyr::distinct(tmp_df, sample, data_desc)$data_desc
  
  p <- ggplot2::ggplot(
    j2, 
    ggplot2::aes_(
      x = as.name(column), 
      colour = tmp_df$sample, 
      linetype = tmp_df$sample
    )) +
    ggplot2::xlab(column) +
    ggplot2::ylab("Density") +
    ggplot2::stat_ecdf(geom = "step") + 
    ggplot2::scale_color_manual(
      legend.title,
      values = rep(1:conditions, each = replicates),
      labels = labels
    ) + 
    ggplot2::scale_linetype_manual(
      legend.title,
      values = rep(1:replicates, conditions),
      labels = labels
    )
  
  p
}

#' Plot TODO
#' 
#' TODO
#' 
#' @param js2 object \code{read_results()}
#' @param column to be used for plotting
#' @return Plot TODO
#'
#' @export
plot_meta_ecdf_column <- function(js2, column) {
  legend.title <- "Condition"

  p <- ggplot2::ggplot(
    js2, 
    aes_(
      x = as.name(column), 
      colour = quote(meta_condition), 
      linetype = quote(meta_condition)
    )) +
    ggplot2::xlab(column) +
    ggplot2::ylab("Density") +
    ggplot2::stat_ecdf(geom = "step") + 
    ggplot2::guides(
      colour = ggplot2::guide_legend(legend.title), 
      linetype = ggplot2::guide_legend(legend.title)
    )
  
  p
}

#' Save plot to disc
#'
#' TODO
#'
#' @param filename character vector TODO
#' @param plot object to be plotted TODO
#' 
#' @export
save_plot <- function(filename, plot, ...) {
  ggplot2::ggsave(filename, plot, ...)
}
