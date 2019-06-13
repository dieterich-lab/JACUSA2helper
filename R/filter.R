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
#' @param jacusa2 JACUSA2 object created by \code{read_result()}.
#' @param min_coverage Numeric value of the minimal read coverage.
#' @param type Strings determines how and if read depth should be aggregate before filtering. 
#' 
#' @return Returns JACUSA2 object of sites filtered by minimal read coverage according to \code{type}.
#'
#' @export 
#' @importFrom magrittr "%>%"
filter_by_coverage <- function(jacusa2, min_coverage, type = "replicate") {
  if (is.null(jacusa2$coverage)) {
    jacusa2 <- add_coverage(jacusa2)
  }
  
  if (! is.numeric(min_coverage) | min_coverage < 0) {
    stop("min_coverage not a number or negative: ", min_coverage)
  }
  if (type == "total") {
    jacusa2 <- jacusa2 %>% 
      dplyr::group_by(id) %>% 
      dplyr::filter(sum(coverage) >= min_coverage)
  } else if(type == "condition") {
    jacusa2 <- jacusa2 %>% 
      dplyr::group_by(id, condition) %>%
      dplyr::filter(sum(coverage) >= min_coverage)
  } else if (type == "replicate") {
    jacusa2 <- jacusa2 %>% 
      dplyr::group_by(id) %>%
      dplyr::filter(all(coverage >= min_coverage))
  } else {
    stop("Unknown parameter type: ", type)
  }

	as.data.frame(jacusa2)
}

#' Filter sites by the number of alleles per site.
#'
#' Removes sites that have too many alleles.
#'
#' @param jacusa2 object created by \code{read_result()}.
#' @param max_alleles integer number of maximal allowed alleles per site.
#' @param ref_base boolean indicating ref_base should used to count alleles per site (Default: TRUE).
#'
#' @return Returns JACUSA2 object with sites where max_alleles is obeyed.
#' 
#' @export
filter_by_alleles <- function(jacusa2, max_alleles = 2, ref_base = TRUE) {
  jacusa2 <- jacusa2 %>% dplyr::group_by(id)
    
  if (ref_base) {
    jacusa2 <- jacusa2 %>% 
      dplyr::filter(.get_alleles(paste0(bc, ref_base)) <= max_alleles)
  } else {
    jacusa2 <- jacusa2 %>% 
      dplyr::filter(.get_alleles(bc) <= max_alleles)
  }

  as.data.frame(jacusa2)
}

#' Retains sites that contain the variant base in all replicates in at least one condition.
#'
#' \code{filter_robust_variants} Enforces that at least one condition contains the variant base in all replicates. 
#'
#' @param jacusa2 object created by \code{read_result()}.
#' 
#' @return Returns JACUSA2 object with sites where at least one condition contains the variant base in all replicates.  
#' 
#' @export 
filter_robust_variants <- function(jacusa2) {
  conditions <- jacusa2$condition %>% unique() %>% length()
  # check only two conditions
  if (conditions != 2) {
    stop("Only 2 conditions are supported!")
  }
  # check only two alleles per site
  if (! check_max_alleles(jacusa2, max_alleles = 2)) {
    stop("Data contains sites with >2 alleles. Please remove those sites.")
  }

  jacusa2 <- jacusa2 %>% 
    dplyr::group_by(id) %>%
    dplyr::filter(get_robust_variants(condition, bc_A, bc_C, bc_G, bc_T))

	jacusa2
}

#' Restain sites with minimal score.
#'
#' \code{filter_by_score} removes sites that have score >= min_score.
#'
#' @param jacusa2 JACUSA2 object created by \code{read_result()}.
#' @param min_score Numeric value that represents the minimal score.
#' 
#' @return Returns JACUSA2 object with sites with score >= min_score
#' 
#' @export 
filter_by_min_score <- function(jacusa2, min_score) {
	subset(jacusa2, jacusa2$score >= min_score)
}

#' Restain sites with maximal score.
#'
#' \code{filter_by_score} removes sites that have score <= min_score.
#'
#' @param jacusa2 JACUSA2 object created by \code{read_result()}.
#' @param max_score Numeric value that represents the maximal score.
#' 
#' @return Returns JACUSA2 object with sites with score <= max_score.
#' 
#' @export 
filter_by_max_score <- function(jacusa2, max_score) {
  subset(jacusa2, jacusa2$score <= max_score)
}
