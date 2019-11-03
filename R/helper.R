#' @noRd
check_column_exists <- function(result, column) {
  if (is.null(result[[column]])) {
    stop("result requires column: ", column)
  }
}

#' @noRd
process_col <- function(col, base_type = "bases") {
  if (! is.null(base_type) && base_type != BASES_COLUMN) {
    col <- paste(col, base_type, sep = "_")
  }
  
  col
}
