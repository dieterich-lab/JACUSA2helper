#' TODO
#' 
#' TODO
#'  
#' @importFrom magrittr %>%
#' @importFrom rlang syms
#' @param result object created by \code{read_result(s)()}.
#' @param opt_vars TODO
#' @param ... TODO
#' @return TODO
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
