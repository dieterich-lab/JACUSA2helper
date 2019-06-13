#' Add base change key
#' 
#' \code{add_ref_base2bc()} adds base change key where the 
#' reference base can be either "ref_base" key or a condition 
#' to define the reference base. When comparing DNA vs. RNA 
#' sequencing samples base calls idenified in DNA might differ from
#' reference sequence base provided by "ref_field" key.
#' 
#' @param jacusa2 object created by \code{read_result()}
#' @param ref_field String ("ref_base" for 1 condition experiment) or integer of DNA condition 
#' @return jacusa2 object extended by base change info contained in "ref_base2bc" key
#' 
#' @export
add_ref_base2bc <- function(jacusa2, ref_field) {
  if (ref_field == "ref_base") { # use reference base "from FASTA reference"
    conditions <- unique(jacusa2$condition) %>% length()
    if (conditions > 1)  {
      stop("More than one condition with ref_base not allowed: ", conditions)
    }
    # not all data needed for checking
    if (! check_max_alleles(jacusa2, max_alleles = 2)) {
      stop("Sites with alleles > 2 not allowed")
    }
    jacusa2 <- jacusa2 %>% 
      dplyr::group_by(id) %>%
      dplyr::mutate(ref_base2bc = get_bc_change(ref_base, bc))
  } else if(is.numeric(ref_field) & any(jacusa2$condition %in% ref_field)) { # use specific condition to derive reference base
    if (! check_max_alleles(jacusa2, max_alleles = 2)) {
      stop("Sites with alleles > 2 not allowed")
    }
    
    .extract_ref2bc <- function(condition, bc, ref_field) {
      dna <- condition == ref_field
      rna <- ! dna
      
      ref_base <- bc
      ref_base[rna] <- bc[dna]
      
      observed_bc <- bc
    
      get_bc_change(ref_base, observed_bc)
    }
    jacusa2 <- jacusa2 %>% 
      dplyr::group_by(id) %>%
      dplyr::mutate(ref_base2bc = .extract_ref2bc(condition, bc, ref_field))
  } else {
    stop("Unknown ref_field: ", ref_field)
  }

  as.data.frame(jacusa2)
}

#' Add reference base to base call change ratio (e.g.: editing frequency) to a JACUSA2 object.
#' 
#' \code{add_ref_base2bc_ratio()} adds base call change ratio (e.g.: editing frequency).
#' Adds key "ref_base2bc" key to JACUSA2 object.
#' 
#' @param jacusa2 object created by \code{read_result()}.
#' @param ref_field String ("ref_base" for 1 condition experiment) or integer of DNA condition 
#' @return Returns a JACUSA2 object with 
#' 
#' @export 
add_ref_base2bc_ratio <- function(jacusa2, ref_field) {
  # auto add missing fields
  if (is.null(jacusa2$ref_base2bc)) {
    jacusa2 <- add_ref_base2bc(jacusa2, ref_field)
  }
  jacusa2$ref_base2bc_ratio <- get_bc_change_ratio(ref_field, jacusa2[, paste0("bc_", .BASES)])
  
  jacusa2
}
