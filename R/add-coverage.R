#' Add coverage field to JACUSA2 result object.
#'
#' \code{add_coverage()} calculates and adds read coverage. 
#'
#' @param result object created by \code{read_result()}.
#' @return result object with coverage field added.
#' 
#' @export 
add_coverage <- function(result) {
  result$coverage <- rowSums(result[, paste0("bc_", .BASES)])
  
  result
}
