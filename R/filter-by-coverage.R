#' Filters sites by read coverage (total, per replicates, etc.)
#'
#' Filters sites by customizable read coverage restrictions. 
#' 
#' Possible value for "code":
#' \describe{
#'   \item{total}{total read depth at a site,}
#'   \item{condition}{per condition (aggregates per condition), and}
#'   \item{replicate}{each replicate (default).}
#' }
#'
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param min_coverage numeric value for the minimal read coverage.
#' @param type character string determines how read depth should be aggregated before filtering.
#' @return result object with sites filtered by minimal read coverage.
#'
#' @export 
filter_by_coverage <- function(result, min_coverage, type = "replicate") {
  if (! is.numeric(min_coverage) | min_coverage < 0) {
    stop("min_coverage not a number or negative: ", min_coverage)
  }

  tmp_result <- result
  if (type == "total") {
    result <- group_by_site(result, "meta_condition") %>% 
      dplyr::filter(
        sum(get_coverage_helper(primary, base_type, coverage)) >= min_coverage
      )
  } else if(type == "condition") {
    result <- group_by_site(result, "meta_condition", condition) %>%
      dplyr::mutate(
        condition_coverage_sum = sum(get_coverage_helper(primary, base_type, coverage))
      ) %>%
      dplyr::ungroup() %>%
      group_by_site("meta_condition") %>%
      dplyr::filter(all(condition_coverage_sum >= min_coverage)) %>%
      dplyr::select(-condition_coverage_sum)
  } else if (type == "replicate") {
    result <- group_by_site(result, "meta_condition") %>%
      dplyr::filter(
        all(get_coverage_helper(primary, base_type, coverage) >= min_coverage)
      )
  } else {
    stop("Unknown parameter type: ", type)
  }
  result <- copy_jacusa_attributes(tmp_result, result)

  dplyr::ungroup(result)
}

#' @noRd
get_coverage_helper <- function(primary, base_type, coverage) {
  coverage[primary & base_type == "total"]
}
