#' Add arrest rate field to JACUSA2 result object
#' 
#' This calculates the arrest rate for a JACUSA2 result object and a
#' 
#' @importFrom magrittr %>%
#' @param result created by \code{read_result*()}
#' @param pseudo_count numeric to be added to arrest and read through counts
#' @return result object with arrest rate added
#' 
#' @export
add_arrest_rate <- function(result, pseudo_count = 0) {
  if (is.null(result[["coverage"]])) {
    result <- add_coverage(result)
  }

  get_arrest_rate <- function(base_type, coverage) {
    arrest <- coverage[base_type == "arrest_bases"] + pseudo_count
    through <- coverage[base_type == "through_bases"] + pseudo_count
    arrest_rate <- arrest / (arrest + through)
    return(arrest_rate)
  }

  result <- result %>%
    group_by_site(c("meta_condition", "arrest_pos"), condition, replicate) %>%
    dplyr::mutate(arrest_rate = get_arrest_rate(base_type, coverage)) %>%
    dplyr::ungroup()

  result
}
