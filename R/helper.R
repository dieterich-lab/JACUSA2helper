#' @noRd
check_column_exists <- function(result, column) {
  if (is.null(result[[column]])) {
    stop("result does not have column: ", column)
  }
}

#' @noRd
get_allele_count_helper <- function(primary, base_type, bc, ref_base, use_ref_base) {
  i <- primary & base_type == "total"
  bc <- bc[i]
  if (use_ref_base) {
    bc <- c(bc, ref_base[i])
  }

  get_allele_count(bc)
}
