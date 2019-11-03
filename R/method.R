#' @noRd
get_method <- function(result) {
  attributes(result)[[METHOD_TYPE]]
}

#' @noRd
set_method <- function(result, type) {
  attributes(result)[[METHOD_TYPE]] <- type
  
  result
}

#' @noRd
check_method <- function(result, types = SUPPORTED_METHOD_TYPES) {
  all(get_method(result) %in% types)
}

#' @noRd
require_method <- function(result, types = SUPPORTED_METHOD_TYPES) {
  if (! check_method(result, types)) {
    stop(
      "result must be of type: ", paste0(types, sep = ","), ".\n",
      "Current type: ", get_method(result)
    )
  }
}

#' @noRd
copy_method <- function(src, dest) {
  if (! check_method(src)) {
    stop("Unknown JACUSA method type for src: ", src)
  }
  type <- get_method(src)
  dest <- set_method(dest, type)
  
  dest
}
