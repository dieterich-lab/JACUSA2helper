#' Reads multiple related JACUSA2 results.
#' 
#' Read multiple related - same JACUSA2 method type - files and combines them
#' in one result object. This allows to combine multiple related JACUSA2 results
#' that differ in some meta condition.
#' 
#' @param files vector of JACUSA2 result files.
#' @param meta_conditions vector of strings providing details about each file.
#' @return combined JACUSA2 result object.
#'
#' @export
read_results <- function(files, meta_conditions) {
  stopifnot(length(files) == length(meta_conditions))
  
  types <- SUPPORTED_METHOD_TYPES
  headers <- list()
  # read all files  
  l <- mapply(function(file, meta_condition) {
    # use default read function and
    result <- read_result(file)
    # add corresponding meta conditition description
    result$meta_condition <- meta_condition
    
    # this makes sure that all files have the same JACUSA2 type
    type <- get_method(result)
    if (! type %in% types) {
      stop("All files must have the same type. File: ", file, " has type: ", type)
    }
    # ugly but conveniernt "global" variable manipulation
    types <<- type
    headers[[meta_condition]] <- get_header(result)
    
    return(result)
  }, files, meta_conditions, USE.NAMES = FALSE, SIMPLIFY = FALSE)
  
  # combine read files
  results <- dplyr::bind_rows(l)
  results$meta_condition <- as.factor(results$meta_condition)
  
  # types should be ONE element of SUPPORTED_METHOD_TYPES
  results <- set_method(results, types)
  results <- set_header(results, headers)
  
  results
}
