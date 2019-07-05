#' Add base change field to JACUSA2 result object
#' 
#' Adds base change field. The reference base can be defined either by
#' the character vector field "ref_base" or a condition integer. 
#' When comparing DNA vs. RNA sequencing samples, base calls idenified in DNA might differ from
#' reference sequence base provided by "ref_base" key.
#' 
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()}
#' @param ref_field String ("ref_base" for 1 condition experiment) or integer of condition to define reference base
#' @return result object extended by base change
#' 
#' @export
add_ref_base2bc <- function(result, ref_field) {
  if (! check_max_alleles(result, 2)) {
    stop("Sites with alleles > 2 not allowed")
  }

  if (ref_field == "ref_base") {
    # use reference base "from FASTA reference"
    result <- result %>%
      group_by_site("meta_condition") %>%
      dplyr::mutate(ref_base2bc = get_bc_change(ref_base, bc))
  } else if (is.numeric(ref_field) & ref_field %in% result$condition) {
    # use specific condition to derive reference base
    extract_ref2bc <- function(condition, bc, ref_field) {
      dna <- condition == ref_field
      rna <- ! dna

      ref_base <- bc
      ref_base[rna] <- bc[dna]

      observed_bc <- bc

      get_bc_change(ref_base, observed_bc)
    }

    result <- result %>%
      group_by_site(c("meta_condition", "arrest_pos")) %>%
      dplyr::mutate(ref_base2bc = extract_ref2bc(condition, bc, ref_field))
  } else {
    stop("Unknown ref_field: ", ref_field)
  }

  dplyr::ungroup(result)
}
