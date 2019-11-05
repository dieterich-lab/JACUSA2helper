#' Reads multiple related JACUSA2 results.
#' 
#' Read multiple related - same JACUSA2 method type - files and combines them
#' in one result object. This allows to combine multiple related JACUSA2 results
#' that differ in some meta condition.
#' 
#' @param files vector of JACUSA2 result files.
#' @param meta_conditions vector of strings providing details about each file.
#' @param unpack_info boolean indicating if additional data stored in 'info' field should be unpacked.
#' @return combined JACUSA2 result object.
#'
#' @export
read_results <- function(files, meta_conditions, unpack_info = TRUE) {
  stopifnot(length(files) == length(meta_conditions))
  
  condition_info <- NULL
  types <- SUPPORTED_METHOD_TYPES
  headers <- list()
  # read all files  
  l <- mapply(function(file, meta_condition) {
    file_info <- pre_read(file)
    # check that a header could be parsed
    if (is.null(file_info$data_header)) {
      stop("No data header line for file: ", file)
    }  
    
    condition_info_new <- process_condition(file_info$type, file_info$data_header)
    # check that conditions could be guessed
    if (condition_info_new$conditions < 1 || 
        length(condition_info_new$cond2rep) != condition_info_new$conditions) {
      stop("Conditions could not be guessed for file: ", file)
    }
    if (is.null(condition_info)) {
      condition_info <<- condition_info_new
    } else if (! all.equal(condition_info, condition_info_new)){
      stop("All files must have the same condition_info (Same conditions and replicate). ",
           "File: ", file, " has condition_info: ", condition_info)
    }
    
    data <- read_data(file, file_info$skip_lines, file_info$data_header)
    # add corresponding meta conditition description
    data[[META_CONDITION_COLUMN]] <- meta_condition
    
    # this makes sure that all files have the same JACUSA2 type
    if (! file_info$type %in% types) {
      stop("All files must have the same type. File: ", file, " has type: ", type)
    }
    # ugly but conveniernt "global" variable manipulation
    types <<- file_info$type

    # store JACUSA2 header per meta_condition
    headers[[meta_condition]] <- file_info$jacusa_header
    
    return(data)
  }, files, meta_conditions, USE.NAMES = FALSE, SIMPLIFY = FALSE)
  # combine read files

  data <- dplyr::bind_rows(l)
  data[[META_CONDITION_COLUMN]] <- as.factor(data[[META_CONDITION_COLUMN]])
  
  # create result depending on determined method type 
  result <- create_result(
    types, 
    condition_info$cond_rep, 
    data, 
    unpack_info
  )  
  
  # types should be ONE element of SUPPORTED_METHOD_TYPES
  result <- set_method(result, types)
  result <- set_header(result, headers)
  
  result
}
