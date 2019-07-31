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
#' @importFrom tibble add_column
#' @importFrom magrittr %>%
#' @importFrom rlang syms
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param column character string to be used for plotting.
#' @param data_desc vector of characters strings providing details about the sample.
#' @param main_group character string to be used to define colour.
#' @param sub_group character string to be used to define linetype.
#' @param name character string defines name of the legend.
#' @return ggplot2 plot object.
#'
#' @export
plot_ecdf_column <- function(result, column, data_desc, main_group, sub_group = NULL, name = "Data description") {
  if (nrow(result) != length(data_desc)) {
    stop("'data_desc' does not match number of entries of 'result'")
  }

  result[["data_desc"]] <- NULL
  result <- tibble::add_column(result, data_desc)

  groups <- c(main_group)
  if (! is.null(sub_group)) {
    groups <- c(groups, sub_group)
  }
  result$group <- do.call(
    interaction,
    list(result[groups])
  )

  columns <- c(groups, "group", "data_desc")
  meta_desc <- dplyr::distinct(
    result, !!!rlang::syms(columns)
  )

  limits <- as.vector(meta_desc[["group"]])
  labels <- meta_desc[["data_desc"]]

  p <- NULL
  if (is.null(sub_group)) {
    p <- ggplot2::ggplot(
      result, 
      ggplot2::aes(
        x = !!rlang::sym(column), 
        colour = group
      )
    )
  } else {
    p <- ggplot2::ggplot(
      result, 
      ggplot2::aes(
        x = !!rlang::sym(column), 
        colour = group,
        linetype = group
      )
    )
  }

  p <- p + ggplot2::scale_colour_manual(
      name = name,
      labels = labels,
      limits = limits,
      values = factor(meta_desc[[main_group]]) %>% as.integer()
    )

  if (! is.null(sub_group)) {
    p <- p + ggplot2::scale_linetype_manual(
      name = name,
      labels = labels,
      limits = limits,
      values = factor(meta_desc[[sub_group]]) %>% as.integer()
    )
  }

  p <- p +
    ggplot2::xlab(column) +
    ggplot2::ylab("Density") +
    ggplot2::stat_ecdf(geom = "step")

  p
}
