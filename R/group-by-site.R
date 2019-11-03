#' Groups JACUSA2 result object by coordinates and optional columns.
#' 
#' This is supposed to be used within a dplyr pipeline to
#' group JACUSA2 result object by coordinates: contig, start, end, strand -> a site. 
#' This allows to correctly group in case of structured data that was generated with JACUSA2: 
#' \emph{rt-arrest}, \emph{lrt-arrest}, and read/base stratification. 
#'  
#' @importFrom magrittr %>%
#' @importFrom rlang syms
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param ... forward options to dplyr::group_by.
#' @return grouped result object.
#' @export
group_by_site <- function(result, ...) {
  # TODO or id
  dplyr::group_by(result, !!!rlang::syms(SITE), ...)
}
