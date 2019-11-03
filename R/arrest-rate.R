#' Add arrest rate.
#' 
#' Adds arrest rate calculated from \code{arrest[_suffix]} and \code{through[_suffix]} columns.
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param suffix TODO Default: NULL
#' @return result object with arrest rate field "arrest_rate[_\code{suffix}]" added.
#' @export
add_arrest_rate <- function(result, suffix = NULL) {
  check_column_exists(result, arrest_col(suffix))
  check_column_exists(result, through_col(suffix))
  
  result[[arrest_rate_col(suffix)]] <- arrest_rate(
    get_cov(result, arrest_col(suffix)),
    get_cov(result, through_col(suffix))
  )
  
  result
}

#' Retrieve arrest rate.
#' 
#' TODO
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param suffix TODO
#' @return numeric vector with arrest rates for base counts with \code{suffix}.
#' @examples
#' TODO
#' @export
get_arrest_rate <- function(result, suffix = NULL) {
  check_column_exists(arrest_arrest_col(read_sub))
  result[[arrest_rate_col(read_sub)]]
}

#' Calculate arrest rate.
#' 
#' Calculates arrest rate from read coverage from arrest and through reads.
#' 
#' @param arrest_cov numeric vector of read coverage that exhibit read arrest.
#' @param through_cov numeric vector of read coverage that DO NOT exhibit read arrest.
#' @return numeric vector of arrest rates.
#' @examples
#' arrest_cov <- c(10, 1, 0)
#' through_cov <- c(0, 1, 1)
#' str(arrest_rate(arrest_cov, thrugh_cov))
#' @export
arrest_rate <- function(arrest_cov, through_cov) {
  arrest_cov / (arrest_cov + through_cov)
}

#' Column name for arrest rate for \code{suffix}.
#' 
#' Column name for arrest ratio for \code{suffix}. 
#' \code{suffix} will be used a suffix to create the column name:
#' "arrest_rate[_\code{suffix}]".
#' 
#' @param suffix TODO
#' @return string the represents the column name for arrest rate for \code{suffix}.
#' @export
arrest_rate_col <- function(suffix = NULL) {
  process_col(ARREST_RATE, suffix)
}

#' Column name for arrest base counts for \code{suffix}.
#' 
#' Column name for arrest base counts for \code{suffix}. 
#' \code{suffix} will be used a suffix to create the column name:
#' "arrest[_\code{suffix}]".
#' 
#' @param suffix TODO
#' @return string the represents the column name for arrest for \code{suffix}.
#' @export
arrest_col <- function(suffix = NULL) {
  process_col(ARREST_COLUMN, suffix)
}

#' Column name for through base counts for \code{suffix}.
#' 
#' Column name for through base counts for \code{suffix}. 
#' \code{suffix} will be used a suffix to create the column name:
#' "through[_\code{suffix}]".
#' 
#' @param suffix TODO
#' @return string the represents the column name for through for \code{suffix}.
#' @export
through_col <- function(suffix = NULL) {
  process_col(THROUGH_COLUMN, suffix)
}
