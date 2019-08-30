#' Adds base call change ratio to a JACUSA2 result object.
#' 
#' Calculates and adds base call change ratio (e.g.: editing frequency) 
#' to a JACUSA2 result object. The "ref_base2bc" column needs to be populated by 
#' calling \code{add_ref_base2bc()}. 
#' 
#' The following restrictions apply to column "ref_base2bc":
#' \itemize{
#'   \item There must be only one reference base. A->G is okay, but AG->G is NOT allowed!
#'   \item There must be only one non-reference base. A->G is okay, but A->CG is NOT allowed!
#' }
#' Make sure to filter \code{result} with \code{filter_by_alleles()} to comply with this restrictions.
#' 
#' @importFrom magrittr %>%
#' @param result created by \code{read_result()} or \code{read_results()}.
#' @param max_bc boolean TODO
#' @return result object with base change ratio added.
#' 
#' @export 
add_ref_base2bc_ratio <- function(result, max_bc = FALSE) {
  column <- "ref_base2bc"
  if (max_bc) {
    column <- "ref_base2max_bc"
  }
  column_ratio <- paste0(column, "_ratio")

  check_column_exists(result, column)
  ref_base <- result[[column]]
  
  # need to distinguish data:
  # * other or
  # * A->G "->"
  # when A->G available, ref. base "A" can be extracted
  # otherwise, ratio will be 0.0
  i <- grepl(BC_CHANGE_SEP, ref_base)
  if (any(i)) {
    ref_base[i] <- strsplit(result[[column]][i], BC_CHANGE_SEP) %>%
      lapply("[[", 1) %>%
      unlist()

    if (any(nchar(ref_base[i]) != 1)) {
      stop("More than 1 allele for reference base is not allowed!")
    }
    observed_bc <- strsplit(result[[column]][i], BC_CHANGE_SEP) %>%
      lapply("[[", 2) %>%
      unlist()
    if (any(nchar(observed_bc) > 1)) {
      stop("More than 1 allele for observed base call is not allowed!")
    }
  }

  # default ratio
  result[[column_ratio]] <- 0.0
  if (any(i)) {
    m <- result[i, paste0("bc_", BASES)]
    variant_bc <- NULL
    if (max_bc) {
      variant_bc <- result[["site_max_bc"]]
    }

    result[[column_ratio]][i] <- get_ref_base2bc_ratio(
      ref_base[i],
      m,
      variant_bc
    )
  }

  result
}
