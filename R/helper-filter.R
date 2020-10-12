#' Filters sites by artefacts.
#' 
#' Removes sites that sites that have been marked by feature/artefact filter. 
#' 
#' @param filter vector of strings that contains artefact filter information. 
#' @param artefacts vector of characters that correspond to feature/artefact filters to be filtered.
#' @return vector of logical.
#' @examples
#' data(rdd)
#' # remove sites that are marked by artefact filter "D"
#' filtered <- filter_by(rdd, filter_artefact(filter, c("D")))
#' str(filtered)
#' @export
filter_artefact <- function(filter, artefacts) {
  if (nchar(artefacts) == 0) {
    stop("artefacts cannot be 0")
  }
  
  grepl(paste0(artefacts, collapse = "|"), filter)
}

#' Filters all sites with an artefact
#'
#' Removes sites have been marked by any feature/artefact filter. 
#' 
#' @param filter vector of strings that contains artefact filter information. 
#' @return vector of logical.
#' @examples
#' data(rdd)
#' # remove sites that are marked by artefact filter "D"
#' filtered <- filter_by(rdd, filter_all_artefacts(filter))
#' str(filtered)
#' @export
filter_all_artefacts <- function(filter) {
  filter_artefact(filter, c(paste0('\\', .EMPTY)))
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


#' Merge tibbles with columns holding logical values with OR to a vector.
#' 
#' Each column holding values of logicals will be merged row-wise with OR.
#' @param d tibble with logical values
#' @return logical tibble with columns merged with OR.
#' @export
Any <- function(d) {
  Reduce("|", tidyr::as_tibble(d))
}
