#' Returns the number of alleles from a vector of base calls.
#' 
#' Returns the number of alleles from a vector of bases.
#' For a vector such as c("AG", "A") it returns 2.
#' 
#' @importFrom magrittr %>%
#' @param bc vector of base calls.
#' @return number of unique alleles.
#' @export
get_allele_count <- function(bc) {
  alleles <- strsplit(bc, "") %>%
    unlist() %>%
    unique() %>%
    length()
  
  alleles
}

#' Returns the number of primary sites.
#' 
#' Retrieves the number of primary sites.
#' 
#' @importFrom magrittr %>%
#' @importFrom rlang syms
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @return numeric vector or numeric of number of sites.
#' 
#' @export
get_site_count <- function(result) {
  if ("meta_condition" %in% names(result)) {
    result <- dplyr::group_by(result, meta_condition)
  }

  # per primary site there should be ONLY one row with base_type = total
  sites <- dplyr::filter(result, primary == TRUE & base_type == "total") %>% 
    dplyr::distinct(!!!rlang::syms(SITE)) %>%
    dplyr::tally() %>%
    dplyr::ungroup()

  if ("meta_condition" %in% names(result)) {
    return(sites)
  }

  dplyr::pull(sites)
}

#' Calculates reference base to base call (base change).
#' 
#' Calculates and formats base changes for \code{ref_base} and \code{observed_bc}.
#' 
#' @param ref_base vector of reference bases.
#' @param observed_bc vector of base calls.
#' @return vector of formatted base call changes.
#' 
#' @export
get_ref_base2bc <- function(ref_base, observed_bc) {
  if (all(nchar(ref_base) != 1)) {
    stop("all ref_base elements must be nchar() == 1")
  }

  # remove ref_base in observed_bc
  # goal: A->G instead of A->AG
  observed_bc <- mapply(function(r, o) {
    return(gsub(r, "", o))
  }, ref_base, observed_bc)

  # add nice separator
  bc_change <- paste(ref_base, sep = BC_CHANGE_SEP, observed_bc)
  # add nice info when there is no change
  bc_change[ref_base == observed_bc | observed_bc == ""] <- BC_CHANGE_NO_CHANGE

  bc_change
}

#' Calculates base call change ratio (e.g.: editing frequency).
#' 
#' Calculates base call change ratio (e.g.: editing frequency).
#' The following restrictions apply to column "ref_base" and "bc_matrix" apply:
#' \itemize{
#'   \item In "ref_base" must have only one reference base. A->G is okay, but AG->G is NOT allowed!
#'   \item In "bc_matrix" must contain only one non-reference base. A->G is okay, but A->CG is NOT allowed!
#' }
#' Make sure to filter \code{result} with \code{filter_by_alleles()} to comply with this restrictions.
#'
#' @param ref_base vector of reference bases.
#' @param bc_matrix matrix of observed base calls.
#' @return vector of base call change ratios.
#'
#' @export
get_ref_base2bc_ratio <- function(ref_base, bc_matrix) {
  colnames(bc_matrix) <- BASES
  observed_bc <- apply(bc_matrix > 0, 1, function(m) { 
    return(paste0(BASES[m], collapse = "")) 
  })

  # calculates the variant base between ref_base and observed_bc
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
  }, ref_base, observed_bc, USE.NAMES = FALSE)

  # create variable to index 
  # rows(1:length(variant_bc) and 
  # cols(match(variant_bc, BASES))
  # simultaneously in a matrix
  i <- cbind(1:length(variant_bc), match(variant_bc, BASES))
  # ratio := #variant BC / sum(BC)
  ref_base2bc_ratio <- as.matrix(bc_matrix)[i] / rowSums(bc_matrix)
  # provide nice defaut value if ratio not defined
  ref_base2bc_ratio[is.na(ref_base2bc_ratio) | ref_base == variant_bc] <- 0.0

  ref_base2bc_ratio
}

#' Merges base change entries.
#' 
#' TODO
#' 
#' @importFrom magrittr %>%
#' @param ref_base2bc vector of base changes.
#' @return vector of merged base changes.
#' 
#' @export
merge_ref_base2bc <- function(ref_base2bc) {
  # remove duplicates and no change information
  ref_base2bc <- unique(ref_base2bc[ref_base2bc != BC_CHANGE_NO_CHANGE])
  if (length(ref_base2bc) == 0) {
    return(BC_CHANGE_NO_CHANGE)
  }

  # important decision!!!
  # merge A->G and other to: ?
  # 1. A->G
  # 2. other
  # 3. file error (currently)
  if (any(ref_base2bc %in% BC_CHANGE_OTHER)) {
    if (all((ref_base2bc %in% BC_CHANGE_OTHER))) {
      return(BC_CHANGE_OTHER)
    }
    stop(
      "Cannot merge: ", 
      paste(ref_base2bc[! ref_base2bc %in% BC_CHANGE_OTHER], collapse = ","),
      " and ", BC_CHANGE_OTHER
    )
  }

  # format of m: 1. column ref. base, 2. column observed non-ref. base
  m <- do.call(rbind, strsplit(ref_base2bc, BC_CHANGE_SEP))
  ref_base <- unique(m[, 1])
  observed_bc <- strsplit(m[, 2], "") %>%
    unlist() %>% 
    unique() %>%
    sort()

  if (length(ref_base) != 1) {
    stop(
      "Reference base is required to be identical for all observations: ", 
      paste0(ref_base2bc, collapse = ", ")
    )
  }
  observed_bc <- paste0(sort(observed_bc), collapse = "")

  get_ref_base2bc(ref_base, observed_bc)
}

#' Mask a set of base changes.
#' 
#' When only a subset, here captured ny\code{keep}, of all possibles base changes is interesting, 
#' this function will hide the remaining base changes by renaming them to other.
#' 
#' @importFrom magrittr %>%
#' @param ref_base2bc vector of base call changes.
#' @param keep vector of base call changes to be highlighted. All other will be renamed to "other".
#' @return vector of base call changes.
#' 
#' @export
mask_ref_base2bc <- function(ref_base2bc, keep) {
  keep <- c(keep, BC_CHANGE_NO_CHANGE)
  i <- ref_base2bc %in% keep
  if (any(i)) {
    result$ref_base2bc[! i] <- BC_CHANGE_OTHER
  }
}
