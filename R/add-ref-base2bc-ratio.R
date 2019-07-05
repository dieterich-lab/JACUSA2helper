#' Add reference base to base call change ratio to a JACUSA2 object
#' 
#' Adds base call change ratio (e.g.: editing frequency) to a JACUSA2 result object.
#' 
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()}
#' @param ref_field String ("ref_base" for 1 condition experiment) or integer of DNA condition 
#' @return result object with base change and base change ratio added
#' 
#' @export 
add_ref_base2bc_ratio <- function(result, ref_field) {
  # auto add missing field
  if (is.null(result[["ref_base2bc"]])) {
    result <- add_ref_base2bc(result, ref_field)
  }

  ref_base <- c()
  if (ref_field != "ref_base") {
    ref_base <- result %>% 
      group_by_site("meta_condition") %>% 
      dplyr::mutate(condition_ref_base = bc[condition == ref_field]) %>% 
      dplyr::ungroup()
      dplyr::select(condition_ref_base) %>% 
      dplyr::pull()
  } else {
    ref_base <- result$ref_base
  }

  result$ref_base2bc_ratio <- get_bc_change_ratio(
    ref_base,
    result[, paste0("bc_", BASES)]
  )

  result
}
