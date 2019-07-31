#' TODO
#' 
#' TODO
#' 
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @return result object with base changes added.
#' 
#' @export
add_non_ref_base_ratio <- function(result) {
  tmp_result <- result

  m <- as.matrix(result[, paste0("bc_", BASES)])
  i <- as.matrix(cbind(seq_len(nrow(result)), match(result$ref_base, BASES)))
  result[["non_ref_base_ratio"]] <- (result[["coverage"]] - m[i]) / result[["coverage"]]
  result <- copy_jacusa_attributes(tmp_result, result)

  dplyr::ungroup(result)
}