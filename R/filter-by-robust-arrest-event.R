#' Retains sites that contain an arrest event in all replicates in at least one condition.
#'
#' Enforces that at least one condition contains an arrest event in all replicates. 
#' The result object must be the output of the following JACUSA2 methods: 
#' \emph{rt-arrest} or \emph{lrt-arrest}.
#'
#' @importFrom magrittr %>%
#' @importFrom rlang syms
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param suffix TODO
#' @param ... passed to internal \code{group_by_site()}
#' @return result object with sites where at least one condition contains the arrest event in all replicates.
#' @examples
#' data(HIVRT)
#' result <- add_arrest_rate(HIVRT)
#  # default robust filtering
#' str(filter_by_robust_arrest_events(result))
#' # filtereing requiring a minimal difference between mean arrest rates from both conditions
#' # mean(arrest_rate1) - mean(arrest_rate2) >= 0.1
#' #str(filter_by_robust_arrest_events(result), min_diff = 0.1)
#' @export 
filter_by_robust_arrest_events <- function(result, suffix = NULL, ...) {
  require_method(
    result, c(RT_ARREST_METHOD_TYPE, LRT_ARREST_METHOD_TYPE)
  )
  
  arrest_col <- ARREST_COLUMN
  through_col <- THROUGH_COLUMN
  if (! is.null(suffix)) {
    arrest_col <- paste(arrest_col, suffix, sep = "_")
    through_col <- paste(through_col, suffix, sep = "_")
  }
  
  result <- group_by_site(result, ...) %>%
    filter_by(robust_arrest_events(condition, !!rlang::sym(arrest_col), !!rlang::sym(through_col)))

  dplyr::ungroup(result)
}

#' TODO
#' 
#' This is intended to be used within a \code{group_by_site()} statement. TODO
#' 
#' @param condition TODO
#' @param arrest_cov TODO
#' @param through_cov TODO
#' @return TODO
#' @examples
#' TODO
#' @export
robust_arrest_events <- function(condition, arrest_cov, through_cov) {
  df <- tibble::tibble(
    arrest_cov = arrest_cov,
    through_cov = through_cov,
  )
  
  robust(condition, df)
}
