#' Formats JACUSA2 result object as in JACUSA2 result output.
#' 
#' Allows to peak at a result object and provides a user friendly format.
#' Converts data from long to wide format. @seealso \code{pack()}
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param columns TODO, Default: NULL use all columns.
#' @return object structured as in JACUSA2 result format
#' @examples
#' data(rdd)
#' str(peak(rdd, "bases"))
#' @export
peak <- function(result, columns = NULL) {
  require_method(result)
    
  type <- CALL_PILEUP_METHOD_TYPE

  general_cols <- BED_COLUMNS
  if (type == CALL_PILEUP_METHOD_TYPE) {
    # nothing to add
  } else if (type == RT_ARREST_METHOD_TYPE) {
    general_cols <- gsub("score", "pvalue", general_cols)
  } else if (type == LRT_ARREST_METHOD_TYPE) {
    general_cols <- gsub("score", "pvalue", general_cols)
    general_cols <- c(general_cols, ARREST_POS_COLUMN)
  } else if (type == UNKNOWN_METHOD_TYPE){
    stop("Error")
  }
  
  result <- dplyr::mutate(
    result,
    tmp_sample = paste0(!!rlang::sym(CONDITION_COLUMN), !!rlang::sym(REPLICATE_COLUMN))
  ) %>%
    dplyr::select(tmp_sample, general_cols, columns)

  i <- needs_pack(result)
  if (any(i)) {
    for (col in names(result)[i]) {
      result[[col]] <- pack(result[[col]])
    }
  }
  
  tidyr::gather(result, key = "key", value = "value", columns, convert = TRUE) %>%
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
