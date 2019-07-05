#' Get distirbution This is a TODO
#' 
#' This is a TODO
#' 
#' @importFrom magrittr %>%
#' @param result TODO 
#' @param ref_field TODO
#' @return TODO
#' 
#' @export
get_ref_base2bc_tbl <- function(result, ref_field) {
  if (is.null(result[["ref_base2bc"]])) {
    result <- add_ref_base2bc(result, ref_field)
  }

  # FIXME use only primary
  # TODO meta conditions
  result <- result %>% group_by_site("meta_condition") %>% 
    dplyr::summarise(ref_base2bc = merge_ref_base2bc(ref_base2bc)) %>%

  table(result$ref_base2bc)
}
