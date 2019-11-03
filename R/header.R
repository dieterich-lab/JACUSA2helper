#' @noRd
get_header <- function(result) {
  attributes(result)[[HEADER]]
}

#' @noRd
set_header <- function(result, header) {
  attributes(result)[[HEADER]] <- header
  
  result
}

#' @noRd
copy_header <- function(src, dest) {
  header <- get_header(src)
  dest <- set_header(dest, header)
  
  dest
}
