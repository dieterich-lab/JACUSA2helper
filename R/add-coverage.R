#' Add coverage field to JACUSA2 data frame.
#'
#' \code{add_coverage()} calculates and adds read coverage. 
#'
#' @param jacusa2 data frame created by \code{read_result()}.
#' 
#' @return Returns the initial data frame with coverage field added.
#' 
#' @export 
add_coverage <- function(jacusa2) {
  jacusa2$coverage <- rowSums(jacusa2[, paste0("bc_", .BASES)])
  
  jacusa2
}