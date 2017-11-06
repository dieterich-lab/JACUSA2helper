#' Convert read start, through, and end counts encoded as string vectors.
#' 
#' \code{read_str2read_matrix()} converts read start, through ,and end counts 
#' string vectors to count matrices.
#' 
#' @param read_str Vector of strings or list of string vectors that encode 
#' counts of read start, through, and end.
#' @param collapse Logical indicates if counts from replicates should be aggregated.
#' 
#' @return Returns a matrix or a list of matrices of read start, through, and 
#' end counts.
#' 
#' @export 
read_str2read_matrix <- function(read_str, collapse = FALSE) {
	if (is.list(read_str))  {
		m <- lapply(read_str, .read_str2read_matrix)
		if (collapse) {
			m <- Reduce('+', m)
		}
		m
	} else {
		.read_str2read_matrix(read_str)
	}
}

# this helper function will convert one column vector e.g.: [read through, read end] = 10,2 
# to a matrix
.read_str2read_matrix <- function(read_str) { 
	l <- strsplit(read_str, ",")
	m <- do.call(rbind, l)
	class(m) <- "numeric"
  if (dim(m)[2] == 3) {
	  colnames(m) <- .READ # jacusa debug format 
  } else {
    colnames(m) <- .RT # jacusa result format
  }
	m
}
