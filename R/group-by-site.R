#' Groups JACUSA2 result object by coordinates and optional columns.
#' 
#' This is supposed to be used within a dplyr pipeline to
#' group JACUSA2 result object by coordinates: contig, start, end, strand -> a site. 
#' Possible values for opt_vars are:
#' "meta_condition", "arrest_pos", etc. This allows to correctly group in case of 
#' structured data that was generated with JACUSA2: rt-arrest, lrt-arrest and base stratification. 
#'  
#' @importFrom magrittr %>%
#' @importFrom rlang syms
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param opt_vars optional variables to group by (need NOT to be present).
#' @param ... forward options to dplyr::group_by.
#' @return grouped result object.
#' 
#' @export
group_by_site <- function(result, opt_vars = c(), ...) {
  vars <- SITE
  i <- opt_vars %in% colnames(result)
  if (any(i)) {
    vars <- c(vars, opt_vars[i])
  }

  dplyr::group_by(result, !!!rlang::syms(vars), ...)
}
