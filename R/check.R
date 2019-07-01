#' Check if site has the max number of allowed alleles.
#'
#' Return TRUE|FALSE if the JACUSA2 result object has the maximum number of allowed 
#' alleles per site.
#'
#' @param result object created by \code{read_result()}.
#' @param max_alleles Integer number of maximal allowed alleles per site.
#' @param ref_base boolean indicating ref_base should used to count alleles per site (Default: TRUE).
#'
#' @return TRUE|FALSE 
#' 
#' @export
check_max_alleles <- function(result, max_alleles = 2, use_ref_base = TRUE) {
  sites <- result %>% dplyr::select(id, bc, ref_base)
  if (use_ref_base) {
    sites <- sites %>% dplyr::mutate(bc = paste0(bc, ref_base))
  }
  sites <- sites %>% dplyr::group_by(id) %>%
    dplyr::filter(.get_alleles(bc) > max_alleles) %>% 
    nrow()
  
  sites == 0
}
