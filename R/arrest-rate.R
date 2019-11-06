#' Add arrest rate.
#' 
#' Adds arrest rate calculated from \code{arrest[_suffix]} and \code{through[_suffix]} columns.
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param suffix string added to specifiy base columns to calculate arrest rate. Default: NULL
#' @return result object with arrest rate field \code{arrest_rate[_suffix]} added.
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
#' Retrieves arrest rate from \code{arrest[_suffix]} and \code{through[_suffix]} columns.
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param suffix string added to specifiy base columns to retrieve arrest rate. Default: NULL
#' @return numeric vector with arrest rates for base counts with \code{suffix}.
#' @examples
#' data(HIVRT)
#' str(get_arrest_rate(HIVRT))
#' @export
get_arrest_rate <- function(result, suffix = NULL) {
  result[[arrest_rate_col(suffix)]]
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

#' Column name for arrest rate for \code{suffix}.
#' 
#' Column name for arrest ratio for \code{suffix}. 
#' \code{suffix} will be used to create the column name:
#' \code{arrest_rate[_suffix]}.
#' 
#' @param suffix string to specifiy base columns to retrieve arrest rate. Default: NULL
#' @return string the represents the column name for arrest rate with  marked \code{suffix}.
#' @export
arrest_rate_col <- function(suffix = NULL) {
  process_col(ARREST_RATE, suffix)
}

#' Column name for arrest base counts for \code{suffix}.
#' 
#' Column name for arrest base counts for \code{suffix}. 
#' \code{suffix} will be used to create the column name:
#' \code{arrest[_suffix]}".
#' 
#' @param suffix string to specifiy base columns to retrieve arrest bases Default: NULL
#' @return string the represents the column name for arrest bases marked with \code{suffix}.
#' @export
arrest_col <- function(suffix = NULL) {
  process_col(ARREST_COLUMN, suffix)
}

#' Column name for through base counts for \code{suffix}.
#' 
#' Column name for through base counts for \code{suffix}. 
#' \code{suffix} will be used to create the column name:
#' \code{through[_suffix]}".
#' 
#' @param suffix string to specifiy base columns to retrieve through bases Default: NULL
#' @return string the represents the column name for through bases marked with \code{suffix}.
#' @export
through_col <- function(suffix = NULL) {
  process_col(THROUGH_COLUMN, suffix)
}
