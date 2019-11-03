#' Packs and converts a JACUSA2 result object to JACUSA2 result format. (EXPERIMENTAL)
#' 
#' Packs and converts a JACUSA2 result object to JACUSA2 result format.
#' This will be written to a file. Requires \code{result} to be a object 
#' created by \code{read_result()}. This functions converts from tidy data to 
#' JACUSA2 result format (wide-format). 
#' JACUSA2 specific attributes must be present in \code{result}.
#' 
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()}.
#' @return result object in JACUSA2 result format.
#' 
#' @export
pack <- function(result) {
  require_method(result)
  # order is important!!! to match order of column in JACUSA2 result format
  group_vars <- group_by_site(result, OPT_SITE_VARS) %>% dplyr::group_vars()
  packed <- dplyr::full_join(pack_bases(result), pack_info(result), by = group_vars) %>% 
    dplyr::full_join(pack_filter_info(result), by = group_vars) %>%
    dplyr::full_join(pack_ref_base(result), by = group_vars)

  dplyr::ungroup(packed)
}

#' @noRd
pack_bases <- function(result) {
  require_method(result)
  # needs to be called before dplyr
  # otherwise attributes are lost
  type <- get_method(result)

  bases_str <- "bases_str"
  result <- tidyr::unite(result, bases_str, bc_A, bc_C, bc_G, bc_T, sep = ",")
  i <- result[["coverage"]] == 0
  result[[bases_str]][i] <- EMPTY
  #
  result <- group_by_site(result, OPT_SITE_VARS)

  packed <- NULL
  if (type == CALL_PILEUP_METHOD_TYPE) {
    result <- dplyr::filter(result, base_type == "total") %>%
      dplyr::mutate(sample = paste0(BASES_COLUMN, condition, replicate))
  } else if (type %in% c(RT_ARREST_METHOD_TYPE, LRT_ARREST_METHOD_TYPE)) {
    result <- dplyr::filter(result, base_type %in% c(ARREST_COLUMN, THROUGH_COLUMN)) %>%
      dplyr::mutate(sample = paste0(base_type, condition, replicate))
  } else {
    stop("Unknown type: ", type)
  }

  packed <- dplyr::select(
    result,
    dplyr::group_vars(result), name, score,
    sample, bases_str
  ) %>%
    tidyr::spread(sample, bases_str, fill = EMPTY)

  dplyr::ungroup(packed)
}

#' @noRd
pack_column <- function(result, column) {
  check_column_exists(result, column)
  
  packed <- dplyr::filter(
    result,
    primary == TRUE, base_type == "total"
  ) %>%
    group_by_site(OPT_SITE_VARS) %>%
    dplyr::select(
      dplyr::group_vars(.),
      !!rlang::sym(column)
    ) %>%
    dplyr::summarise(!!rlang::sym(column):=pack_helper(!!rlang::sym(column)))

  dplyr::ungroup(packed)
}

#' @noRd
pack_info <- function(result) {
  pack_column(result, INFO_COLUMN)
}

#' @noRd
pack_filter_info <- function(result) {
  pack_column(result, FILTER_INFO_COLUMN)
}

#' @noRd
pack_ref_base <- function(result) {
  pack_column(result, REF_BASE_COLUMN)
}

#' @noRd
pack_helper <- function(s) {
  s <- unique(s) %>%
    paste(sep = ";")

  s
}
