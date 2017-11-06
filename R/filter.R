#' Filter sites by read coverage (total, per replicates etc.).
#'
#' \code{filter_coverage()} filters sites by customizable read coverage restrictions. 
#' Use \code{add_coverage()} first to add coverage fields to list.
#'
#' \itemize{
#'   \item cov -> total coverage
#'   \item cov1 or cov2 -> total coverage of condition 1 or 2
#'   \item covs1 or covs2 -> coverage of replicates from condition 1 or 2
#' }
#'
#' @param jacusa List object created by \code{read_jacusa()}.
#' @param field Vector of strings determines what coverage fileds should be 
#' carried used for filtering.
#' @param cov Vector or numeric value of the minimal read coverage. Must have 
#' same dimension as fields
#' 
#' @return Returns JACUSA list object of sites filtered by minimal read coverage
#'  according to field and cov.
#'
#' @examples
#' ## Keep sites that have a total read depth of at least 10 reads in 
#' ## condition 1 and each replicates of condition 2 has a minimal read coverage 
#' ## of 5 reads. 
#' jacusa <- filter_coverage(rdd, field = c("cov1", "covs2"), cov = c(10, 5))
#' 
#' @export 
filter_coverage <- function(jacusa, field, cov) {
	i <- mapply(function(f, c) {
							if (is.list(jacusa[[f]])) {
								j <- lapply(jacusa[[f]], function(x) {
														x >= c
								})
								j <- do.call(cbind, j)
								j <- apply(j, 1, function(x) {
													 all(x)
								})
								j
							} else {
							  jacusa[[f]] >= c
							}
	}, field, cov, SIMPLIFY = FALSE, USE.NAMES = FALSE)
	if (is.list(i)) {
		i <- do.call(cbind, i)
		i <- apply(i, 1, function(x) { all(x) })
	}

	jacusa <- filter_rec(jacusa, i)
	jacusa
}

#' Filter JACUSA results of RDD calls and ensure that sits is covered by minimal 
#' number of variant reads.
#'
#' \code{filter_min_variant_count()} Filters JACUSA result files of gDNA vs. cDNA 
#' comparisons and enforces a minimal number of variant bases in cDNA.
#' Per default gDNA is expected to be sample 1 and sample 2 to be cDNA!
#' Make sure the list contain fields: "bc1" and "bc2". Those fields 
#' corresponds to the bases that have been called for the sample.
#' The fields can be populated by calling \code{add_bc()}.
#'
#' @param jacusa List object created by \code{read_jacusa()} and \code{add_base()}.
#' @param min_count Numeric value that specifies the minimal number of variant reads in sample 2 or cDNA.
#' @return Returns List of sites that have at least min_count variant reads in cDNA.
#'
#' @examples
#' ## Filters sites that have less than 2 variant reads in the cDNA sample. 
#' jacusa <- add_bc_matrix(rdd)
#' jacusa <- add_bc(jacusa)
#' jacusa <- filter_min_variant_count(jacusa, min_count = 2)
#' 
#' @export
filter_min_variant_count <- function(jacusa, min_count = 2) {
	count <- get_variant_count(jacusa$bc1, jacusa$bc2, jacusa$bc_matrix2)

	f <- c()
	if (is.list(count)) {
		f <- lapply(count, function(x) {
			x < min_count
		})
		f <- do.call(cbind, f)
		f <- apply(f, 1, any)
	} else {
		f <- count < min_count
	}
	jacusa <- filter_rec(jacusa, ! f)
	jacusa
}

#' Filter sites by the number of alleles per site.
#'
#' Removes sites that have too many alleles.
#'
#' @param jacusa List object create by \code{read_jacusa()}.
#' @param max_alleles Integer number of maximal alleles per site.
#'
#' @return Returs JACUSA list object with sites where max_alleles is obeyed.
#' 
#' @export
filter_allele_count <- function(jacusa, max_alleles = 2) {
  count <- get_allele_count(jacusa$bc_matrix1, jacusa$bc_matrix2)
  # get index of sites with <= max_alleles alleles
  i <- count <= max_alleles
  filter_rec(jacusa, i)
}

#' Retains sites that contain the variant base in all replicates of at least one sample.
#'
#' \code{filter_robust_variants} Enforces that at least one sample contains the variant base in all replicates. 
#'
#' @param jacusa List object created by \code{read_jacusa()}.
#' 
#' @return Returns List with sites where at least one sample contains the variant base in all replicates.  
#'
#' @examples
#' jacusa <- add_bc_matrix(rdd)
#' jacusa <- filter_robust_variants(jacusa)
#' 
#' @export 
filter_robust_variants <- function(jacusa) {
	i <- get_robust_variant_index(jacusa$bc_matrix1, jacusa$bc_matrix2)
	jacusa <- filter_rec(jacusa, i)
	jacusa
}

#' Filter JACUSA List object recursively.
#'
#' \code{filter_rec()} filters list of sites recursively.
#'
#' @param jacusa List object created by \code{read_jacusa()}.
#' @param index Vector of sites that should be retained.
#'
#' @return Returns List with sites that are contained in vector f.
#'
#' @examples 
#' ## calculate variant count
#' jacusa <- add_bc_matrix(rdd)
#' jacusa <- add_bc(jacusa)
#' variant_count <- get_variant_count(jacusa$bc1, jacusa$bc2, jacusa$bc_matrix2)
#' ## create index of sites that contain at least 10 variant bases
#' m <- do.call(cbind, variant_count)
#' index <- apply(m, 1, function(x) all(x >= 10))
#' ## filter data according to index
#' filtered <- filter_rec(jacusa, index)
#' 
#' @export 
filter_rec <- function(jacusa, index) {
  lapply(jacusa, function(x) {
    if (is.list(x)) {
      lapply(x, function(e) {
        if (is.matrix(e)) {
          e[index, ]
        } else {
          e[index]
        }
      })
    } else if (is.matrix(x)) {
      x[index, ]
    } else {
      x[index]
    }
  })
}

#' Filter JACUSA list of sites by test-statistic from call method.
#'
#' \code{filter_call_stat()} removes sites that have a test-statistic less than some threshold that has been provided by user.
#'
#' @param jacusa List object created by \code{read_jacusa()}.
#' @param stat Numeric value that represents the minimal test-statistic.
#' 
#' @return Returns List with sites with a test-statistic >= stat.
#' 
#' @export 
filter_call_stat <- function(jacusa, stat) {
	i <- jacusa$stat >= stat
	filter_rec(jacusa, i)
}

#' Filter JACUSA list of sites by p-value from rt-arrest method.
#'
#' \code{filter_rt_arrest_stat} removes sites that have a p-value more than some threshold that has been provided by user.
#'
#' @param jacusa List object created by \code{read_jacusa()}.
#' @param pvalue Numeric value that represents the maximal p-value.
#' 
#' @return Returns List with sites with a stat <= pvalue.
#' 
#' @export 
filter_rt_arrest_stat <- function(jacusa, pvalue) {
	i <- jacusa$pvalue <= pvalue
	filter_rec(jacusa, i)
}