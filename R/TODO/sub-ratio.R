#' Calculates base substitution ratio (e.g.: editing frequency).
#' 
#' Calculates base substitution ratio (e.g.: editing frequency) for \code{ref} and base counts stored
#' in nx4 matrix \code{bases}.
#' \code{ref} must have only one reference base. A->G is okay, but AG->G is NOT allowed!
#' If \code{bc} is not provided, count the substitution ratio of the largest non-reference base
#' (@seealso \code{max_observed_bc}). Make sure that number of alleles in ref(erence) and bases
#' is 2 at maximum.
#' 
#' @param ref vector of reference bases.
#' @param bases matrix of observed base call counts.
#' @param bc vector strings that represent observed base calls. Default: NULL.
#' @return vector of base call substitution ratios.
#' @examples
#' ref <- c("A", "A", "T")
#' # Only one non-ref. base
#' bases <- matrix(c( 1,  0, 9, 0,
#'                    5,  0, 5, 0,
#'                    0, 10, 0, 0),
#'                 ncol = 4, byrow = TRUE)
#' # show base substitution ratios for observed base calls
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
  l <- .helper(ref, bases, bc)
  
  # ratio := #variant BC / sum(BC)
  sub_ratio <- as.matrix(bases)[l$i] / rowSums(bases)
  # provide nice default value if ratio not defined
  sub_ratio[is.na(sub_ratio) | ref == l$variant_bc] <- 0.0
  
  sub_ratio
}

#' Calculates base substitution counts 
#' 
#' Calculates base substitution counts for \code{ref} and base counts stored
#' in nx4 matrix \code{bases}.
#' \code{ref} must have only one reference base. A->G is okay, but AG->G is NOT allowed!
#' If \code{bc} is not provided, count the substitutions of the largest non-reference base 
#' (@seealso \code{max_observed_bc}). Make sure that number of alleles in ref(erence) and bases
#' is 2 at maximum.
#'
#' @param ref vector of reference bases.
#' @param bases matrix of observed base call counts.
#' @param bc vector strings that represent observed base calls. Default: NULL.
#' @return vector of base call substitution counts.
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
  l <- .helper(ref, bases, bc)
  return(bases[l$i])
}

.helper <- function(ref, bases, bc) {
  colnames(bases) <- .BASES
  if (is.null(bc)) {
    bc <- max_observed_bc(bases)
    i <- nchar(bc) == 0
    if (any(i)) {
      bc[i] <- ref[i]
    }
  }

  variant_bc <- variant_bc(ref, bc)
  
  # create variable to index 
  # rows(1:length(variant_bc) and 
  # cols(match(variant_bc, BASES))
  # simultaneously in a matrix
  i <- cbind(1:length(variant_bc), match(variant_bc, .BASES))
  
  list(variant_bc=variant_bc, i=i)
}
  
#' Calculates observed base calls
#' 
#' Calculates observed base call counts stored in nx4 matrix \code{bases}.
#' 
#' @param bases matrix of observed base call counts.
#' @return vector of observed base calls.
#' @examples
#' bases <- matrix(c( 1,  0, 9, 0,
#'                    5,  0, 5, 0,
#'                    0, 10, 0, 0),
#'                 ncol = 4, byrow = TRUE)
#' # show observed base call counts
#' observed_bc(bases)
#' @export
observed_bc <- function(bases) {
  apply(bases, 1, function(m) { 
    return(paste0(.BASES[m > 0], collapse = ""))
  })
}

#' Calculates most frequent base calls
#' 
#' Calculates most frequent base call counts from a nx4 matrix \code{bases}.
#' Provide \code{ref} to ignore reference base call counts.
#' 
#' @param bases matrix of observed base call counts.
#' @param ref vector of reference bases. Default: NULL.
#' @return vector of most frequent base call counts.
#' @examples
#' bases <- matrix(c( 1,  0, 9, 0,
#'                    5,  0, 5, 0,
#'                    0, 10, 0, 0),
#'                 ncol = 4, byrow = TRUE)
#' ref <- c("A", "A", "C")
#' # show most frequent base call counts
#' max_observed_bc(bases, ref)#'
#' @export
max_observed_bc <- function(bases, ref = NULL) {
  colnames(bases) <- .BASES
  if (! is.null(ref)) {
    if (length(ref) != nrow(bases)) {
      stop("length(ref) != nrow(bases)")
    }
    # remove count for ref-bases -> we want max. non-ref-bases
    bases[cbind(1:nrow(bases), match(ref, .BASES))] <- 0
  }
  
  bases <- apply(bases, 1, function(x) {
    if (all(x == 0)) {
      return("")
    }
    i <- which(x == max(x))
    if (any(i)) {
      return(paste0(.BASES[i], collapse = ""))
    }
    return("")
  })

  bases
}

#' Calculates non-reference base calls
#' 
#' Calculates non-reference base call counts from a vector \code{bc} and 
#' \code{ref}(ference) bases. Make sure the combination of base calls and 
#' reference bases <= 2 alleles.
#' 
#' @param ref vector of reference bases..
#' @param bc vector of base calls.
#' @return vector of most frequent base call counts.
#' @examples
#' ref <- c("A", "A")
#' bc <- c("A", "AG")
#' # show non-reference base calls
#' variant_bc(ref, bc)
#' @export
variant_bc <- function(ref, bc) {
  mapply(function(r, o) {
    v <- gsub(r, "", o)
    if (nchar(v) >= 2) {
      stop("More than 2 alleles not supported! ref: ", r, " observed BCs; ", o)
    }
    
    return(v)
  }, ref, bc, USE.NAMES = FALSE)
}
