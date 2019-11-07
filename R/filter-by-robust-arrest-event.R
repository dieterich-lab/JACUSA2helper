#' Retains sites that contain an arrest event in all replicates in at least one condition.
#'
#' Enforces that at least one condition contains an arrest event in all replicates. 
#' The result object must be the output of the following JACUSA2 methods: 
#' \emph{rt-arrest} or \emph{lrt-arrest}.
#'
#' @importFrom magrittr %>%
#' @importFrom rlang syms
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param suffix string to specifiy base columns to filter on. Default: NULL
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
  cov_arrest_col <- cov_col(arrest_col(suffix))
  cov_through_col <- cov_col(through_col(suffix))
  check_column_exists(result, cov_arrest_col)
  check_column_exists(result, cov_through_col)

  result <- group_by_site(result, ...) %>%
    filter_by(
      robust_arrest_events(
        !!rlang::sym(CONDITION_COLUMN), 
        !!rlang::sym(cov_arrest_col), 
        !!rlang::sym(cov_through_col)
      )
    )
  dplyr::ungroup(result)
}

#' Helper to call \code{robust()}.
#' 
#' This is intended to be used within a \code{group_by_site()} statement.
#' Returns logical vector of robust sites requiring all values from
#' \code{arrest_cov} or \code{through_cov} to > 0 for at least one condition.
#' 
#' @param condition numeric vector of conditions.
#' @param arrest_cov numeric vector of coverage for arrest reads.
#' @param through_cov numeric vector of coverage for through reads.
#' @return logical vector of robust sites.
#' @export
robust_arrest_events <- function(condition, arrest_cov, through_cov) {
  df <- tibble::tibble(
    arrest_cov = arrest_cov,
    through_cov = through_cov,
  )
  robust(condition, df)
}
