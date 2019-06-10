#' Add reference base to observed base call field
#' 
#' \code{add_ref_base2bc()} TODO description
#' 
#' @param jacusa2 object created by \code{read_result()}
#' @param ref_field String or integer
#' @return jacusa2 object enriched by ref. base 2 bc field
#' 
#' @export
add_ref_base2bc <- function(jacusa2, ref_field = "ref_base") {
  ref_base <- "N"
  observed_bc <- "N"
  
  if (ref_field == "ref_base") { # use reference base "from FASTA reference"
    ref_base <- jacusa2$ref_base
    observed_bc <- jacusa2$bc
    # not all data needed for checking
    if (! check_max_alleles(jacusa2, max_alleles = 2)) {
      stop("Sites with alleles > 2 not allowed")
    }
  } else if(is.numeric(ref_field) & any(jacusa2$condition %in% ref_field)) { # use specific condition to derive reference base
    if (! check_max_alleles(jacusa2, max_alleles = 2)) {
      stop("Sites with alleles > 2 not allowed")
    }
    ref_base <- jacusa2 %>% 
      dplyr::select(id, condition) %>%
      dplyr::group_by(id) %>%
      dplyr::filter(condition == ref_field) %>%
      select(bc)
    observed_bc <- jacusa2 %>% 
      dplyr::group_by(id, condition, bc) %>%
      dplyr::filter(condition != ref_field) %>%
      dplyr::select(bc)
  } else {
    stop("Unknown ref_field: ", ref_field)
  }
  jacusa2$ref_base2bc <- get_bc_change(ref_base, observed_bc)

  jacusa2
}

#' Add reference base to base call change ratio (e.g.: editing frequency) to a JACUSA2 object.
#' 
#' \code{add_ref_base2bc_ratio()} adds base call change ratio (e.g.: editing frequency).
#' 
#' @param jacusa2 object created by \code{read_result()}.
#' @param ref_field String or integer
#' @return Returns a JACUSA2 object
#' 
#' @export 
add_ref_base2bc_ratio <- function(jacusa2, ref_field = "ref_base") {
  # auto add missing fields
  if (is.null(jacusa2$ref_base2bc)) {
    jacusa2 <- add_ref_base2bc(jacusa2, ref_field)
  }
  jacusa2$ref_base2bc_ratio <- get_bc_change_ratio(ref_field, jacusa2[, paste0("bc_", .BASES)])
  
  jacusa2
}