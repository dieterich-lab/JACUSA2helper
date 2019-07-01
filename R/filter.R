#' Filter sites by read coverage (total, per replicates etc.).
#'
#' \code{filter_by_coverage()} filters sites by customizable read coverage restrictions. 
#' 
#' Possible value for \code{type}:
#' \itemize{
#'   \item total -> total read depth at a site,
#'   \item condition -> per condition (aggregates per condition), and
#'   \item replicate -> each replicate (default)
#' }
#'
#' @param result object created by \code{read_result()}.
#' @param min_coverage Numeric value of the minimal read coverage.
#' @param type Strings determines how and if read depth should be aggregate before filtering. 
#' 
#' @return JACUSA2 result object with sites filtered by minimal read coverage according to \code{type}.
#'
#' @export 
#' @importFrom magrittr "%>%"
filter_by_coverage <- function(result, min_coverage, type = "replicate") {
  if (is.null(result$coverage)) {
    result <- add_coverage(result)
  }
  
  if (! is.numeric(min_coverage) | min_coverage < 0) {
    stop("min_coverage not a number or negative: ", min_coverage)
  }
  # FIXME
  if (type == "total") {
    result <- result %>% 
      dplyr::group_by(id) %>% 
      dplyr::filter(sum(coverage) >= min_coverage)
  } else if(type == "condition") {
    result <- result %>% 
      dplyr::group_by(id, condition) %>%
      dplyr::filter(sum(coverage) >= min_coverage)
  } else if (type == "replicate") {
    n <- length(unique(result$condition)) * length(unique(result$replicate))
    result <- result %>% 
      dplyr::filter(coverage >= min_coverage) %>%
      dplyr::group_by(id) %>%
      dplyr::filter(dplyr::n() == n)
  } else {
    stop("Unknown parameter type: ", type)
  }

	as.data.frame(result)
}

#' Filter sites by the number of alleles per site.
#'
#' Removes sites that have too many alleles.
#'
#' @param result object created by \code{read_result()}.
#' @param max_alleles integer number of maximal allowed alleles per site.
#' @param ref_base boolean indicating ref_base should used to count alleles per site (Default: TRUE).
#'
#' @return Returns JACUSA2 result object with sites where max_alleles is obeyed.
#' 
#' @export
filter_by_alleles <- function(result, max_alleles = 2, use_ref_base = TRUE) {
  result <- result %>% dplyr::group_by(id)
    
  if (use_ref_base) {
    result <- result %>% 
      dplyr::filter(.get_alleles(paste0(bc, ref_base)) <= max_alleles)
  } else {
    result <- result %>% 
      dplyr::filter(.get_alleles(bc) <= max_alleles)
  }

  as.data.frame(result)
}

#' Retains sites that contain the variant base in all replicates in at least one condition.
#'
#' \code{filter_robust_variants} Enforces that at least one condition contains the variant base in all replicates. 
#'
#' @param result object created by \code{read_result()}.
#' 
#' @return Returns JACUSA2 result object with sites where at least one condition contains the variant base in all replicates.  
#' 
#' @export 
filter_robust_variants <- function(result) {
  conditions <- result$condition %>% unique() %>% length()
  # check only two conditions
  if (conditions != 2) {
    stop("Only 2 conditions are supported!")
  }
  # check only two alleles per site
  if (! check_max_alleles(result, max_alleles = 2)) {
    stop("Data contains sites with >2 alleles. Please remove those sites.")
  }

  result <- result %>% 
    dplyr::group_by(id) %>%
    dplyr::filter(get_robust_variants(condition, bc_A, bc_C, bc_G, bc_T))

	result
}

#' Restain sites with minimal score.
#'
#' \code{filter_by_score} removes sites that have score >= min_score.
#'
#' @param result object created by \code{read_result()}.
#' @param min_score Numeric value that represents the minimal score.
#' 
#' @return JACUSA2 result object with sites with score >= min_score
#' 
#' @export 
#' FIXME lrt-arrest
filter_by_min_score <- function(result, min_score) {
	subset(result, result$score >= min_score)
}

#' Restain sites with maximal score.
#'
#' \code{filter_by_score} removes sites that have score <= min_score.
#'
#' @param result object created by \code{read_result()}.
#' @param max_score Numeric value that represents the maximal score.
#' 
#' @return JACUSA2 result object with sites with score <= max_score.
#' 
#' @export 
#' FIXME lrt-arrest
filter_by_max_score <- function(result, max_score) {
  subset(result, result$score <= max_score)
}
