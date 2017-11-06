#' Add coverage fields to JACUSA list object.
#'
#' \code{add_coverage()} calculates and adds read coverage to list of sites. 
#' This function will add 5 fields to the initial list: 
#' cov1, cov2: total read coverage per sample,
#' covs1, covs2: read coverage per sample and replicate, and
#' cov: total read coverage (cov1 + cov2). 
#'
#' @param jacusa List object created by \code{read_jacusa()}.
#' 
#' @return Returns the initial list with coverage fields added.
#'
#' @examples
#' ## add coverage  to data
#' jacusa <- add_coverage(rdd)
#' ## filter/keep sites that have a total coverage of 30
#' jacusa <- filter_coverage(jacusa, "cov", 30)
#' 
#' @export 
add_coverage <- function(jacusa) {
	# internal helper function to calculate coverage
	.coverage <- function(bc_str, collapse = FALSE) {
		m <- bc_str2bc_matrix(bc_str, collapse = collapse)
		if (is.list(m)) {
			lapply(m, rowSums)
		} else {
			rowSums(m)
		}
	}

	jacusa[["cov1"]] <- .coverage(get_bc_str4condition(jacusa, 1), collapse = TRUE)
	jacusa[["covs1"]]  <- .coverage(get_bc_str4condition(jacusa, 1), collapse = FALSE)

	jacusa[["cov2"]] <- .coverage(get_bc_str4condition(jacusa, 2), collapse = TRUE)
	jacusa[["covs2"]]  <- .coverage(get_bc_str4condition(jacusa, 2), collapse = FALSE)

	jacusa[["cov"]] <- jacusa[["cov1"]] + jacusa[["cov2"]]
	jacusa
}
