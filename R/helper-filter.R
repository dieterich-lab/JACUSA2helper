#' TODO
#' 
#' TODO
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param ... forwared to internal \code{dplyr::filter()} statement.
#' @return TODO
#' @examples
#' TODO
#' @export
filter_by <- function(result, ...) {
  dplyr::filter(result, ...) %>%
    copy_attr(result, .)
}

#' Filters sites by artefacts.
#' 
#' Removes sites that sites that have been marked by feature/artefact filter. 
#' 
#' @param filter_info vector of strings that contains artefacts filter information. 
#' @param artefacts vector of characters that correspond to feature/artefact filters.
#' @return vector of logical.
#' @examples
#' data(rdd)
#' # remove sites that are marked by artefact filter "D"
#' filtered <- filter_by(resultm, filter_artefact(result, c("D")))
#' str(filtered)
#' @export
filter_artefact <- function(filter_info, artefacts) {
  if (nchar(artefacts) == 0) {
    stop("artefacts cannot be 0")
  }
  
  grepl(paste0(artefacts, collapse = "|"), filter_info)
}
