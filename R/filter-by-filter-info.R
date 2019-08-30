#' Filters sites by artefacts.
#'
#' Removes sites that contain artefacts. 
#'
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param artefacts vector of characters that correspond to artefact filters
#' @return result object with sites filtered by filter info
#'
#' @export 
filter_by_filter_info <- function(result, artefacts) {
  if (length(artefacts) == 0) {
    stop("artefacts cannot be 0")
  }
  pattern <- paste0(artefacts, collapse = "|")

  result <- group_by_site(result, "meta_condition") %>%
    dplyr::filter(
      ! filter_artefacts_helper(primary, base_type, pattern, filter_info)
    ) %>%
    copy_jacusa_attributes(result, .)

  dplyr::ungroup(result)
}

#' @noRd
filter_artefacts_helper <- function(primary, base_type, pattern, filter_info) {
  x <- filter_info[primary & base_type == "total"]

  grepl(pattern, x)
}
