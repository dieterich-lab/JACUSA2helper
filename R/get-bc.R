#' Calculate base call change for RDD comparisons of JACUSA result file.
#' 
#' In the context of RDD detection, it is assumed that condition 1 represents the DNA and 
#' condition 2 the RNA.
#' 
#' @param bc1 Vector of base calls for condition 1.
#' @param bc2 Vector of base calls for condition 2.
#' @param sep String: "bc1"sep"bc2".
#' @return Vector of base call changes for condition 1 and 2.
#' 
#' @export
get_bc_change <- function(bc1, bc2, sep = .BC_CHANGE_SEP) {
  bc2 <- mapply(function(dna, rna) {
    gsub(dna, "", rna)
  }, bc1, bc2)
  format_bc_change(bc1, bc2, sep = sep)
}

#' Calculates base call change ratio (e.g.: editing frequency) for RDDs in a JACUSA result file. 
#' 
#' Calculates base call change ratio (e.g.: editing frequency) for RDDs in a JACUSA result file. 
#'
#' @param bc1 Vector of base calls for condition 1.
#' @param bc2 Vector of base calls for condition 2.
#' @param bc_matrix2 Base call matrix or list of base call matrices.
#' 
#' @return Returns vector of base call change ratios average and against all 
#' replicates of condition 2.
#'
#' @export
get_bc_change_ratio <- function(bc1, bc2, bc_matrix2) {
  # variant base
  v <- mapply(function(x, y) { gsub(x, "", y) }, bc1, bc2, USE.NAMES = FALSE)
  i <- match(v, .BASES)
  
  if (is.list(bc_matrix2)) {
    ratio <- lapply(bc_matrix2, function(m) {
      r <- m[cbind(1:nrow(m), i)] / rowSums(m)
      r[is.na(r)] <- 0.0
      r
    })
    l <- list()
    for (j in c(1:length(bc_matrix2))) {
      l[[paste0("bc_change_ratio", j)]] <- ratio[[j]]
    }
    ratio <- do.call(cbind, ratio)
    ratio <- rowMeans(ratio)
    l[["bc_change_ratio"]] <- ratio
    l
  } else {
    ratio <- bc_matrix2[cbind(1:nrow(bc_matrix2), i)] / rowSums(bc_matrix2)
    ratio[is.na(ratio)] <- 0.0
    list(bc_change_ratio = ratio,
         bc_change_ratio1 = ratio)
  }
}

#' Get index of variant sites that have a variant base contained in all 
#' replicates of at least one condition.
#'
#' Get index of variant sites that have a variant base contained in all 
#' replicates of at least one condition.
#'
#' @param bc_matrix1 Base call matrix of list of base call matrices for condition 1.
#' @param bc_matrix2 Base call matrix of list of base call matrices for condition 2.
#'
#' @return Returns the index of sites where the variant base is contained in all 
#' replicates of one condition.
#'
#' @export
get_robust_variant_index <- function(bc_matrix1, bc_matrix2) {
  get_mask <- function(m, op = "&") {
    any_bases <- function(m) {
      t(apply(m, 1, function(x) {
        x > 0
      }))
    }
    if (is.list(m)) {
      m <- lapply(m, any_bases)
      m <- Reduce(op, m)
    } else {
      m <- any_bases(m)
    }
    m
  }

  combined <- list()
  if (! is.list(bc_matrix1)) {
    bc_matrix1 <- list(bases11 = bc_matrix1)
  }
  if (! is.list(bc_matrix2)) {
    bc_matrix2 <- list(bc_matrix2)
  }
  combined <- c(bc_matrix1, bc_matrix2)
  
  mask <- get_mask(combined, op = "|")
  mask1 <- get_mask(bc_matrix1)
  mask2 <- get_mask(bc_matrix2)
  
  b <- (mask1 | mask2) == mask
  i <- apply(b, 1, function(x) {
    all(x)
  })
  i
}

#' Calculates the number of variant reads in JACUSA results files
#'
#' Calculates the number of variant reads in JACUSA result files of gDNA vs. cDNA comparisons.
#' Per default gDNA is expected to be condition 1 and cDNA to be condition 2!
#'
#' @param bc1 Vector of base calls in condition 1.
#' @param bc2 Vector of base calls in condition 2.
#' @param bc_matrix2 Base call matrix or list of base call matrices.
#' 
#' @return Returns List of count that represent the number of variant reads in condition 2
#' 
#' @export 
get_variant_count <- function(bc1, bc2, bc_matrix2) {
  if (any(nchar(bc1) >= 2)) { stop("Too many (>=2) alleles for condition 1") }
  
  # variant base
  v <- mapply(function(x, y) { gsub(x, "", y) }, bc1, bc2, USE.NAMES = FALSE)
  i <- match(v, c(.BASES))
  
  count <- c()
  if (is.list(bc_matrix2)) {
    count <- lapply(bc_matrix2, function(m) {
      m[cbind(1:nrow(m), i)]
    })
  } else {
    count <- bc_matrix2[cbind(1:nrow(bc_matrix2), i)]
  }
  count
}