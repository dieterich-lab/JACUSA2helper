#' Calculates base substitution ratio (e.g.: editing frequency).
#' 
#' Calculates base substitution ratio (e.g.: editing frequency) for \code{ref} and base counts stored
#' in nx4 matrix \code{bases}.
#' \code{ref} must have only one reference base. A->G is okay, but AG->G is NOT allowed!
#' If \code{bc} is not provided, count the substitution ratio of the largest non-reference base
#'
#' @param ref vector of reference bases.
#' @param bases matrix of observed base call counts.
#' @param bc vector strings that represent observed base calls. Default: "bases".
#' @return vector of base call substitution ratios.
#' @examples
#' ref <- c("A", "A", "T")
#' # Only one non-ref. base
#' bases <- matrix(c( 1,  0, 9, 0,
#'                    5,  0, 5, 0,
#'                    0, 10, 0, 0),
#'                 ncol = 4, byrow = TRUE)
#' # show base substiTution ratios for observed base calls
#' sub_ratio(ref, bases)
#' 
#' # > one non-ref. base
#' bases <- matrix(c( 1,  2, 9, 1,
#'                    5,  3, 5, 1,
#'                    2, 10, 2, 1),
#'                ncol = 4, byrow = TRUE)
#' # we are only interested in A->G, T->C
#' bc <- c("G", "G", "C")
#' # show base substitution ratios for A->G, T->C
#' sub_ratio(ref, bases, bc)
#' @export
sub_ratio <- function(ref, bases, bc = NULL) {
  colnames(bases) <- .BASES
  if (length(ref) != nrow(bases) | ! is.null(bc) & length(bc) != nrow(bases)) {
    stop("Wrong dim for ref, bases, and/or bc - length(ref) != nrow(bases) | length(ref) != nrow(bc)")
  }
  
  tmp <- .helper(ref, bases, bc)
  bc <- tmp$bc
  variant_bc <- tmp$variant_bc
  
  # create variable to index 
  # rows(1:length(variant_bc) and 
  # cols(match(variant_bc, BASES))
  # simultaneously in a matrix
  i <- cbind(1:length(variant_bc), match(variant_bc, .BASES))
  # ratio := #variant BC / sum(BC)
  sub_ratio <- as.matrix(bases)[i] / rowSums(bases)
  # provide nice default value if ratio not defined
  sub_ratio[is.na(sub_ratio) | ref == variant_bc] <- 0.0
  
  sub_ratio
}
#' Calculates base substitution counts 
#' 
#' Calculates base substitution counts for \code{ref} and base counts stored
#' in nx4 matrix \code{bases}.
#' \code{ref} must have only one reference base. A->G is okay, but AG->G is NOT allowed!
#' If \code{bc} is not provided, count the substitutions of the largest non-reference base
#'
#' @param ref vector of reference bases.
#' @param bases matrix of observed base call counts.
#' @param bc vector strings that represent observed base calls. Default: "bases".
#' @return vector of base call substitution counts
#' @examples
#' ref <- c("A", "A", "T")
#' # Only one non-ref. base
#' bases <- matrix(c( 1,  0, 9, 0,
#'                    5,  0, 5, 0,
#'                    0, 10, 0, 0),
#'                 ncol = 4, byrow = TRUE)
#' # show base substitution counts for observed base calls
#' sub_counts(ref, bases)
#' 
#' # > one non-ref. base
#' bases <- matrix(c( 1,  2, 9, 1,
#'                    5,  3, 5, 1,
#'                    2, 10, 2, 1),
#'                 ncol = 4, byrow = TRUE)
#' # we are only interested in A->G, T->C
#' bc <- c("G", "G", "C")
#' # show base substitution counts for A->G, T->C
#' sub_counts(ref, bases, bc)
#' @export
sub_counts <- function(ref, bases, bc = NULL) {
  colnames(bases) <- .BASES
  tmp <- .helper(ref, bases, bc)
  bc <- tmp$bc
  variant_bc <- tmp$variant_bc

  # create variable to index 
  # rows(1:length(variant_bc) and 
  # cols(match(variant_bc, BASES))
  # simultaneously in a matrix
  i <- cbind(1:length(variant_bc), match(variant_bc, .BASES))
  j <- cbind(1:length(ref), match(ref, .BASES))
  data.frame(mis=bases[i], ref=bases[j])
}

.helper <- function(ref, bases, bc = NULL) {
  bc <- bc
  if (is.null(bc)) {
    d <- t(apply(bases, 1, sort.int, decreasing=TRUE, method = "quick"))
    bc <- apply(bases==d[,2], 1, function(m) { 
      return(paste0(.BASES[m][1], collapse = "")) 
    })
  }
  
  # calculates the variant base between ref and bc
  variant_bc <- mapply(function(r, o) {
    # remove reference base - only the variant base should remain
    v <- gsub(r, "", o)
    if (nchar(v) == 0) {
      v <- r
    }
    if (nchar(v) >= 2) {
      stop("More than 2 alleles not supported! ref: ", r, " observed BCs; ", o)
    }
    
    return(v)
  }, ref, bc, USE.NAMES = FALSE)
  
  list(bc=bc, variant_bc=variant_bc)
}
