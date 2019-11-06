#' Add coverage.
#' 
#' Adds coverage specific for base counts stored in column \code{base_type}.
#' 
#' @param result object created by \code{read_result()} or \code{redfsad_results()}.
#' @param base_type string defining the column to use as base counts. Default: bases.
#' @return result object with read coverage added.
#' @export
add_cov <- function(result, base_type = "bases") {
  check_column_exists(result, base_type)
  result[[cov_col(base_type)]] <- coverage(result[[base_type]])
  
  result
}

#' Retrieve coverage for \code{base_type}.
#' 
#' Retrieves coverge for base counts stored under \code{base_type}.
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param base_type string defining base counts that were used to define coverage. Default: bases.
#' @return numeric vector with coverage information for \code{base_type}.
#' @examples
#' data(HIVRT)
#' # coverage for ALL reads
#' str(get_cov(HIVRT))
#' # coverage for arrest reads 
#' str(get_cov(HIVRT, "arrest"))
#' # coverage for through reads 
#' str(get_cov(HIVRT, "through"))
#' @export
get_cov <- function(result, base_type = "bases") {
  result[[cov_col(base_type)]]
}

#' Calculate coverage from base counts.
#' 
#' Calculates coverage from base counts. 
#' \code{bases} is expected to be a nx4 matrix or data frame.
#' 
#' @param bases nx4 matrix or data frame of base call counts.
#' @return numeric vector of coverage for \code{bases}.
#' @examples
#' bases <- matrix(
#'   c( 1, 0, 0, 0,
#'     10, 0, 0, 0,
#'      6, 2, 0, 0),
#'   ncol = 4, 
#'   byrow = TRUE
#' )
#' str(coverage(bases))
#' @export
coverage <- function(bases) {
  rowSums(bases)
}

#' Column name for coverage for \code{base_type}.
#' 
#' Column name for coverage for \code{base_type}. 
#' \code{base_type} will be used to create the column name:
#' \code{coverage[_base_type]}. Using \code{base_type = "bases"} 
#' will result in the field \code{coverage}.
#' 
#' @param base_type string specifiying base column. Default: bases.
#' @return string that represents the column name for coverage for \code{base_type}.
#' @export
cov_col <- function(base_type = "bases") {
  process_col(COVERAGE, base_type)
}
