#' Plot cumulative allele count.
#' 
#' Plots cumulative distribution of allele counts for single and multiple JACUSA2 result objects.
#' @seealso \code{plot_ecdf_column()}
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param data_desc vector of characters strings providing details about the sample.
#' @param allele_count_column character sting specifing the name of the column.
#' @return ggplot2 plot object.
#'
#' @export
plot_ecdf_allele_count <- function(result, data_desc, allele_count_column = "allele_count") {
  p <- plot_ecdf_column(result, allele_count, data_desc) + 
    ggplot2::xlab("Allele count")

  p
}
