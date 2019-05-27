#' Add coverage fields to JACUSA2 list object.
#'
#' \code{add_coverage()} calculates and adds read coverage to list of sites. 
#'
#' @param jacusa2 data frame created by \code{read_jacusa()}.
#' 
#' @return Returns the initial data frame with coverage field added.
#'
#' # TODO @examples
#' ## add coverage  to data
#' #jacusa2 <- add_coverage(rdd)
#' ## filter/keep sites that have a total coverage of 30
#' #jacusa <- filter_coverage(jacusa, "cov", 30)
#' 
#' @export 
add_coverage <- function(jacusa2) {
  jacusa2$coverage <- jacusa2$bc_A + jacusa2$bc_C + jacusa2$bc_G + jacusa2$bc_T
  
  jacusa2
}