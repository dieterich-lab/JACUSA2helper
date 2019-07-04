#' Add coverage field to JACUSA2 result object.
#'
#' Calculates and adds read coverage. 
#'
#' @param result created by \code{read_result*()}
#' @return result object with coverage field added.
#' 
#' @export 
add_coverage <- function(result) {
  rowSums(result[, paste0("bc_", .BASES)])
}
