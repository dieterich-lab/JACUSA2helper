#' Adds data description to JACUSA2 result object.
#' 
#' This adds a more descriptive name to the data, extending condition, replicate information.
#' 
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()}.
#' @param condition_desc Vector mapping condition to more verbose description
#' @param format character vector must contain: 
#' @return JACUSA2 result object with data description added
#' 
#' @export
add_data_desc <- function(result, condition_desc = c(), format = "%CONDITION%_%REPLICATE%") {
  conditions <- length(unique(result$condition))
  if (length(condition_desc) == 0) {
    condition_desc <- paste0("sample", 1:conditions)
  }
  if (length(condition_desc) != conditions) {
    stop("Description does not match data: ", condition_desc)
  }
  
  check_pattern <- function(str, pat) {
    grep("%CONDITION%", format, fixed = TRUE) %>% length() == 1
  }
  if (! check_pattern(format, "%CONDITION%") || ! check_pattern(format, "%REPLICATE%")) {
    stop("Invalid format for data description: ", format)
  }
  
  format_data_desc <- function(condition, replicate) {
    mapply(function(c, r) {
      format %>%
        gsub("%CONDITION%", condition_desc[c], .) %>%
        gsub("%REPLICATE%", r, .)
    }, condition, replicate, USE.NAMES = FALSE)
  }
  result <- result %>% 
    dplyr::mutate(!!DATA_DESC := format_data_desc(condition, replicate))
  result[[DATA_DESC]] <- as.factor(result[[DATA_DESC]])
  
  result
}
