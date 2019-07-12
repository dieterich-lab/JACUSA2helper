#' Generic matrix pairs plot of a column from a JACUSA2 result object. (EXPERIMENTAL)
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
#' @param result object created by \code{read_result()} or \code{read_results()}
#' @param column character string to be used for plotting.
#' @param data_desc vector of characters strings providing details about the sample.
#' @return ggplot2 plot object.
#' 
#' @export
plot_pairs_matrix <- function(result, column, data_desc) {
  if (nrow(result) != length(data_desc)) {
    stop("data_desc does not match number of entries of result")
  }
  check_column_exists(result, column)

  result$group <- data_desc
  result <- dplyr::filter(result, primary & base_type == "total")

  cols <- c(
    "group",
    "contig", "start", "end", "strand",
    column
  )
  result <- dplyr::select(result, !!!rlang::syms(cols))

  #
  df <- tidyr::spread(result, group, !!column)
  i <- which(colnames(df) %in% unique(data_desc))
  p <- GGally::ggpairs(df, columns = i)

  p
}
