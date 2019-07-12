#' Adds arrest rate to JACUSA2 result object.
#' 
#' Adds arrest rate to a JACUSA2 result object.
#' The result object must be the output of the following JACUSA2 methods: 
#' rt-arrest or lrt-arrest.
#' 
#' @importFrom magrittr %>%
#' @param result created by \code{read_result())} or \code{read_results())}.
#' @return result object with arrest rate added.
#' 
#' @export
add_arrest_rate <- function(result) {
  require_jacusa_method(
    result, c(RT_ARREST_METHOD_TYPE, LRT_ARREST_METHOD_TYPE)
  )
  
  arrest_rate_helper <- function(base_type, coverage) {
    arrest <- coverage[base_type == ARREST_COLUMN]
    through <- coverage[base_type == THROUGH_COLUMN]
    
    arrest_rate <- arrest_rate(arrest, through)
    # safe guard
    stopifnot(length(arrest_rate) == 1)
    
    return(arrest_rate)
  }
  
  result <- group_by_site(
    result, 
    OPT_SITE_VARS, 
    condition, replicate
  ) %>%
    dplyr::mutate(arrest_rate = arrest_rate_helper(base_type, coverage)) %>%
    dplyr::ungroup() %>%
    copy_jacusa_attributes(result, .)
  
  result
}

#' Calculates arrest rate.
#'
#' Calculates arrest rate from read arrest and read through counts.
#'
#' @param arrest numeric vector of read arrest events.
#' @param through numeric vector of read through events.
#' @return numeric vector of arrest rate(s).
#'
#' @export
arrest_rate <- function(arrest, through) {  
  arrest / (arrest + through)
}
