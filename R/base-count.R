#' Retrieves the total number of observed unique bases.
#'
#' Retrieves the total number of observed unique bases.
#' If \code{ref} is provided, reference base will be considered for counting, e.g.:
#' At some site only base 'A' was observed but the reference was 'T'.
#' \code{base_count} will be:
#' \itemize{
#'  \item 1, when \code{ref} is NOT provided, or
#'  \item 2, when \code{ref} is provided.
#' }
#'
#' @importFrom magrittr %>%
#' @param bases vector of base calls or tibble of base call counts.
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
base_count <- function(bases, ref = NULL) {
  if (! is.vector(bases)) {
    bases <- base_call(bases)
  }
  if (! is.null(ref)) {
    bases <- paste0(bases, ref)
  }
  
  strsplit(bases, "") %>% 
    lapply(unique) %>% # remove duplicates
    lapply(length) %>% # how many bases?
    unlist()
}
