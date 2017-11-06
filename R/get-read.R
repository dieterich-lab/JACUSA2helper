#' Get string encoded read start, through, and end counts for a condition from a JACUSA 2.x result file.
#'
#' \code{get_read_str4condition()} returns read through and reads end count columns for a sample (1 or 2) from a JACUSA 2.x result file.
#'
#' @param jacusa List object created by \code{read_jacusa}.
#' @param condition Integer value: 1 or 2.
#'
#' @return Returns a list of strings that encode read start, through, and end counts.
#'
#' @export
get_read_str4condition <- function(jacusa, condition) {
  condition <- paste("reads", condition, sep = "")
  j <- grep(condition, names(jacusa))
  if (length(j) > 1) {
    jacusa[j]
  } else {
    jacusa[[j]]
  }
}
