#' Retrieves the total number of observed unique bases.
#'
#' Retrieves the total number of observed unique bases for \code{base_type}.
#' If \code{ref_base} is provided, reference base will be considered for counting, e.g.:
#' At some site only base 'A' was observed but the reference was 'T'.
#' \code{base_count} will be:
#' \itemize{
#'  \item 1, when \code{ref_base} is NOT provided, or
#'  \item 2, when \code{ref_base} is provided.
#' }
#'
#' @importFrom magrittr %>%
#' @param bc_obs vector of strings with observed base calls.
#' @param ref_base vector of strings with reference base, 
#' @return numeric total number of bases.
#' @examples
#' bc_obs <- c("A", "AG", "C")
#' str(base_count(bc_obs))
#' 
#' # use default observed base calls and condsider reference base
#' ref_base <- c("A", "A", "T")
#' str(base_count(bc_obs, ref_base))
#' @export
base_count <- function(bc_obs, ref_base = NULL) {
  if (! is.null(ref_base)) {
    bc_obs <- paste0(bc_obs, ref_base)
  }
  
  strsplit(bc_obs, "") %>% 
    lapply(unique) %>% 
    lapply(length) %>% 
    unlist()
}
