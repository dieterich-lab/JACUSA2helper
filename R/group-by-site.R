#' Group JACUSA2 result object by coordinates
#' 
#' TODO
#'  
#' @importFrom magrittr %>%
#' @importFrom rlang syms
#' @param result object created by \code{read_result(s)()}.
#' @param opt_vars optional variables to group by (need to be present)
#' @param ... forward options to dplyr::group_by
#' @return grouped JACUSA2 result object
#' 
#' @export
group_by_site <- function(result, opt_vars = c(), ...) {
  i <- opt_vars %in% colnames(result)
  if (any(i)) {
    opt_vars <- opt_vars[i]
    result <- result %>%
      dplyr::group_by(contig, start, end, strand, !!!rlang::syms(opt_vars), ...)
  } else {
    result <- result %>%
      dplyr::group_by(contig, start, end, strand, ...)
  }

  result
}
