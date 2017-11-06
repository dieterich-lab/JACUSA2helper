
#' Helper function - create VCF
#' Convert JACUSA output to VCF format
#'
#' This converts JACUSA output to VCF file format
#'
#' @param jacusa List object created by \code{read_jacusa}.
#' @param ref Vector of characters.
#' @param invert Logical indicates if on "-" strand complementary base calls 
#' should be calculated.
#'
#' @return Data frame that represents JACUSA list object in VCF file format.
#'
#' #@export
JACUSA2VCF <- function(jacusa, ref, invert = FALSE) {
  if (any(nchar(ref) >= 2)) { stop("Too many (>=2) alleles for reference base") }
  
  chrom <- jacusa$"contig"
  pos <- jacusa$"end"
  strand <- jacusa$"strand"
  
  # when JACUSA.jar is run with stranded library type option "-P FR-FIRSTSTRAND,FR-FIRSTSTRAND"
  # complementary base call will be calculated where necessary
  if (invert) {
    i <- strand == "-"
    if (length(which(i)) > 0) {
      # invert reference base call on "-" strand
      tmp <- get_comp_bcs(ref[i])
      ref[i] <- unlist(tmp, use.names = FALSE)
      
      alt <- get_bcs(jacusa$bc_matrix2)
      tmp <- lapply(get_comp_bcs(alt[i]), paste0)
      tmp <- mapply(function(x, y) { 
        gsub(x, "", y)
      }, ref[i], tmp, SIMPLIFY = TRUE, use.names = FALSE)
      alt[i] <- tmp
    }
  } else {
    alt <- get_bc(jacusa$bc_matrix2)
    # remove ref base from alt
    alt <- mapply(function(x, y) { 
      gsub(x, "", y)
    }, ref, alt, SIMPLIFY = TRUE, USE.NAMES = FALSE)  
  }
  n <- length(jacusa$contig)
  
  FILTER <- rep(".", n)
  if (! is.null(jacusa$filter_info)) {
    FILTER <- jacusa$filter_info
    FILTER[FILTER == "*"] <- "PASS"
  }
  
  data.frame("#CHROM" = chrom, 
             POS = pos, 
             ID = jacusa$name, 
             REF = ref, 
             ALT = alt, 
             QUAL = rep(".", n), 
             FILTER = FILTER, 
             check.names = FALSE)
}

# TODO
write_VCF <- function(VCF) {
  
}