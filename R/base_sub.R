#' Calculates reference base to base call (base substitution).
#' 
#' Calculates and formats base changes for \code{ref} and \code{bc}.
#' All elements in \code{ref} must be all length 1.
#' 
#' @param ref vector of reference bases.
#' @param bc vector of base calls.
#' @return vector of formatted base call substitutions.
#' @examples
#' ref <- c("A", "A", "C", "A")
#' bc <- c("AG", "G", "C", "G")
#' base_sub(ref, bc)
#' @export
base_sub <- function(ref, bc) {
  if (all(nchar(ref) != 1)) {
    stop("All ref elements must be nchar() == 1")
  }
  
  # remove ref in bc
  # goal: A->G instead of A->AG
  bc <- mapply(function(r, o) {
    return(gsub(r, "", o))
  }, ref, bc)
  
  # add nice separator
  sub <- paste(ref, sep = .SUB_SEP, bc)
  # add nice info when there is no change
  sub[ref == bc | bc == ""] <- .SUB_NO_CHANGE
  
  sub
}
