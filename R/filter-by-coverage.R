#' Filter sites by read coverage (total, per replicates etc.)
#'
#' Filters sites by customizable read coverage restrictions. 
#' 
#' Possible value for \code{type}:
#' \itemize{
#'   \item total -> total read depth at a site,
#'   \item condition -> per condition (aggregates per condition), and
#'   \item replicate -> each replicate (default)
#' }
#'
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()}.
#' @param min_coverage numeric value of the minimal read coverage.
#' @param type character vector determines how and if read depth should be aggregated before filtering.
#' @return JACUSA2 result object with sites filtered by minimal read coverage according to \code{type}.
#'
#' @export 
filter_by_coverage <- function(result, min_coverage, type = "replicate") {
  if (! is.numeric(min_coverage) | min_coverage < 0) {
    stop("min_coverage not a number or negative: ", min_coverage)
  }

  # add coverage on demand
  if (is.null(result[["coverage"]])) {
    result <- add_coverage(result)
  }

  get_coverage <- function(primary, base_type, coverage) {
    coverage[primary & base_type == "total"]
  }

  if (type == "total") {
    result <- result %>% 
      group_by_site("meta_condition") %>% 
      dplyr::filter(sum(get_coverage(primary, base_type, coverage)) >= min_coverage)
  } else if(type == "condition") {
    result <- result %>% 
      group_by_site(c("meta_condition", "condition")) %>%
      dplyr::mutate(coverage_per_condition = sum(get_coverage(primary, base_type, coverage))) %>%
      dplyr::ungroup() %>%
      group_by_site("meta_condition") %>%
      dplyr::filter(all(coverage_per_condition >= min_coverage)) %>%
      dplyr::select(-coverage_per_condition)
  } else if (type == "replicate") {
    result <- result %>% 
      group_by_site("meta_condition") %>%
      dplyr::filter(all(get_coverage(primary, base_type, coverage) >= min_coverage))
  } else {
    stop("Unknown parameter type: ", type)
  }
  
  dplyr::ungroup(result)
}
