#' Convert matrix to string representation.
#' 
#' Convert count matrix to vector of strings. Columns are separated by ",".
#' 
#' @param matrix Matrix or list of matrices.
#' 
#' @return Returns vector of Strings
#'
#' @export
matrix2str <- function(matrix) {
  if (is.list(matrix)) {
    lapply(matrix, .matrix2str)
  } else {
    .matrix2str(matrix) 
  }
}

# Helper function
.matrix2str <- function(matrix) {
  apply(matrix, 1, paste, collapse = ",")
}