#' Add base change key
#' 
#' \code{add_ref_base2bc()} adds base change key where the 
#' reference base can be either the character vector "ref_base" key or 
#' a condition integer to define the reference base. When comparing DNA vs. RNA 
#' sequencing samples, base calls idenified in DNA might differ from
#' reference sequence base provided by "ref_field" key.
#' 
#' @param result object created by \code{read_result()}
#' @param ref_field String ("ref_base" for 1 condition experiment) or integer of DNA condition 
#' @return result object extended by base change info
#' 
#' @export
add_ref_base2bc <- function(result, ref_field) {
  if (! check_max_alleles(result, max_alleles = 2)) {
    stop("Sites with alleles > 2 not allowed")
  }
  if (ref_field == "ref_base") { # use reference base "from FASTA reference"
    conditions <- unique(result$condition) %>% length()
    result <- result %>% 
      dplyr::group_by(id) %>% 
      dplyr::mutate(ref_base2bc = get_bc_change(ref_base, bc))
  } else if(is.numeric(ref_field) & any(result$condition %in% ref_field)) { # use specific condition to derive reference base
    .extract_ref2bc <- function(condition, bc, ref_field) {
      dna <- condition == ref_field
      rna <- ! dna
      
      ref_base <- bc
      ref_base[rna] <- bc[dna]
      
      observed_bc <- bc
    
      get_bc_change(ref_base, observed_bc)
    }
    result <- result %>% 
      dplyr::group_by(id) %>%
      dplyr::mutate(ref_base2bc = .extract_ref2bc(condition, bc, ref_field))
  } else {
    stop("Unknown ref_field: ", ref_field)
  }

  as.data.frame(result)
}

#' Add reference base to base call change ratio (e.g.: editing frequency) to a JACUSA2 object.
#' 
#' \code{add_ref_base2bc_ratio()} adds base call change ratio (e.g.: editing frequency).
#' Adds key "ref_base2bc" key to JACUSA2 object.
#' 
#' @param result object created by \code{read_result()}.
#' @param ref_field String ("ref_base" for 1 condition experiment) or integer of DNA condition 
#' @return result object with base change and base change ratio added
#' 
#' @export 
add_ref_base2bc_ratio <- function(result, ref_field) {
  # auto add missing fields
  if (is.null(result$ref_base2bc)) {
    result <- add_ref_base2bc(result, ref_field)
  }
  result$ref_base2bc_ratio <- get_bc_change_ratio(ref_field, result[, paste0("bc_", .BASES)])
  
  result
}
