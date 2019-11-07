#' Formats JACUSA2 result object as in JACUSA2 result output.
#' 
#' Allows to peak at a result object and provides a user friendly format.
#' Converts data from long to wide format.
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param peak_cols string vector specifiying columns to peak at.
#' @param id_cols string vector specifiying columns to use as site id, Default: contig, start, end, strand.
#' @return result object structured as in JACUSA2 result format.
#' @examples
#' data(rdd)
#' str(peak(rdd, "bases"))
#' @export
peak <- function(result, peak_cols, id_cols = c("contig", "start", "end", "strand")) {
  require_method(result)
  
  result <- dplyr::mutate(
    result,
    tmp_sample = paste0(!!rlang::sym(CONDITION_COLUMN), !!rlang::sym(REPLICATE_COLUMN))
  ) %>%
    dplyr::select(tmp_sample, id_cols, peak_cols)

  i <- needs_pack(result)
  if (any(i)) {
    for (col in names(result)[i]) {
      result[[col]] <- pack(result[[col]])
    }
  }
  
  tidyr::gather(result, key = "key", value = "value", peak_cols, convert = TRUE) %>%
    tidyr::unite(key, key, tmp_sample, sep = "") %>% 
    tidyr::spread(key, value)
}


#' @noRd
needs_pack <- function(cols) {
  helper <- function(x) {
    tmp <- ncol(x)
    if (is.null(tmp)) {
      return(FALSE)
    }
    
    return(TRUE)
  }
  
  lapply(cols, helper) %>% unlist(use.names = FALSE)
}

#' @noRd
pack <- function(data, sep = ",") {
  l <- as.list(data)
  
  do.call(stringr::str_c, c(l, sep = sep))
}
