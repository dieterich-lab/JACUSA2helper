# convenience: All possible bases
.BASES <- c("A", "C", "G", "T")
.EMPTY <- "*"
# convenience: DNA "->" RNA 
.BC_CHANGE_SEP <- "->"
.BC_CHANGE_NO_CHANGE <- "no change"

# Helpers defining supported types by JACUSA2.x
.UNKNOWN_METHOD_TYPE <- "unknown"
# call and pileup cannot be distiguished by output
.CALL_PILEUP_METHOD_TYPE <- "call-pileup"
.RT_ARREST_METHOD_TYPE <- "rt-arrest"
.LRT_ARREST_METHOD_TYPE <- "lrt-arrest"

# convenience: description data fields
.CALL_PILEUP_COLUMN <- "bases"
.RT_ARREST_COLUMN <- "arrest_bases"
.RT_THROUGH_COLUMN <- "through_bases"
.LRT_ARREST_COLUMN <- "arrest_bases"
.LRT_THROUGH_COLUMN <- "through_bases"
.LRT_ARREST_POS_COLUMN <- "arrest_pos"

# convenience: description info fields
.INFO_COLUMN <- "info"
.FILTER_INFO_COLUMN <- "filter_info"

# get unique base calls from a vector of base calls
.get_unique_base_calls <- function(bcs) {
  base_calls <- bcs %>% 
    paste0() %>% 
    strsplit("") %>% 
    unlist() %>% 
    unique()
    
  base_calls
}

# apply boolean operator "&","|" on all columns 
.get_mask <- function(mat, op) {
  mat <- t(apply(mat, 1, function(x) { x > 0 }))
  if (op == "all") {
    mat <- t(apply(mat, 2, all))
  } else if (op == "any") {
    mat <- t(apply(mat, 2, any))
  } else {
    stop("Unknown op: ", op)
  }
  
  mat
}

# get number of alleles from a vector of base calls
.get_alleles <- function(bcs) {
  allele_count <- length(.get_unique_base_calls(bcs))
  
  allele_count
}
