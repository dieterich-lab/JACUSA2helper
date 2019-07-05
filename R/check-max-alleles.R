#' Check if site contains the max number of allowed alleles
#'
#' Return TRUE|FALSE if the JACUSA2 result object has the maximum number of allowed 
#' alleles per site.
#'
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()}.
#' @param max_alleles Integer number of maximal allowed alleles per site.
#' @param use_ref_base boolean indicating if ref_base should used to count alleles per site (Default: TRUE).
#' @return boolean
#' 
#' @export
check_max_alleles <- function(result, max_alleles = 2, use_ref_base = TRUE) {
  result <- result %>%
    group_by_site("meta_condition")
  
  if (use_ref_base) {
    result <- result %>%
      dplyr::filter(any(get_alleles(c(bc, ref_base)) > max_alleles))
  } else {
    result <- result %>%
      dplyr::filter(any(get_alleles(bc) > max_alleles))
  }

  nrow(result) == 0
}
