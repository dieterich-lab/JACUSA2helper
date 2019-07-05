#' Filter sites by the number of alleles per site
#'
#' Removes sites that have too many alleles
#'
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()}.
#' @param max_alleles integer number of maximal allowed alleles per site.
#' @param use_ref_base boolean indicating ref_base should used to count alleles per site (Default: TRUE).
#' @return JACUSA2 result object with sites where max_alleles is obeyed.
#' 
#' @export
filter_by_alleles <- function(result, max_alleles = 2, use_ref_base = TRUE) {
  get_primary_alleles <- function(primary, base_type, bc, ref_base) {
    i <- primary & base_type == "total"
    bc <- bc[i]
    if (use_ref_base) {
      bc <- c(bc, ref_base[i])
    }
    return(get_alleles(bc))
  }

  result <- result %>% group_by_site("meta_condition") %>%
    dplyr::filter(all(get_primary_alleles(primary, base_type, bc, ref_base) <= max_alleles))

  dplyr::ungroup(result)
}
