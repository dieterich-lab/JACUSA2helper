#' Filters sites by artefacts.
#' 
#' Removes sites that sites that have been marked by feature/artefact filter. 
#' 
#' @param filter vector of strings that contains artefact filter information. 
#' @param artefacts vector of characters that correspond to feature/artefact filters to be filtered, default: NULL - Filter all.
#' @return vector of logical.
#' @examples
#' data(rdd)
#' # remove sites that are marked by artefact filter "D"
#' dim(rdd)
#' dim(dplyr::filter(rdd, filter_artefact(filter, c("D"))))
#' # remove all sites that are marked by some artefact filter
#' dim(dplyr::filter(rdd, filter_artefact(filter)))
#' @export
filter_artefact <- function(filter, artefacts = NULL) {
  if (is.null(artefacts)) {
    artefacts <- c(paste0('\\', .EMPTY))
  }
  
  grepl(paste0(artefacts, collapse = "|"), filter)
}

#' Merge tibbles with columns holding logical values with AND to a vector.
#' 
#' Each column holding values of logicals will be merged row-wise with AND.
#' @param d tibble with logical values
#' @return logical tibble with columns merged with AND.
#' @export
All <- function(d) {
  Reduce("&", tidyr::as_tibble(d))
}


#' Merge tibbles with columns holding the sum of numeric values of a vector.
#' 
#' Each column holding values of numbers will be summed row-wise.
#' @param d tibble with numeric values
#' @return numeric tibble with summed columns.
#' @export
Allnum <- function(d) {
  Reduce("+", tidyr::as_tibble(d))
}


#' Merge tibbles with columns holding logical values with OR to a vector.
#' 
#' Each column holding values of logicals will be merged row-wise with OR.
#' @param d tibble with logical values
#' @return logical tibble with columns merged with OR.
#' @export
Any <- function(d) {
  Reduce("|", tidyr::as_tibble(d))
}
