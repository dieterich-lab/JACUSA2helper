#' Calculate allele count per site.
#'
#' Calculate allele count per site.
#'
#' @param bc_matrix1 Base call matrix or list of base call matrices for condition 1.
#' @param bc_matrix2 Base call matrix or list of base call matrices for condition 2.
#' @param max_alleles Integer number of maximal alleles per site.
#'
#' @return Returs JACUSA list object with sites where max_alleles is obeyed.
#' 
#' @export
get_allele_count <- function(bc_matrix1, bc_matrix2, max_alleles = 2) {
  bcs1 <- get_bcs(bc_matrix1)
  bcs2 <- get_bcs(bc_matrix2)

  mapply(function(bc1, bc2) {
    length(unique(c(bc1, bc2)))
  }, bcs1, bcs2)
}

#' Get string encoded base call counts for a condition from a JACUSA result file
#'
#' \code{get_bc_str4condition()} returns string encoded base call counts columns for one condition (1 or 2) from a JACUSA result file.
#'
#' @param jacusa List object created by \code{read_jacusa()}.
#' @param condition Integer value: 1 or 2.
#'
#' @return Returns a JACUSA list object of string encoded base calls counts.
#'
#' @examples
#' ## Read JACUSA result file hek293_untreated.out
#' ## Extract string encoded base calls for condition 1. 
#' bc_str1 <- get_bc_str4condition(rdd, 1)
#' 
#' @export
get_bc_str4condition <- function(jacusa, condition) {
  condition <- paste("bases", condition, sep = "")
  j <- grep(condition, names(jacusa))
  if (length(j) > 1) {
    jacusa[j]
  } else {
    jacusa[[j]]
  }
}

#' Calculate observed base calls from base call matrix or a list of base call matrices.
#'
#' Calculate observed base calls from base call matrix or a list of base call matrices.
#'
#' @param bc_matrix Base call matrix or list of bc matrices.
#' 
#' @return Returns vector of strings of observed base calls in m.
#'
#' @export
get_bc <- function(bc_matrix) {
  b <- get_bcs(bc_matrix)
  b <- lapply(b, paste, collapse = "")
  b <- unlist(b)
  b
}

#' Calculate observed base calls from base call matrix or a list of base call matrices.
#'
#' Calculate observed base calls from base call matrix or a list of base call matrices.
#'
#' @param bc_matrix Base call matrix or list of bc matrices.
#' 
#' @return Returns list of string vector of observed base calls in m.
#'
#' @export
get_bcs <- function(bc_matrix) {
  if (is.list(bc_matrix)) {
    bc_matrix <- Reduce('+', bc_matrix)
  }
  a <- apply(bc_matrix, 1, function(x) { 
    names(x)[x > 0]
  } )
  if (is.matrix(a)) {
    l <- split(a, rep(1:ncol(a), each = nrow(a)))
    l <- unname(l)
  } else if (is.vector(a)) {
    l <- as.list(a)
  }
  l
}

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