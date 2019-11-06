#' Merges base substitutions.
#' 
#' Usefull, when creating summaries for base changes with \code{add_summary()}.
#' Merging base changes with different reference bases is not allowed.
#' However, base changes with different non-reference bases can be merged, e.g.: c("A->G", "A->C")
#' will be merged to "A->CG"
#' 
#' @importFrom magrittr %>%
#' @param subs vector of base substitutions.
#' @return merged base substitutions.
#' @examples
#' sub <- c("A->G", "A->G")
#' # result: A->G
#' merge_sub(sub)
#' # result: A->CG
#' sub <- c("A->G", "A->C")
#' merge_sub(sub)
#' @export
merge_sub <- function(subs) {
  # remove duplicates and no change information
  subs <- unique(subs[subs != BC_CHANGE_NO_CHANGE])
  if (length(subs) == 0) {
    return(BC_CHANGE_NO_CHANGE)
  }

  # important decision!!!
  # merge A->G and other to: ?
  # 1. A->G
  # 2. other
  # 3. error (currently)
  if (any(subs %in% BC_CHANGE_OTHER)) {
    if (all((subs %in% BC_CHANGE_OTHER))) {
      return(BC_CHANGE_OTHER)
    }
    stop(
      "Cannot merge: ", 
      paste(subs[! subs %in% BC_CHANGE_OTHER], collapse = ","),
      " and ", BC_CHANGE_OTHER
    )
  }

  # format of m: 1. column ref. base, 2. column observed non-ref. base
  m <- do.call(rbind, strsplit(subs, BC_CHANGE_SEP))
  ref <- unique(m[, 1])
  bc <- strsplit(m[, 2], "") %>%
    unlist() %>% 
    unique() %>%
    sort()

  if (length(ref) != 1) {
    stop(
      "Reference base is required to be identical for all observations: ", 
      paste0(subs, collapse = ", ")
    )
  }
  bc <- paste0(sort(bc), collapse = "")

  base_sub(ref, bc)
}

#' Mask a set of base substitutions.
#' 
#' When only a subset of all possibles base substitutions is interesting, the remaining base substitutions can 
#' be masked. This function will hide the remaining base substitutions by renaming them to \emph{other}.
#' 
#' @importFrom magrittr %>%
#' @param subs vector of base call substitutions.
#' @param keep vector of base call substitutions to be highlighted. All other will be renamed to \emph{other}.
#' @return vector of base call substitutions.
#' subs <- c("A->G", "A->C", "no change")
#' # "A->G" "other" "no change"
#' mask_sub(subs, c("A->G"))
#' 
#' # "other" "other" "no change"
#' mask_sub(subs, c("A->T"))
#' @export
mask_sub <- function(subs, keep) {
  keep <- c(keep, BC_CHANGE_NO_CHANGE)
  i <- subs %in% keep
  if (any(i)) {
    subs[! i] <- BC_CHANGE_OTHER
  }

  subs
}

#' Transform read substitution.
#' 
#' Transforms read substitution. JACUSA2 can stratify reads based on 
#' base substitutions "-B A2G". This function will transform "A2G" to "A->G".
#' 
#' @param subs string vector of read substitutions.
#' @return string vector of base substitution.
#' @examples
#' subs <- c("*", "A2G", "*")
#' clean_read_sub(subs)
#' @export
clean_read_sub <- function(subs) {
  i <- gsub("2", BC_CHANGE_SEP, subs)
}
