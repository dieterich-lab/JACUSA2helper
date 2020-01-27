#' Filter and preserve attributes of result object.
#' 
#' Filters and preserves attributes of result object. 
#' Use this instead of \code{dplyr::filter}, otherwise JACUSA2 header and type information 
#' will be lost from result object.
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param ... forwarded to internal \code{dplyr::filter()} statement.
#' @return result object after filtering with JACUSA2 specific attributes data preserved.
#' @examples
#' data(rdd)
#' # remove sites that are marked by artefact filter "D"
#' grouped <- group_by_site(rdd)
#' filtered <- filter_by(grouped, filter_artefact(filter, c("D")))
#' str(filtered)
#' @export
filter_by <- function(result, ...) {
  dplyr::filter(result, ...) %>%
    copy_attr(result, .)
}

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
#' grouped <- group_by_site(rdd)
#' filtered <- filter_by(grouped, filter_artefact(filter, c("D")))
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
#' Removes sites that sites that have been marked by any feature/artefact filter. 
#' @param filter vector of strings that contains artefact filter information. 
#' @return vector of logical.
#' @examples
#' data(rdd)
#' # remove sites that are marked by artefact filter "D"
#' grouped <- group_by_site(rdd)
#' filtered <- filter_by(grouped, filter_all_artefacts(filter))
#' str(filtered)
#' @export
filter_all_artefacts <- function(filter) {
  filter_artefact(filter, c(paste0('\\', EMPTY)))
}
