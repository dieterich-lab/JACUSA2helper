#' Get number of alleles within a vector of bases
#' 
#' Gives the number of alleles within a vectors of bases.
#' For a vector such as c("AG", "A") it returns 2.
#' 
#' @importFrom magrittr %>%
#' @param bc vector of bases
#' @return thu unique numner of observed alleles
#' @export
get_alleles <- function(bc) {
  alleles <- bc %>%
    strsplit("") %>%
    unlist() %>%
    unique() %>%
    length()
  
  alleles
}

#' Merge base change entries
#' 
#' TODO
#' 
#' @param ref_base2bc vector of base changes
#' @param sep character vector that separates base changes
#' @param no_change character vector when there is no base change
#' @return character vector of merged base changes
#' @export
merge_ref_base2bc <- function(ref_base2bc, sep = BC_CHANGE_SEP, no_change = BC_CHANGE_NO_CHANGE) {
  # remove duplicates and no change information
  ref_base2bc <- unique(ref_base2bc[ref_base2bc != no_change])

  if (length(ref_base2bc) == 0) {
    return(no_change)
  }

  # format of m: 1. column ref. base, 2. column observed non-ref. base
  m <- do.call(rbind, strsplit(tmp, sep))
  ref_base <- m[, 1]
  observed_bc <- m[, 2]

  if (length(unique(ref_base)) != 1) {
    stop("Reference base required to be identical for all observations": ref_base2bc)
  }
  ref_base <- unique(ref_base)
  observed_bc <- paste0(sort(observed_bc), collapse = "")

  format_bc_change(ref_base, observed_bc, sep, no_change)
}

#' Get number of primary sites
#' 
#' Retrieves the number of primary sites - unsplit and unique coordinates (TODO).
#' 
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()}
#' @return intger the numner of primary sites
#' 
#' @export
get_primary_sites <- function(result) {
  # retain only primary sites/rows
  result <- result %>% 
    dplyr::filter(primary & base_type == "total")
  sites <- result %>% 
    dplyr::group_by("meta_condition") %>%
    tally()
  
  sites
}

#' Calculate base changes
#' 
#' Calculates and formats base changes for provided reference bases and observed base calls.
#' 
#' @param ref_base vector of reference bases.
#' @param observed_bc vector of base calls.
#' @param sep character vector: "ref_base"sep"observed_bcs".
#' @param no_change character vector: how to format no changes.
#' @return Vector of base call changes.
#' 
#' @export
get_bc_change <- function(ref_base, observed_bc, sep = BC_CHANGE_SEP, no_change = BC_CHANGE_NO_CHANGE) {
  observed_bc <- mapply(function(r, o) {
    gsub(r, "", o)
  }, ref_base, observed_bc)
  format_bc_change(ref_base, observed_bc, sep = sep, no_change)
}

#' Format base change / base substitution.
#'
#' Formats base change (e.g.: RNA editing) for two base vectors.
#'
#' @param base1 vector of bases: reference
#' @param base2 vector of bases: observed bases.
#' @param sep string: "base1"sep"base2".
#' @param no_change character vector: how to format no change.
#' 
#' @return Vector of base changes.
#'
#' @export
format_bc_change <- function(base1, base2, sep = BC_CHANGE_SEP, no_change = BC_CHANGE_NO_CHANGE) {
  bc_change <- paste(base1, sep = sep, base2)
  bc_change[base1 == base2 | base2 == ""] <- no_change
  
  bc_change
}

#' Calculates base call change ratio (e.g.: editing frequency).
#' 
#' Calculates base call change ratio (e.g.: editing frequency).
#'
#' @param ref_base vector of reference bases.
#' @param bc_matrix matrix of observed base calls.
#' @return Returns vector of base call change ratios.
#'
#' @export
get_bc_change_ratio <- function(ref_base, bc_matrix) {
  colnames(bc_matrix) <- BASES
  observed_bc <- apply(bc_matrix > 0, 1, function(m) { paste0(BASES[m], collapse = "") })

  # TODO
  # check that number of alleles <= 2 for each row
  
  variant_bc <- mapply(function(r, o) {
    # only the variant base should remain
    v <- gsub(r, "", o)
    # add refbase to maintain correct index, see i <- [...]
    if (nchar(v) == 0) {
      v <- r
    }
    if (nchar(v) >= 2) {
      stop("More than 2 alleles not supported! ref: ", r, " observed BCs; ", o)
    }
    
    v
  }, ref_base, observed_bc, USE.NAMES = FALSE)
  
  i <- cbind(1:length(variant_bc), match(variant_bc, BASES))
  # base change ratio := #variant BC / sum(BC)
  bc_change_ratio <- as.matrix(bc_matrix)[i] / rowSums(bc_matrix)
  bc_change_ratio[is.na(bc_change_ratio) | ref_base == variant_bc] <- 0.0
  
  bc_change_ratio
}
