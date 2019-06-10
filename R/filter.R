#' Filter sites by read coverage (total, per replicates etc.).
#'
#' \code{filter_by_coverage()} filters sites by customizable read coverage restrictions. 
#' Use \code{add_coverage()} first to add coverage info.
#' 
#' Possible value for \code{type}:
#' \itemize{
#'   \item total -> total read depth at a site
#'   \item condition -> per condition (aggregates per condition)
#'   \item replicate -> each replicate (default)
#' }
#'
#' @param jacusa2 JACUSA2 object created by \code{read_result()}.
#' @param min_coverage Vector or numeric value of the minimal read coverage. Must have 
#' @param type Strings determines how and if read depth should be aggregate before filtering. 
#' same dimension as fields
#' 
#' @return Returns JACUSA2 object of sites filtered by minimal read coverage
#'  according to \code{type}.
#'
#' @examples
#' ## Keep sites that have a total read depth of at least 10 reads in 
#' ## condition 1 and each replicates of condition 2 has a minimal read coverage 
#' ## of 5 reads. 
#' 
#' @export 
#' @importFrom magrittr "%>%"
filter_by_coverage <- function(jacusa2, min_coverage, type = "replicate") {
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
      dplyr::group_by(id, condition, replicate) %>%
      dplyr::filter(sum(coverage) >= min_coverage)
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
#' @param max_alleles Integer number of maximal allowed alleles per site.
#'
#' @return Returns JACUSA2 object with sites where max_alleles is obeyed.
#' 
#' @export
filter_by_alleles <- function(jacusa2, max_alleles = 2) {
  jacusa2 <- jacusa2 %>%
    dplyr::group_by(id) %>%
    dplyr::filter(.get_alleles(bc) <= max_alleles)
  
  jacusa2
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
  if (conditions > 2) {
    stop("More than 2 conditions are not supported!")
  }
  # check only two alleles per site
  if (! check_max_alleles(jacusa2, max_alleles = 2)) {
    stop("Data contains sites with >2 alleles. Please remove those sites.")
  }

  jacusa2 <- jacusa2 %>% 
    group_by(id, condition) %>%
    filter(get_robust_variants(condition, bc_A, bc_C, bc_G, bc_T))

	jacusa2
}

#' Filter JACUSA2 object sites by test-statistic from call method.
#'
#' \code{filter_by_call_score()} removes sites that have a test-statistic less than some threshold that has been provided by user.
#'
#' @param jacusa2 data frame created by \code{read_result()}.
#' @param min_score Numeric value that represents the minimal test-statistic.
#' 
#' @return Returns data frame with sites with a test-statistic >= min_score.
#' 
#' @export 
filter_by_call_score <- function(jacusa2, min_score) {
  subset(jacusa2, jacusa2$score >= min_score)
}

#' Filter JACUSA2 object by p-value from rt-arrest method.
#'
#' \code{filter_by_arrest_stat} removes sites that have a p-value more than some threshold that has been provided by user.
#'
#' @param jacusa2 List object created by \code{read_result()}.
#' @param max_pvalue Numeric value that represents the maximal p-value.
#' 
#' @return Returns data frame with sites with a stat <= max_pvalue.
#' 
#' @export 
filter_by_arrest_stat <- function(jacusa2, max_pvalue) {
	subset(jacusa2, jacusa2$pvalue <= max_pvalue)
}