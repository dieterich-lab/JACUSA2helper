#' Convert string encoded base call counts to base call count matrix.
#' 
#' \code{bc_str2bc_matrix()} converts base counts encoded string vectors to 
#' count matrices. Typically, the result of \code{get_bc_str4condition(jacusa, i)}, 
#' where i = 1 or 2 and \code{read_jacusa()}.
#' 
#' @param bc_str Vector of strings or list of string vectors where base counts (A,C,G,T) 
#' are separated by ",". 
#' @param collapse Logical indicates if base counts should be aggregated.
#' @return Returns a matrix or a list of matrices of base counts.
#'
#' @examples
#' ## Extract sequencing info for condition 1
#' bc_str1 <- get_bc_str4condition(rdd, 1)
#' ## Convert string encoded base counts to count matrices
#' bc_matrix1 <- bc_str2bc_matrix(bc_str1)
#' 
#' @export 
bc_str2bc_matrix <- function(bc_str, collapse = FALSE) {
	if (is.list(bc_str))  {
		m <- lapply(bc_str, .bc_str2bc_matrix)
		if (collapse) {
			m <- Reduce('+', m)
		}
		m
	} else {
		.bc_str2bc_matrix(bc_str)
	}
}

# this helper function will convert one base column vector e.g.: [A, C, G, T] = 10,0,0,0 
# to a matrix.
.bc_str2bc_matrix <- function(bc_str) { 
	l <- strsplit(bc_str, ",")
	m <- do.call(rbind, l)
	class(m) <- "numeric"
	colnames(m) <- .BASES
	m
}
