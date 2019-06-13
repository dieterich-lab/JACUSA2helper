#' Add coverage field to JACUSA2 object.
#'
#' \code{add_coverage()} calculates and adds read coverage. 
#'
#' @param jacusa2 object created by \code{read_result()}.
#' 
#' @return Returns the initial object with coverage key added.
#' 
#' @export 
add_coverage <- function(jacusa2) {
  jacusa2$coverage <- rowSums(jacusa2[, paste0("bc_", .BASES)])
  
  jacusa2
}
