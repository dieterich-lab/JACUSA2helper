# fields to store in attributes 
METHOD_TYPE <- "jacusa_method_type"
HEADER <- "jacusa_header"
UNPACKED <- "jacusa_unpacked"

# convenience: All possible bases
BASES <- c("A", "C", "G", "T")
EMPTY <- "*"

# convenience: DNA "->" RNA 
BC_CHANGE_SEP <- "->"
# no change between DNA and RNA: "A -> A" transformed to "no change"
BC_CHANGE_NO_CHANGE <- "no change"
# when interested only in specific base change, e.g.: A->G, the remaining are termed other
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

# method specific column:
BASES_COLUMN <- "bases"
ARREST_COLUMN <- "arrest_bases"
THROUGH_COLUMN <- "through_bases"
#
ARREST_POS_COLUMN <- "arrest_pos"

# definition of a site
SITE <- c("contig", "start", "end", "strand")
OPT_SITE_VARS <- c("meta_condition", ARREST_POS_COLUMN) #  TODO add factor for base stratification

# a JACUSA2 result file is structured in:
# BED_COLUMNS,"method specific columns",INFO_COLUMN,FILTER_INFO_COLUMN,REF_BASE_COLUMN
BED_COLUMNS <- c("contig", "start", "end", "name", "score", "strand")
# convenience: info fields
INFO_COLUMN <- "info"
FILTER_INFO_COLUMN <- "filter_info"
REF_BASE_COLUMN <- "ref_base"
