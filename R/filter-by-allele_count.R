#' Filters sites by the number of alleles per site.
#'
#' Removes sites that have too many alleles.
#'
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param max_alleles numeric specifies maximal allowed alleles per site.
#' @param use_ref_base boolean indicating if "ref_base" should be used to count alleles (Default: TRUE).
#' @return result object with sites where \code{max_alleles} is obeyed.
#' 
#' @export
filter_by_allele_count <- function(result, max_alleles = 2, use_ref_base = TRUE) {
  result <- group_by_site(result, "meta_condition") %>%
    dplyr::filter(
      get_allele_count_helper(primary, base_type, bc, ref_base, use_ref_base) <= max_alleles
    ) %>%
    copy_jacusa_attributes(result, .)

  dplyr::ungroup(result)
}
