#' Add arrest rate.
#' 
#' Calculates and adds arrest rate from \code{arrest} and \code{through} columns.
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param cores Integer defines how many cores to use.
#' @return result object with arrest rate field \code{arrest_rate} added.
#'
#' @export
add_arrest_rate <- function(result, cores = 1) {
  arrest_cov <- coverage(result[[.ARREST_COL]])
  through_cov <- coverage(result[[.THROUGH_COL]])

  result[[.ARREST_RATE_COL]] <- mapply_repl(arrest_rate, arrest_cov, through_cov)

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
