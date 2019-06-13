#' Calculate base call change for RDD comparisons.
#' 
#' TODO
#' 
#' @param ref_base Vector of reference bases.
#' @param observed_bc Vector of base calls.
#' @param sep String: "ref_base"sep"observed_bcs".
#' @return Vector of base call changes.
#' 
#' @export
get_bc_change <- function(ref_base, observed_bc, sep = .BC_CHANGE_SEP) {
  observed_bc <- mapply(function(r, o) {
    gsub(r, "", o)
  }, ref_base, observed_bc)
  format_bc_change(ref_base, observed_bc, sep = sep)
}

#' Format base change / base substitution.
#'
#' Formats base change (e.g.: RNA editing) for two base vectors.
#'
#' @param base1 Vector of bases: DNA.
#' @param base2 Vector of bases: RNA.
#' @param sep String: "base1"sep"base2".
#' @param no_change String: how to format no changes.
#' 
#' @return Vector of base changes.
#'
#' @export
format_bc_change <- function(base1, base2, sep = .BC_CHANGE_SEP, no_change = .BC_CHANGE_NO_CHANGE) {
  bc_change <- paste(base1, sep = sep, base2)
  bc_change[base1 == base2 | base2 == ""] <- no_change
  
  bc_change
}

#' Calculates base call change ratio (e.g.: editing frequency).
#' 
#' Calculates base call change ratio (e.g.: editing frequency).
#'
#' @param ref_base Vector of reference bases.
#' @param bc_matrix Observed base call matrix.
#' 
#' @return Returns vector of base call change ratios.
#'
#' @export
get_bc_change_ratio <- function(ref_base, bc_matrix) {
  colnames(bc_matrix) <- .BASES
  observed_bc <- apply(bc_matrix > 0, 1, function(m) { paste0(.BASES[m], collapse = "") })
  variant_bc <- mapply(function(r, o) {
    # only the variant base should remain
    v <- gsub(r, "", o)
    if (nchar(v) == 0) { # add refbase to maintain correct index, see i <- [...]
      v <- r
    }
    if (nchar(v) >= 2) {
      stop("More than 2 alleles not supported! ref: ", r, " observed BCs; ", o)
    }
        
    v
  }, ref_base, observed_bc, USE.NAMES = FALSE)
  
  # index
  i <- cbind(1:length(variant_bc), match(variant_bc, .BASES))
  # base change ratio := #variant BC / sum(BC)
  bc_change_ratio <- bc_matrix[i] / rowSums(bc_matrix)
  bc_change_ratio[is.na(bc_change_ratio) | ref_base == variant_bc] <- 0.0
  
  bc_change_ratio
}

# helper function
get_robust_variants <- function(condition, bc_A, bc_C, bc_G, bc_T) {
  # combind individual base call vectors
  mat <- matrix(c(bc_A, bc_C, bc_G, bc_T), ncol = 4, byrow = FALSE)

  mask <- .get_mask(mat, op = "any")
  mask1 <- .get_mask(mat[condition == 1, , drop = FALSE], op = "all")
  mask2 <- .get_mask(mat[condition != 1, , drop = FALSE], op = "all")
  
  robust <- (mask1 | mask2) == mask
  
  all(robust)
}
