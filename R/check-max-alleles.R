#' Checks if site contains less or equal number of allowed alleles.
#'
#' Return TRUE|FALSE if the JACUSA2 result object has the maximum number 
#' of allowed alleles per site.
#'
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param max_alleles numeric specifices maximal allowed alleles per site.
#' @param use_ref_base boolean indicating, if "ref_base" should be used to count alleles per site (Default: TRUE).
#' @return boolean indicating if "max_alleles" per site is obeyed.
#' 
#' @export
check_max_alleles <- function(result, max_alleles = 2, use_ref_base = TRUE) {
  result <- group_by_site(result, "meta_condition") %>%
    dplyr::filter(
      get_allele_count_helper(primary, base_type, bc, ref_base, use_ref_base) > max_alleles
    )

  nrow(result) == 0
}
