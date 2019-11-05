#' Retrieves the total number of observed unique bases.
#'
#' Retrieves the total number of observed unique bases for \code{base_type}.
#' If \code{ref} is provided, reference base will be considered for counting, e.g.:
#' At some site only base 'A' was observed but the reference was 'T'.
#' \code{base_count} will be:
#' \itemize{
#'  \item 1, when \code{ref} is NOT provided, or
#'  \item 2, when \code{ref} is provided.
#' }
#'
#' @importFrom magrittr %>%
#' @param bc vector of strings with observed base calls.
#' @param ref vector of strings with reference bases 
#' @return numeric vector of total number of bases.
#' @examples
#' bc <- c("A", "AG", "C")
#' str(base_count(bc))
#' 
#' # use default observed base calls and condsider reference base
#' ref <- c("A", "A", "T")
#' str(base_count(bc, ref))
#' @export
base_count <- function(bc, ref = NULL) {
  if (! is.null(ref)) {
    bc <- paste0(bc, ref)
  }
  
  strsplit(bc, "") %>% 
    lapply(unique) %>% # remove duplicats
    lapply(length) %>% # how many bases?
    unlist()
}
