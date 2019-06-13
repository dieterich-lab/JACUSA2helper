#' Check if site has the max number of allowed alleles.
#'
#' Return TRUE|FALSE if the JACUSA2 object has the maximum number of allowed 
#' alleles per site.
#'
#' @param jacusa2 object created by \code{read_result()}.
#' @param max_alleles Integer number of maximal allowed alleles per site.
#'
#' @return TRUE|FALSE 
#' 
#' @export
check_max_alleles <- function(jacusa2, max_alleles = 2) {
  sites <- jacusa2 %>%
    dplyr::select(id, bc) %>%
    dplyr::group_by(id) %>%
    dplyr::filter(.get_alleles(bc) > max_alleles) %>% 
    nrow()
  
  sites == 0
}
