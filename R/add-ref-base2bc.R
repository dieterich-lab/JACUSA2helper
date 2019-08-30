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
#' @param max_bc boolean TODO
#' @return result object with base changes added.
#' 
#' @export
add_ref_base2bc <- function(result, ref_field, max_bc = FALSE) {
  tmp_result <- result
  if (max_bc) {
    result <- group_by_site(result, "meta_condition") %>%
      dplyr::mutate(site_max_bc = get_max_bc_helper(bc_A, bc_C, bc_G, bc_T))
  }
  if (ref_field == REF_BASE_COLUMN) {
    result <- add_default_ref_base2bc(result, max_bc)
  } else if (is.numeric(ref_field)) {
    result <- add_ref_base2bc_by_condition(result, ref_field, max_bc)
  } else {
    stop("Unknown ref_field: ", ref_field)
  }
  result <- copy_jacusa_attributes(tmp_result, result)

  dplyr::ungroup(result)
}

#' @noRd
add_default_ref_base2bc <- function(result, max_bc = FALSE) {
  # make sure, we have only ONE reference base per site
  if (! max_bc && any(nchar(result[[REF_BASE_COLUMN]]) != 1)) {
    stop(REF_BASE_COLUMN, " != 1 not allowed")
  }
  # use reference base "from FASTA reference"
  result <- group_by_site(
    result, 
    OPT_SITE_VARS, 
    condition, replicate
  )
  
  if (max_bc) {
    result <- dplyr::mutate(result, ref_base2max_bc = get_ref_base2bc(ref_base, site_max_bc))
  } else {
    result <- dplyr::mutate(result, ref_base2bc = get_ref_base2bc(ref_base, bc))
  }

  result
}

#' @noRd
add_ref_base2bc_by_condition <- function(result, ref_condition, max_bc = False) {
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
  )
  if (max_bc) {
    dplyr::mutate(result, ref_base2max_bc = extract_ref_base2bc(condition, site_max_bc))
  } else {
    dplyr::mutate(result, ref_base2bc = extract_ref_base2bc(condition, bc))
  }

  result
}

#' @noRd
get_max_bc_helper <- function(bc_A, bc_C, bc_G, bc_T, max_allele_count = 2) {
  bc_A <- sum(bc_A)
  bc_C <- sum(bc_C)
  bc_G <- sum(bc_G)
  bc_T <- sum(bc_T)
  v <- c(bc_A, bc_C, bc_G, bc_T)
  names(v) <- JACUSA2helper:::BASES
  v <- v[v > 0]
  
  max_bc <- sort(v, decreasing = TRUE) %>%
    names() %>%
    paste0(collapse = "")
  allele_count <- nchar(max_bc)
  
  substr(max_bc, 1, min(allele_count, max_allele_count))
}
