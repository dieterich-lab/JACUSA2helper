#' Generic plot for cumulative data (EXPERIMENTAL)
#' 
#' Creates a generic plot of a \code{column} from a JACUSA2 \code{result} object and display  
#' verbose data descripton \code{data_desc}. 
#' 
#' The user must make sure that dimensions (rows and length) of: 
#' \code{result} and \code{data_desc} match and that \code{column} exists 
#' in \code{result}. Furthermore, the user is responsible for correct filtering and grouping of the 
#' \code{result} object.
#' \code{data_desc} is used to provide a descriptive name for each observation.
#' 
#' TODO make column replicate optional
#' 
#' @importFrom tibble add_column
#' @importFrom magrittr %>%
#' @importFrom rlang syms
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param column character string to be used for plotting.
#' @param data_desc vector of characters strings providing details about the sample.
#' @param name character string defines name of the legend.
#' @return ggplot2 plot object.
#'
#' @export
plot_ecdf_column <- function(result, column, data_desc, name = "Data description") {
  if (nrow(result) != length(data_desc)) {
    stop("data_desc does not match number of entries of result")
  }

  result <- tibble::add_column(result, data_desc)

  # switch: result has meta_condition or it does not
  # grouping changes
  columns <- c("replicate", "group", "data_desc")
  main <- ifelse("meta_condition" %in% names(result), "meta_condition", "condition")
  result$group <- interaction(
    result[[main]],
    result[["replicate"]]
  )
  columns <- c(main, columns)
  meta_desc <- dplyr::distinct(
    result, !!!rlang::syms(columns)
  )

  limits <- as.vector(meta_desc[["group"]])
  labels <- meta_desc[["data_desc"]]

  p <- ggplot2::ggplot(
    result, 
    ggplot2::aes(
      x = !!rlang::sym(column), 
      colour = group,
      linetype = group
    )) +
    ggplot2::scale_colour_manual(
      name = name,
      labels = labels,
      limits = limits,
      values = meta_desc[[main]] %>% as.integer()
    ) +
    ggplot2::scale_linetype_manual(
      name = name,
      labels = labels,
      limits = limits,
      values = meta_desc[["replicate"]] %>% as.integer()
    ) +
    ggplot2::xlab(column) +
    ggplot2::ylab("Density") +
    ggplot2::stat_ecdf(geom = "step")

  if ("meta_condition" %in% names(result)) {
    p <- p + ggplot2::facet_grid(~ condition)
  }

  p
}
