# convenience: All possible bases
.BASES <- c("A", "C", "G", "T")
.EMPTY <- "*"
# convenience: DNA "->" RNA 
.SUB_SEP <- "->"
# no change between DNA and RNA: "A -> A" transformed to "no change"
.SUB_NO_CHANGE <- "no change"
# when interested only in specific base change, e.g.: A->G, the remaining are termed:
.SUB_OTHER <- "other"

# Helpers defining supported types by JACUSA2.x
.UNKNOWN_METHOD <- "unknown"
# call and pileup cannot be distinguished by output
.CALL_PILEUP <- "call-pileup"
.RT_ARREST <- "rt-arrest"
.LRT_ARREST <- "lrt-arrest"

.ATTR_TYPE <- "JACUSA2.type"
.ATTR_HEADER <-"JACUSA2.header"
.ATTR_COND_DESC <- "JACUSA2.cond_desc"


# convenience: description data fields
.CALL_PILEUP_COL <- "bases"

.ARREST_DATA_COL <- "arrest"
.ARREST_HELPER_COL <- "arrest"
.THROUGH_DATA_COL <- "through"
.THROUGH_HELPER_COL <- "through"

.LRT_ARREST_POS_COL <- "arrest_pos"

# convenience: description info fields
.INFO_COL <- "info"
.FILTER_INFO_COL <- "filter"
.REF_BASE_COL <- "ref"

# JACUSA2 CLI option -B
.SUB_TAG_COL <- "sub_tag"

.ARREST_RATE_COL <- "arrest_rate"
.META_COND_COL <- "meta_cond"

.COV <- "cov"
.BC <- "bc"
.SUB <- "sub"
.SUB_RATIO <- "sub_ratio"
.NON_REF_RATIO <- "non_ref_ratio"

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



