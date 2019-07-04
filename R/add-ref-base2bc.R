#' Add base change key
#' 
#' Adds base change key where the reference base can be either 
#' the character vector "ref_base" key or a condition integer to define the reference base. 
#' When comparing DNA vs. RNA sequencing samples, base calls idenified in DNA might differ from
#' reference sequence base provided by "ref_field" key.
#' 
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()}
#' @param ref_field String ("ref_base" for 1 condition experiment) or integer of DNA condition 
#' @return result object extended by base change info
#' 
#' @export
add_ref_base2bc <- function(result, ref_field) {
  if (! check_max_alleles(result, 2)) {
    stop("Sites with alleles > 2 not allowed")
  }

  if (ref_field == "ref_base") {
    # use reference base "from FASTA reference"
    result <- result %>%
      group_by_site() %>%
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
