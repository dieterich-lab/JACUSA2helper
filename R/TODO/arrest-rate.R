#' Add arrest rate.
#' 
#' Calculates and adds arrest rate from \code{arrest} and \code{through} columns.
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @return result object with arrest rate field \code{arrest_rate} added.
#'
#' @export
add_arrest_rate <- function(result) {
  df <- GenomicRanges::mcols(result)[, c(.ARREST_COL, .THROUGH_COL)]
  arrest_covs <- coverage(df[[.ARREST_COL]])
  through_covs <- coverage(df[[.THROUGH_COL]])

  stopifnot(names(arrest_covs) == names(through_covs))

  tmp <- mapply(function(arrest, through) {
    arrest_rate(arrest, through) %>% dplyr::as_tibble()
  }, arrest_covs, through_covs, SIMPLIFY = FALSE)
  GenomicRanges::mcols(result)[[.ARREST_RATE_COL]] <- tmp %>% dplyr::as_tibble()
  
  result
}

#' Calculate arrest rate.
#' 
#' Calculates arrest rate from arrest and through reads.
#' 
#' @param arrest_cov numeric vector of read coverage that exhibit read arrest.
#' @param through_cov numeric vector of read coverage that DO NOT exhibit read arrest.
#' @return numeric vector of arrest rates.
#' @examples
#' arrest_cov <- c(10, 1, 0)
#' through_cov <- c(0, 1, 1)
#' str(arrest_rate(arrest_cov, through_cov))
#' @export
arrest_rate <- function(arrest_cov, through_cov) {
  arrest_cov / (arrest_cov + through_cov)
}
