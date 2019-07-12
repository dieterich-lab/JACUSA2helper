#' Adds base change column to JACUSA2 result object.
#' 
#' The reference base can be defined either by providing the column name "ref_base" 
#' or an integer that specifies the condition. 
#' When comparing DNA vs. RNA  sequencing samples, base calls identified in DNA might differ from
#' the reference base provided by "ref_base" column. 
#' There must be only one reference base. A->G is okay, but AG->G is NOT allowed! 
#' Make sure to filter \code{result} with \code{filter_by_alleles()} to comply with this restriction.
#' 
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param ref_field character string "ref_base" or a condition number (1 or 2) to define reference base.
#' @return result object with base changes added.
#' 
#' @export
add_ref_base2bc <- function(result, ref_field) {
  tmp_result <- result
  if (ref_field == REF_BASE_COLUMN) {
    result <- add_default_ref_base2bc(result)
  } else if (is.numeric(ref_field)) {
    result <- add_ref_base2bc_by_condition(result, ref_field)
  } else {
    stop("Unknown ref_field: ", ref_field)
  }
  result <- copy_jacusa_attributes(tmp_result, result)

  dplyr::ungroup(result)
}

#' @noRd
add_default_ref_base2bc <- function(result) {
  # make sure, we have only ONE reference base per site
  if (any(nchar(result[[REF_BASE_COLUMN]]) != 1)) {
    stop(REF_BASE_COLUMN, " != 1 not allowed")
  }
  # use reference base "from FASTA reference"
  result <- group_by_site(
    result, 
    OPT_SITE_VARS, 
    condition, replicate
  ) %>%
    dplyr::mutate(ref_base2bc = get_ref_base2bc(ref_base, bc))

  result
}

#' @noRd
add_ref_base2bc_by_condition <- function(result, ref_condition) {
  if (length(ref_condition) != 1 | ! ref_condition %in% result$condition) {
    stop("Unknown condition: ", ref_condition)
  }

  # use specific condition to derive reference base
  # for condition == ref_condition all bc should be nchar() == 1 and be identical
  extract_ref_base2bc <- function(condition, bc) {
    dna_index <- condition == ref_condition
    rna_index <- ! dna_index

    ref_base <- bc
    # distribute ref_base from observed condition
    ref_base[rna_index] <- bc[dna_index]
    observed_bc <- bc

    # make sure, we have only ONE reference base per site  
    if (any(nchar(ref_base) != 1) | length(unique(ref_base)) != 1) {
      stop("Reference base from condition ", ref_condition, " has more than one allele - not allowed: ", paste0(ref_base, sep = ","))
    }

    return(get_ref_base2bc(ref_base, observed_bc))
  }

  result <- group_by_site(
    result,
    OPT_SITE_VARS
  ) %>%
    dplyr::mutate(ref_base2bc = extract_ref_base2bc(condition, bc))

  result
}
