# fields to store in attributes 
METHOD_TYPE <- "method_type"
HEADER <- "header"
UNPACKED <- "unpacked"

# convenience: All possible bases
BASES <- c("A", "C", "G", "T")
EMPTY <- "*"

# convenience: DNA "->" RNA 
BC_CHANGE_SEP <- "->"
# no change between DNA and RNA: "A -> A" transformed to "no change"
BC_CHANGE_NO_CHANGE <- "no change"
# when interested only in specific base change, e.g.: A->G, the remaining are termed:
BC_CHANGE_OTHER <- "other"

# Helpers defining supported types by JACUSA2
UNKNOWN_METHOD_TYPE <- "unknown"
# call and pileup cannot be distiguished by output
CALL_PILEUP_METHOD_TYPE <- "call-pileup"
RT_ARREST_METHOD_TYPE <- "rt-arrest"
LRT_ARREST_METHOD_TYPE <- "lrt-arrest"
#
SUPPORTED_METHOD_TYPES <- c(
  CALL_PILEUP_METHOD_TYPE, 
  RT_ARREST_METHOD_TYPE, 
  LRT_ARREST_METHOD_TYPE
)

# JACUSA2 CLI option -B
READ_SUB_COLUMN <- "read_sub"
READ_SUB_MARKED <- "marked"
READ_SUB_UNMARKED <- "unmarked"

# method specific column:
BASES_COLUMN <- "bases"
ARREST_COLUMN <- "arrest"
THROUGH_COLUMN <- "through"
#
ARREST_POS_COLUMN <- "arrest_pos"

# definition of a site
SITE <- c("contig", "start", "end", "strand")

COVERAGE <- "cov"
BC <- "bc"
BC_RATIO <- "bc_ratio"
BASE_SUB <- "sub"
BASE_SUB_RATIO <- "sub_ratio"
NON_REF_RATIO <- "non_ref_ratio"

CONDITION_COLUMN <- "cond"
REPLICATE_COLUMN <- "repl"
META_CONDITION_COLUMN <- "meta_cond"

ARREST_RATE <- "arrest_rate"

FIX_NUMERIC_COLUMNS <- c("arrest_score")

# a JACUSA2 result file is structured in:
# BED_COLUMNS,"method specific columns",INFO_COLUMN,FILTER_INFO_COLUMN,REF_BASE_COLUMN
BED_COLUMNS <- c("contig", "start", "end", "name", "score", "strand")
# convenience: info fields
INFO_COLUMN <- "info"
FILTER_INFO_COLUMN <- "filter"
REF_BASE_COLUMN <- "ref"
