#' Formats JACUSA2 result object as in JACUSA2 result output.
#' 
#' Allows to peak at a result object and provides a user friendly format.
#' Converts data from long to wide format. @seealso \code{pack()}
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param columns TODO
#' @return object structured as in JACUSA2 result format
#' 
#' @export
peak <- function(result, columns = NULL) {
  # TODO 
  # pack bc_A, bc_C, bc_G, bc_T
  
  result <- dplyr::mutate(
    result,
    tmp_sample = paste0(condition, replicate)
  ) %>%
    dplyr::select(
      c(tmp_sample, gsub("score", "pvalue", BED_COLUMNS), columns) # FIXME what columns
  ) %>% 
    tidyr::gather(key = "key", value = "value", columns, convert = TRUE) %>%
    tidyr::unite(key, key, tmp_sample, sep = "") %>% 
    tidyr::spread(key, value)
  
  result
}
