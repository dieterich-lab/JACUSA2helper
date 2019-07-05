#' Adds data description to JACUSA2 result object
#' 
#' Adds a more descriptive name to the resut object, beautifying condition and replicate information.
#' 
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()}
#' @param condition_desc TODO list of vector mapping condition to more verbose description
#' @param format character vector must contain place holder: \%CONDITION\% and \%REPLICATE\%
#' @return result object with data description added
#' 
#' @export
add_data_desc <- function(result, condition_desc = c(), format = "%CONDITION%_%REPLICATE%") {
  if (! check_patterns(format, c("%CONDITION%", "%REPLICATE%"))) {
    stop("Invalid format for data description: ", format)
  }

  if ("meta_condition" %>% names(result)) {
    result <- add_data_desc_default(result, condition_desc, format)
  } else {
    result <- add_data_desc_meta_condition(result, condition_desc, format)
  }
  result[[DATA_DESC]] <- as.factor(result[[DATA_DESC]])
  
  dplyr::ungroup(result)
}

#' @importFrom magrittr %>%
#' @noRd
check_patterns <- function(string, patterns) {
  all(sapply(patterns, grepl, string, fixed = TRUE))
}

#' @importFrom magrittr %>%
#' @noRd
format_data_desc <- function(condition_desc, condition, replicate, format) {
  mapply(function(c, r) {
    gsub("%CONDITION%", condition_desc[c], format) %>%
      gsub("%REPLICATE%", r, .)
  }, condition, replicate, USE.NAMES = FALSE)
}

#' Adds data description if NO meta condition is present
#' 
#' To be called by \code{add_data_desc()}
#' 
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()}
#' @param condition_desc TODO list of vector mapping condition to more verbose description
#' @param format character vector must contain place holder: \%CONDITION\% and \%REPLICATE\% 
#' @return result object with data description added
#' @noRd
add_data_desc_default <- function(result, condition_desc, format) {
  conditions <- length(unique(result$condition))
  if (length(condition_desc) != conditions) {
    stop("condition_desc does not match number of conditions: ", condition_desc, " vs.", conditions)
  }

  result <- result %>% 
    dplyr::mutate(!!DATA_DESC := format_data_desc(condition_desc, condition, replicate, format))
  
  result
}

#' Adds data description if meta condition is present
#' 
#' To be called by \code{add_data_desc()}
#' 
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()}
#' @param condition_desc TODO list of vector mapping condition to more verbose description
#' @param format character vector must contain place holder: \%CONDITION\% and \%REPLICATE\% 
#' @return result object with data description added
#' @noRd
add_data_desc_meta_condition <- function(result, condition_desc, format) {
  conditions <- result %>% group_by_site(result, "meta_condition") %>% 
    dplyr::summarise(condition = length(unique(condition))) %>% 
    dplyr::select(condition) %>% 
    dplyr::pull()
  
  if (length(unique(conditions)) != 1) {
    stop(
      "Invalid result object. ", 
      "Number of conditions between meta_conditions different: ", 
      paste0(conditions, collapse = ",")
    )
  }
  conditions <- unique(conditions)

  # check length of meta_conditions an condition_desc are the same  
  if (! is.list(condition_desc) & conditions != length(condition_desc)) {
    stop(
      "Invalid or length of condition_desc does not match or ", 
      "the number of meta_conditions in result: ", condition_desc
    )
  }
  meta_conditions <- unique(result$meta_condition)

  # check each meta_condition has its own condition description
  i <- meta_conditions %in% names(condition_desc)
  if(! all(i)) {
    stop("Missing meta_codition(s) in condition_desc: ", paste0(meta_conditions[i], ","))
  }

  result <- result %>% 
    group_by_site("meta_condition") %>%
    dplyr::mutate(
      !!DATA_DESC := format_data_desc(
        condition_desc[[unique(meta_condition)]], 
        condition, replicate,
        format
      )
    )

  result
}
