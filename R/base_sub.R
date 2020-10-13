#' Calculates reference base to base call (base substitution).
#' 
#' Calculates and formats base changes for \code{ref} and \code{bc}.
#' All elements in \code{ref} must be all length 1.
#'
#' @param ref vector of reference bases.
#' @param bases vector of base calls or tibble of base call counts.
#' @return vector of formatted base call substitutions.
#' @examples
#' ref <- c("A", "A", "C", "A")
#' bases <- c("AG", "G", "C", "G")
#' base_sub(ref, bases)
#' @export
base_sub <- function(ref, bases) {
  if (all(nchar(ref) != 1)) {
    stop("All ref elements must be nchar() == 1")
  }
  if (! is.vector(bases)) {
    bases <- base_call(bases)
  }
  
  # remove ref in bc
  # goal: A->G instead of A->AG
  bases <- mapply(function(r, o) {
    return(gsub(r, "", o))
  }, ref, bases)
  
  # add nice separator
  sub <- paste(ref, sep = .SUB_SEP, bases)
  # add nice info when there is no change
  sub[ref == bases | bases == ""] <- .SUB_NO_CHANGE
  
  sub
}
